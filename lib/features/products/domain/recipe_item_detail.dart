import '../../../data/local/app_database.dart';

/// A recipe's BOM line joined with its ingredient's current name/unit/cost,
/// for display — avoids the UI having to join tables itself.
class RecipeItemDetail {
  const RecipeItemDetail({
    required this.recipeItemId,
    required this.ingredientId,
    required this.ingredientName,
    required this.unit,
    required this.quantityPerBatch,
    required this.currentCostPerUnit,
    required this.kind,
  });

  final int recipeItemId;
  final int ingredientId;
  final String ingredientName;
  final IngredientUnit unit;
  final double quantityPerBatch;
  final double currentCostPerUnit;

  /// Bahan baku atau kemasan (new_flow.md A.3) — dipakai untuk memisahkan
  /// breakdown biaya di layar detail produk.
  final RecipeItemKind kind;

  double get lineCost => quantityPerBatch * currentCostPerUnit;
}
