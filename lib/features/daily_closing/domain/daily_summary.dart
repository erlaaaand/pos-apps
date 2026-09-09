/// Live preview of today's P&L before "Tutup Pesanan Hari Ini" is pressed
/// (B.5) — the same figures [DailyClosingRepository.closeToday] will
/// snapshot into a [DailyClosing] row.
class DailySummary {
  const DailySummary({
    required this.revenueRupiah,
    required this.hppRupiah,
    required this.operationalCostRupiah,
    required this.projectedWasteCostRupiah,
    required this.ordersPendingPickupCount,
  });

  final int revenueRupiah;
  final int hppRupiah;
  final int operationalCostRupiah;

  /// HPP of orders still `readyForPickup` — what closing today would write
  /// off as waste if they're not picked up before then.
  final int projectedWasteCostRupiah;

  final int ordersPendingPickupCount;

  int get netProfitRupiah =>
      revenueRupiah -
      hppRupiah -
      operationalCostRupiah -
      projectedWasteCostRupiah;
}
