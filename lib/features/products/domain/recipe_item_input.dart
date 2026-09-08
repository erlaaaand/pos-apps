/// One BOM line being submitted from the recipe form — plain input, not a
/// persisted row (see [RecipeItem] for the stored shape).
class RecipeItemInput {
  const RecipeItemInput({
    required this.ingredientId,
    required this.quantityPerBatch,
  });

  final int ingredientId;
  final double quantityPerBatch;
}
