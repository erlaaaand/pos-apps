/// A product's quota in a PO joined with how much of it is filled by
/// non-cancelled orders — the "Es Teler: 8/15 terisi" display from erp.md
/// B.2. Informational only: reaching the quota does not itself block new
/// orders or close the PO in the MVP (auto-close on full quota is an
/// explicitly deferred roadmap item), the owner decides when to close.
class PoQuotaStatus {
  const PoQuotaStatus({
    required this.productId,
    required this.productName,
    required this.quotaQuantity,
    required this.filledQuantity,
  });

  final int productId;
  final String productName;
  final int quotaQuantity;
  final int filledQuantity;

  int get remaining => quotaQuantity - filledQuantity;

  bool get isFull => filledQuantity >= quotaQuantity;
}
