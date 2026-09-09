import 'package:drift/drift.dart';

import '../../../core/date/date_only.dart';
import '../../../core/logging/app_logger.dart';
import '../../../data/local/app_database.dart';
import '../../backup/data/backup_repository.dart';
import '../domain/daily_closing_exceptions.dart';
import '../domain/daily_summary.dart';
import 'daily_closing_repository.dart';

class DailyClosingRepositoryImpl implements DailyClosingRepository {
  DailyClosingRepositoryImpl(this._db, this._backup);

  final AppDatabase _db;
  final BackupRepository _backup;

  @override
  Stream<List<DailyClosing>> watchHistory() {
    return (_db.select(_db.dailyClosings)..orderBy([
          (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  @override
  Stream<List<DailyOperationalCost>> watchTodayOperationalCosts() {
    final today = dateOnly(DateTime.now());
    final tomorrow = today.add(const Duration(days: 1));
    return (_db.select(_db.dailyOperationalCosts)
          ..where((t) => t.date.isBetweenValues(today, tomorrow))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
        .watch();
  }

  @override
  Future<void> addOperationalCost({
    required String name,
    required int amountRupiah,
  }) async {
    if (amountRupiah <= 0) {
      throw ArgumentError.value(
        amountRupiah,
        'amountRupiah',
        'Jumlah harus lebih dari 0',
      );
    }
    await _db
        .into(_db.dailyOperationalCosts)
        .insert(
          DailyOperationalCostsCompanion.insert(
            name: name,
            amountRupiah: amountRupiah,
            date: dateOnly(DateTime.now()),
          ),
        );
  }

  @override
  Future<DailySummary> previewToday() async {
    final today = dateOnly(DateTime.now());
    final tomorrow = today.add(const Duration(days: 1));

    final todaysOrders = await (_db.select(
      _db.orders,
    )..where((t) => t.orderedAt.isBetweenValues(today, tomorrow))).get();

    var revenue = 0;
    var hpp = 0;
    var wasteCost = 0;
    var pendingCount = 0;
    for (final order in todaysOrders) {
      switch (order.status) {
        case OrderStatus.completed:
          revenue += order.unitPriceRupiah * order.quantity;
          hpp += order.hppSnapshotRupiah ?? 0;
        case OrderStatus.readyForPickup:
          wasteCost += order.hppSnapshotRupiah ?? 0;
          pendingCount++;
        case OrderStatus.waiting:
        case OrderStatus.cancelled:
        case OrderStatus.wasted:
          break;
      }
    }

    final operationalCost = await _todayOperationalAndSessionCosts(
      today,
      tomorrow,
    );

    return DailySummary(
      revenueRupiah: revenue,
      hppRupiah: hpp,
      operationalCostRupiah: operationalCost,
      projectedWasteCostRupiah: wasteCost,
      ordersPendingPickupCount: pendingCount,
    );
  }

  @override
  Future<DailyClosing> closeToday() async {
    final today = dateOnly(DateTime.now());
    final tomorrow = today.add(const Duration(days: 1));

    final alreadyClosed = await (_db.select(
      _db.dailyClosings,
    )..where((t) => t.date.equals(today))).getSingleOrNull();
    if (alreadyClosed != null) {
      throw const DayAlreadyClosedException();
    }

    final closing = await _db.transaction(() async {
      final todaysOrders = await (_db.select(
        _db.orders,
      )..where((t) => t.orderedAt.isBetweenValues(today, tomorrow))).get();

      var revenue = 0;
      var hpp = 0;
      var wasteCost = 0;
      for (final order in todaysOrders) {
        if (order.status == OrderStatus.completed) {
          revenue += order.unitPriceRupiah * order.quantity;
          hpp += order.hppSnapshotRupiah ?? 0;
        } else if (order.status == OrderStatus.readyForPickup) {
          wasteCost += order.hppSnapshotRupiah ?? 0;
          await (_db.update(_db.orders)..where((t) => t.id.equals(order.id)))
              .write(const OrdersCompanion(status: Value(OrderStatus.wasted)));
        }
      }

      final operationalCost = await _todayOperationalAndSessionCosts(
        today,
        tomorrow,
      );
      final netProfit = revenue - hpp - operationalCost - wasteCost;

      final id = await _db
          .into(_db.dailyClosings)
          .insert(
            DailyClosingsCompanion.insert(
              date: today,
              totalRevenueRupiah: revenue,
              totalHppRupiah: hpp,
              totalOperationalCostRupiah: operationalCost,
              totalWasteCostRupiah: wasteCost,
              netProfitRupiah: netProfit,
            ),
          );

      return (_db.select(
        _db.dailyClosings,
      )..where((t) => t.id.equals(id))).getSingle();
    });

    // Auto-backup on close (B.5) — a natural daily backup with no separate
    // scheduler needed. Runs after the closing transaction commits, and
    // deliberately isn't allowed to undo an already-successful close if it
    // fails (e.g. low disk space): the day is closed either way.
    try {
      await _backup.backupAsDb(trigger: BackupTrigger.autoOnDailyClose);
    } catch (error, stackTrace) {
      // Closing already succeeded; the owner can still back up manually
      // from the Backup screen, so this does not rethrow — but it must
      // not disappear silently either.
      AppLogger.error('Auto-backup on daily close failed', error, stackTrace);
    }

    return closing;
  }

  Future<int> _todayOperationalAndSessionCosts(
    DateTime today,
    DateTime tomorrow,
  ) async {
    final operationalCosts = await (_db.select(
      _db.dailyOperationalCosts,
    )..where((t) => t.date.isBetweenValues(today, tomorrow))).get();
    final operationalTotal = operationalCosts.fold<int>(
      0,
      (sum, cost) => sum + cost.amountRupiah,
    );

    final sessionsToday = await (_db.select(
      _db.productionSessions,
    )..where((t) => t.confirmedAt.isBetweenValues(today, tomorrow))).get();
    if (sessionsToday.isEmpty) return operationalTotal;

    final sessionIds = sessionsToday.map((s) => s.id).toList();
    final sessionCosts = await (_db.select(
      _db.productionSessionCosts,
    )..where((t) => t.sessionId.isIn(sessionIds))).get();
    final sessionCostTotal = sessionCosts.fold<int>(
      0,
      (sum, cost) => sum + cost.amountRupiah,
    );

    return operationalTotal + sessionCostTotal;
  }
}
