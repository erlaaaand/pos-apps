/// Satu bahan di dalam satu transaksi belanja (new_flow.md A.2).
///
/// [allocatedPriceRupiah] adalah porsi biaya batch yang dibebankan ke bahan
/// ini. Defaultnya hasil [allocateEvenly], tapi pemilik boleh mengubahnya per
/// bahan selama totalnya tetap sama dengan yang dibayar.
class BatchPurchaseLineInput {
  const BatchPurchaseLineInput({
    required this.ingredientId,
    required this.quantity,
    required this.allocatedPriceRupiah,
  });

  final int ingredientId;
  final double quantity;
  final int allocatedPriceRupiah;
}
