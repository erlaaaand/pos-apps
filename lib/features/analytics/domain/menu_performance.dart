/// Per-product performance summary (Bagian C: "laporan performa menu") —
/// helps decide rotation candidates: low `completedCount`/margin or high
/// `cancelledCount` relative to sales suggests a product worth reviewing.
class MenuPerformance {
  const MenuPerformance({
    required this.productName,
    required this.isActive,
    required this.completedCount,
    required this.cancelledCount,
    required this.totalQuantitySold,
    required this.totalRevenueRupiah,
    required this.totalHppRupiah,
  });

  final String productName;
  final bool isActive;
  final int completedCount;
  final int cancelledCount;
  final int totalQuantitySold;
  final int totalRevenueRupiah;
  final int totalHppRupiah;

  int get marginRupiah => totalRevenueRupiah - totalHppRupiah;
}
