import 'package:drift/drift.dart';

import '../../../data/local/app_database.dart';
import '../domain/ingredient_exceptions.dart';
import 'ingredient_repository.dart';

class IngredientRepositoryImpl implements IngredientRepository {
  IngredientRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Ingredient>> watchAll() {
    return (_db.select(_db.ingredients)
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .watch();
  }

  @override
  Stream<Ingredient?> watchById(int id) {
    return (_db.select(
      _db.ingredients,
    )..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  @override
  Future<Ingredient?> getById(int id) {
    return (_db.select(
      _db.ingredients,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  @override
  Future<int> create({
    required String name,
    required IngredientUnit unit,
  }) async {
    await _assertNameAvailable(name);
    return _db
        .into(_db.ingredients)
        .insert(IngredientsCompanion.insert(name: name, unit: unit));
  }

  @override
  Future<void> updateNameAndUnit({
    required int id,
    required String name,
    required IngredientUnit unit,
  }) async {
    await _assertNameAvailable(name, excludingId: id);
    await (_db.update(_db.ingredients)..where((t) => t.id.equals(id))).write(
      IngredientsCompanion(name: Value(name), unit: Value(unit)),
    );
  }

  @override
  Future<void> delete(int id) async {
    final hasPurchases =
        await (_db.select(_db.ingredientPurchases)
              ..where((t) => t.ingredientId.equals(id))
              ..limit(1))
            .get();
    if (hasPurchases.isNotEmpty) {
      throw IngredientInUseException(id);
    }

    final usedInRecipes =
        await (_db.select(_db.recipeItems)
              ..where((t) => t.ingredientId.equals(id))
              ..limit(1))
            .get();
    if (usedInRecipes.isNotEmpty) {
      throw IngredientInUseException(id);
    }

    await (_db.delete(_db.ingredients)..where((t) => t.id.equals(id))).go();
  }

  @override
  Stream<List<IngredientPurchase>> watchPurchases(int ingredientId) {
    return (_db.select(_db.ingredientPurchases)
          ..where((t) => t.ingredientId.equals(ingredientId))
          ..orderBy([
            (t) => OrderingTerm(
              expression: t.purchasedAt,
              mode: OrderingMode.desc,
            ),
          ]))
        .watch();
  }

  @override
  Future<void> recordPurchase({
    required int ingredientId,
    required double quantity,
    required int totalPriceRupiah,
    String? storeName,
    required DateTime purchasedAt,
  }) async {
    if (quantity <= 0) {
      throw ArgumentError.value(quantity, 'quantity', 'Qty harus lebih dari 0');
    }
    if (totalPriceRupiah <= 0) {
      throw ArgumentError.value(
        totalPriceRupiah,
        'totalPriceRupiah',
        'Harga harus lebih dari 0',
      );
    }

    await _db.transaction(() async {
      final ingredient = await (_db.select(
        _db.ingredients,
      )..where((t) => t.id.equals(ingredientId))).getSingleOrNull();
      if (ingredient == null) {
        throw IngredientNotFoundException(ingredientId);
      }

      final newStock = ingredient.currentStock + quantity;
      // Weighted-average recalculation (erp.md A.2). We use the recorded
      // purchase total directly rather than re-deriving qty × unit price —
      // the total is the real amount the owner paid, so this is both
      // simpler and marginally more accurate than round-tripping through a
      // per-unit price.
      final previousValue = ingredient.currentStock * ingredient.currentCostPerUnit;
      final newCostPerUnit = (previousValue + totalPriceRupiah) / newStock;

      await (_db.update(
        _db.ingredients,
      )..where((t) => t.id.equals(ingredientId))).write(
        IngredientsCompanion(
          currentStock: Value(newStock),
          currentCostPerUnit: Value(newCostPerUnit),
        ),
      );

      await _db
          .into(_db.ingredientPurchases)
          .insert(
            IngredientPurchasesCompanion.insert(
              ingredientId: ingredientId,
              quantity: quantity,
              totalPriceRupiah: totalPriceRupiah,
              purchasedAt: purchasedAt,
              storeName: Value(storeName),
            ),
          );
    });
  }

  Future<void> _assertNameAvailable(String name, {int? excludingId}) async {
    final query = _db.select(_db.ingredients)
      ..where((t) => t.name.lower().equals(name.toLowerCase()));
    if (excludingId != null) {
      query.where((t) => t.id.equals(excludingId).not());
    }
    final existing = await query.getSingleOrNull();
    if (existing != null) {
      throw DuplicateIngredientNameException(name);
    }
  }
}
