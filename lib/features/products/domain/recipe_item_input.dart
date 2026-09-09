import '../../../data/local/app_database.dart';

/// One BOM line being submitted from the recipe form — plain input, not a
/// persisted row (see [RecipeItem] for the stored shape).
class RecipeItemInput {
  const RecipeItemInput({
    required this.ingredientId,
    required this.quantityPerBatch,
    this.kind = RecipeItemKind.ingredient,
  });

  final int ingredientId;
  final double quantityPerBatch;

  /// Bahan baku yang termakan, atau kemasan (new_flow.md A.3). Default bahan
  /// baku supaya pemanggil lama tetap berperilaku sama.
  final RecipeItemKind kind;
}
