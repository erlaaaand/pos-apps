/// Sold quantity/revenue for one product within one PO label/"slot" (Bagian
/// C: "performa per slot PO — Pagi vs Siang vs Sore vs Malam").
class PoSlotPerformance {
  const PoSlotPerformance({
    required this.slotLabel,
    required this.productName,
    required this.quantitySold,
    required this.revenueRupiah,
  });

  final String slotLabel;
  final String productName;
  final int quantitySold;
  final int revenueRupiah;
}
