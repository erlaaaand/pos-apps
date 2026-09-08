/// One purchase's effective unit price, for the ingredient price-trend
/// report (Bagian C: "tren harga beli bahan baku").
class IngredientPricePoint {
  const IngredientPricePoint({
    required this.ingredientName,
    required this.purchasedAt,
    required this.pricePerUnit,
    this.storeName,
  });

  final String ingredientName;
  final DateTime purchasedAt;
  final double pricePerUnit;
  final String? storeName;
}
