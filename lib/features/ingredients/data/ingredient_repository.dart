import '../../../data/local/app_database.dart';
import '../application/ingredient_providers.dart'
    show StockStatusFilter, IngredientSortOption;
import '../domain/batch_purchase_line_input.dart';
import '../domain/ingredient_import_row.dart';
import '../domain/ingredient_usage_models.dart';

/// Abstraction over ingredient (A.1), ingredient-purchase (A.2) and
/// ingredient-category storage. Presentation code depends on this interface,
/// never on [AppDatabase] directly.
abstract interface class IngredientRepository {
  Stream<List<Ingredient>> watchAll();

  /// Daftar bahan yang sudah disaring kategori, resep, status stok, kata kunci, serta diurutkan
  /// (update.md: filtering & sorting di Master Bahan Baku).
  Stream<List<Ingredient>> watchFiltered({
    int? categoryId,
    String? query,
    int? recipeProductId,
    StockStatusFilter stockStatus = StockStatusFilter.all,
    IngredientSortOption sortOption = IngredientSortOption.nameAsc,
  });

  Stream<Ingredient?> watchById(int id);

  Future<Ingredient?> getById(int id);

  /// Creates a new ingredient with zero stock/cost — cost is only ever set
  /// by [recordPurchase], per erp.md A.1 ("harga modal tidak diinput manual
  /// saat setup").
  Future<int> create({
    required String name,
    required IngredientUnit unit,
    int? categoryId,
  });

  Future<void> updateDetails({
    required int id,
    required String name,
    required IngredientUnit unit,
    int? categoryId,
  });

  /// Throws [IngredientInUseException] if [id] has purchase history or is
  /// referenced by any recipe.
  Future<void> delete(int id);

  // --- Kategori (update.md) ---

  Stream<List<IngredientCategory>> watchCategories();

  /// Throws [DuplicateIngredientCategoryException] if the name is taken.
  Future<int> createCategory(String name);

  /// Throws [IngredientCategoryInUseException] if ingredients still use it.
  Future<void> deleteCategory(int id);

  // --- Pembelian (A.2) ---

  Stream<List<IngredientPurchase>> watchPurchases(int ingredientId);

  /// Riwayat belanja terbaru, batch beserta jumlah barisnya.
  Stream<List<PurchaseBatch>> watchPurchaseBatches();

  /// Records a single-ingredient purchase and atomically recalculates that
  /// ingredient's stock and weighted-average cost per erp.md A.2.
  Future<void> recordPurchase({
    required int ingredientId,
    required double quantity,
    required int totalPriceRupiah,
    String? storeName,
    required DateTime purchasedAt,
  });

  /// Records one shopping trip covering several ingredients under a single
  /// total price (new_flow.md A.2 "pembelian borongan"), splitting the cost
  /// across [lines] and then applying the ordinary weighted-average update to
  /// each ingredient.
  ///
  /// Throws [EmptyPurchaseBatchException] when [lines] is empty and
  /// [BatchAllocationMismatchException] when the allocations do not add up to
  /// [totalPriceRupiah].
  Future<int> recordBatchPurchase({
    required DateTime purchasedAt,
    String? storeName,
    String? note,
    required int totalPriceRupiah,
    required List<BatchPurchaseLineInput> lines,
  });

  // --- Impor massal (update.md) ---

  /// Inserts already-validated import rows in one transaction, creating any
  /// referenced category that does not exist yet. Returns the number of
  /// ingredients inserted.
  Future<int> importIngredients(List<IngredientImportRow> rows);

  // --- Rincian Bahan Tambahan ---

  /// Rincian resep aktif yang menggunakan bahan baku ini.
  Stream<List<IngredientRecipeUsage>> watchRecipesUsingIngredient(
    int ingredientId,
  );

  /// Riwayat pemakaian bahan baku dalam sesi produksi.
  Stream<List<IngredientProductionUsage>> watchProductionUsages(
    int ingredientId,
  );

  /// Mengambil data batch belanja jika pembelian berasal dari belanja borongan.
  Future<PurchaseBatch?> getPurchaseBatch(int batchId);
}
