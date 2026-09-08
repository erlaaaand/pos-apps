/// Weekly sold quantity/revenue for one product (Bagian C: "tren penjualan
/// per produk"). [weekStart] is the Monday of the aggregated week.
class WeeklyProductSales {
  const WeeklyProductSales({
    required this.productName,
    required this.weekStart,
    required this.quantitySold,
    required this.revenueRupiah,
  });

  final String productName;
  final DateTime weekStart;
  final int quantitySold;
  final int revenueRupiah;
}
