import '../../../data/local/app_database.dart';

/// Abstraction over ingredient (A.1) and ingredient-purchase (A.2) storage.
/// Presentation code depends on this interface, never on [AppDatabase]
/// directly.
abstract interface class IngredientRepository {
  Stream<List<Ingredient>> watchAll();

  Stream<Ingredient?> watchById(int id);

  Future<Ingredient?> getById(int id);

  /// Creates a new ingredient with zero stock/cost — cost is only ever set
  /// by [recordPurchase], per erp.md A.1 ("harga modal tidak diinput manual
  /// saat setup").
  Future<int> create({required String name, required IngredientUnit unit});

  Future<void> updateNameAndUnit({
    required int id,
    required String name,
    required IngredientUnit unit,
  });

  /// Throws [IngredientInUseException] if [id] has purchase history or is
  /// referenced by any recipe.
  Future<void> delete(int id);

  Stream<List<IngredientPurchase>> watchPurchases(int ingredientId);

  /// Records a purchase and atomically recalculates the ingredient's stock
  /// and weighted-average cost per erp.md A.2.
  Future<void> recordPurchase({
    required int ingredientId,
    required double quantity,
    required int totalPriceRupiah,
    String? storeName,
    required DateTime purchasedAt,
  });
}
