import '../../../data/local/app_database.dart';

/// A product joined with its current active recipe — every product created
/// through [RecipeRepository] always has exactly one, so this is an inner
/// join, not a nullable relation.
class ProductWithActiveRecipe {
  const ProductWithActiveRecipe({required this.product, required this.recipe});

  final Product product;
  final Recipe recipe;
}
