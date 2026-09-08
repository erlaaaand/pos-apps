/// One product's quota being submitted when creating a PO.
class PoQuotaInput {
  const PoQuotaInput({required this.productId, required this.quotaQuantity});

  final int productId;
  final int quotaQuantity;
}
