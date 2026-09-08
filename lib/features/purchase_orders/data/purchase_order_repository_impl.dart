import 'package:drift/drift.dart';

import '../../../core/date/date_only.dart';
import '../../../data/local/app_database.dart';
import '../domain/po_quota_input.dart';
import '../domain/po_quota_status.dart';
import '../domain/purchase_order_exceptions.dart';
import 'purchase_order_repository.dart';

class PurchaseOrderRepositoryImpl implements PurchaseOrderRepository {
  PurchaseOrderRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<PurchaseOrderBatch>> watchAll() {
    return (_db.select(_db.purchaseOrders)..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  @override
  Stream<PurchaseOrderBatch?> watchById(int id) {
    return (_db.select(
      _db.purchaseOrders,
    )..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  @override
  Future<PurchaseOrderBatch?> getById(int id) {
    return (_db.select(
      _db.purchaseOrders,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  @override
  Stream<List<PoQuotaStatus>> watchQuotaStatus(int purchaseOrderId) {
    final quotaQuery = _db.select(_db.poProductQuotas).join([
      innerJoin(
        _db.products,
        _db.products.id.equalsExp(_db.poProductQuotas.productId),
      ),
    ])..where(_db.poProductQuotas.purchaseOrderId.equals(purchaseOrderId));

    return quotaQuery.watch().asyncMap((quotaRows) async {
      final orders =
          await (_db.select(_db.orders)..where(
                (t) =>
                    t.purchaseOrderId.equals(purchaseOrderId) &
                    t.status.equalsValue(OrderStatus.cancelled).not(),
              ))
              .get();

      return quotaRows.map((row) {
        final quota = row.readTable(_db.poProductQuotas);
        final product = row.readTable(_db.products);
        final filled = orders
            .where((order) => order.productId == quota.productId)
            .fold<int>(0, (sum, order) => sum + order.quantity);
        return PoQuotaStatus(
          productId: quota.productId,
          productName: product.name,
          quotaQuantity: quota.quotaQuantity,
          filledQuantity: filled,
        );
      }).toList();
    });
  }

  @override
  Future<int> create({
    required String label,
    required List<PoQuotaInput> quotas,
  }) async {
    if (quotas.isEmpty) throw const EmptyQuotaException();
    await _assertTodayNotClosed();

    return _db.transaction(() async {
      final poId = await _db
          .into(_db.purchaseOrders)
          .insert(PurchaseOrdersCompanion.insert(label: label));

      for (final quota in quotas) {
        await _db
            .into(_db.poProductQuotas)
            .insert(
              PoProductQuotasCompanion.insert(
                purchaseOrderId: poId,
                productId: quota.productId,
                quotaQuantity: quota.quotaQuantity,
              ),
            );
      }
      return poId;
    });
  }

  @override
  Future<void> open(int purchaseOrderId) async {
    final po = await _requireStatus(purchaseOrderId, PoStatus.draft);
    await (_db.update(
      _db.purchaseOrders,
    )..where((t) => t.id.equals(po.id))).write(
      PurchaseOrdersCompanion(
        status: const Value(PoStatus.open),
        openedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> close(int purchaseOrderId) async {
    final po = await _requireStatus(purchaseOrderId, PoStatus.open);
    await (_db.update(
      _db.purchaseOrders,
    )..where((t) => t.id.equals(po.id))).write(
      PurchaseOrdersCompanion(
        status: const Value(PoStatus.closed),
        closedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<PurchaseOrderBatch> _requireStatus(int id, PoStatus expected) async {
    final po = await getById(id);
    if (po == null) throw PurchaseOrderNotFoundException(id);
    if (po.status != expected) {
      throw InvalidPoStatusTransitionException(po.status, expected);
    }
    return po;
  }

  Future<void> _assertTodayNotClosed() async {
    final closedToday =
        await (_db.select(_db.dailyClosings)
              ..where((t) => t.date.equals(dateOnly(DateTime.now()))))
            .getSingleOrNull();
    if (closedToday != null) {
      throw const TodayAlreadyClosedException();
    }
  }
}
