import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/app_database.dart';
import '../../../data/local/database_provider.dart';
import '../data/recipe_repository.dart';
import '../data/recipe_repository_impl.dart';
import '../domain/product_with_active_recipe.dart';
import '../domain/recipe_item_detail.dart';

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  return RecipeRepositoryImpl(ref.watch(appDatabaseProvider));
});

final productsWithActiveRecipeProvider =
    StreamProvider<List<ProductWithActiveRecipe>>((ref) {
      return ref
          .watch(recipeRepositoryProvider)
          .watchProductsWithActiveRecipe();
    });

final productByIdProvider = StreamProvider.family<Product?, int>((ref, id) {
  return ref.watch(recipeRepositoryProvider).watchProductById(id);
});

final activeRecipeForProductProvider = StreamProvider.family<Recipe?, int>((
  ref,
  productId,
) {
  return ref.watch(recipeRepositoryProvider).watchActiveRecipe(productId);
});

final recipeHistoryProvider = StreamProvider.family<List<Recipe>, int>((
  ref,
  productId,
) {
  return ref.watch(recipeRepositoryProvider).watchRecipeHistory(productId);
});

final recipeItemsProvider = StreamProvider.family<List<RecipeItemDetail>, int>((
  ref,
  recipeId,
) {
  return ref.watch(recipeRepositoryProvider).watchRecipeItems(recipeId);
});

final recipeHppProvider = FutureProvider.family<double, int>((ref, recipeId) {
  return ref.watch(recipeRepositoryProvider).computeHpp(recipeId);
});
