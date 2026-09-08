import '../../../data/local/app_database.dart';
import '../domain/daily_summary.dart';

/// Abstraction over end-of-day operational cost entry and closing (B.5).
abstract interface class DailyClosingRepository {
  Stream<List<DailyClosing>> watchHistory();

  Stream<List<DailyOperationalCost>> watchTodayOperationalCosts();

  Future<void> addOperationalCost({
    required String name,
    required int amountRupiah,
  });

  /// Live figures for today, recomputed on demand — not yet snapshotted.
  Future<DailySummary> previewToday();

  /// "Tutup Pesanan Hari Ini": marks any still-`readyForPickup` order from
  /// today as `wasted`, snapshots today's P&L into a [DailyClosing] row, and
  /// blocks further PO/order creation until tomorrow. Throws
  /// [DayAlreadyClosedException] if already closed today.
  Future<DailyClosing> closeToday();
}
