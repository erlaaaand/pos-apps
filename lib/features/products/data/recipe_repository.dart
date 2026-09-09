import '../../../data/local/app_database.dart';
import '../domain/product_with_active_recipe.dart';
import '../domain/recipe_item_detail.dart';
import '../domain/recipe_item_input.dart';

/// Abstraction over Products + Recipes + RecipeItems (A.3). The two tables
/// are exposed through one repository because erp.md treats "produk" and
/// "resep" as one bounded concern — creating a product always creates its
/// first costed recipe in the same atomic step.
abstract interface class RecipeRepository {
  Stream<List<Product>> watchAllProducts();

  Stream<List<ProductWithActiveRecipe>> watchProductsWithActiveRecipe();

  Stream<Product?> watchProductById(int id);

  Future<Product?> getProductById(int id);

  Future<void> setProductActive(int productId, {required bool isActive});

  Stream<Recipe?> watchActiveRecipe(int productId);

  Stream<List<Recipe>> watchRecipeHistory(int productId);

  Stream<List<RecipeItemDetail>> watchRecipeItems(int recipeId);

  /// Σ(quantityPerBatch × current ingredient cost) — a live estimate, not a
  /// stored fact. The number that actually matters for P&L is the snapshot
  /// captured onto each [Orders] row at production time (Bagian B).
  Future<double> computeHpp(int recipeId);

  /// Creates a product and its first recipe version atomically.
  Future<int> createProduct({
    required String name,
    int sellingPriceRupiah = 0,
    required List<RecipeItemInput> items,
  });

  /// Deactivates the product's current recipe and inserts a new one,
  /// atomically ("Nonaktifkan Resep Lama" + "Tambah Resep Baru" as one step
  /// per erp.md A.3).
  Future<int> addRecipeVersion({
    required int productId,
    int sellingPriceRupiah = 0,
    required List<RecipeItemInput> items,
  });
}
