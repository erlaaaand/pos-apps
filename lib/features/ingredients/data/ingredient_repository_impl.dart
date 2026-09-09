import 'package:drift/drift.dart';

import '../../../data/local/app_database.dart';
import '../application/ingredient_providers.dart'
    show StockStatusFilter, IngredientSortOption;
import '../domain/batch_purchase_line_input.dart';
import '../domain/ingredient_exceptions.dart';
import '../domain/ingredient_import_row.dart';
import '../domain/ingredient_usage_models.dart';
import 'ingredient_repository.dart';

class IngredientRepositoryImpl implements IngredientRepository {
  IngredientRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Ingredient>> watchAll() {
    return (_db.select(
      _db.ingredients,
    )..orderBy([(t) => OrderingTerm(expression: t.name)])).watch();
  }

  @override
  Stream<List<Ingredient>> watchFiltered({
    int? categoryId,
    String? query,
    int? recipeProductId,
    StockStatusFilter stockStatus = StockStatusFilter.all,
    IngredientSortOption sortOption = IngredientSortOption.nameAsc,
  }) {
    final trimmed = query?.trim() ?? '';

    OrderingTerm ordering;
    switch (sortOption) {
      case IngredientSortOption.nameAsc:
        ordering = OrderingTerm(
          expression: _db.ingredients.name,
          mode: OrderingMode.asc,
        );
      case IngredientSortOption.nameDesc:
        ordering = OrderingTerm(
          expression: _db.ingredients.name,
          mode: OrderingMode.desc,
        );
      case IngredientSortOption.stockDesc:
        ordering = OrderingTerm(
          expression: _db.ingredients.currentStock,
          mode: OrderingMode.desc,
        );
      case IngredientSortOption.stockAsc:
        ordering = OrderingTerm(
          expression: _db.ingredients.currentStock,
          mode: OrderingMode.asc,
        );
      case IngredientSortOption.costDesc:
        ordering = OrderingTerm(
          expression: _db.ingredients.currentCostPerUnit,
          mode: OrderingMode.desc,
        );
      case IngredientSortOption.costAsc:
        ordering = OrderingTerm(
          expression: _db.ingredients.currentCostPerUnit,
          mode: OrderingMode.asc,
        );
    }

    final statement = _db.select(_db.ingredients)..orderBy([(t) => ordering]);

    if (categoryId != null) {
      statement.where((t) => t.categoryId.equals(categoryId));
    }
    if (trimmed.isNotEmpty) {
      final pattern = '%${trimmed.toLowerCase()}%';
      statement.where((t) => t.name.lower().like(pattern));
    }
    if (stockStatus == StockStatusFilter.available) {
      statement.where((t) => t.currentStock.isBiggerThan(const Constant(0.0)));
    } else if (stockStatus == StockStatusFilter.outOfStock) {
      statement.where(
        (t) => t.currentStock.isSmallerOrEqual(const Constant(0.0)),
      );
    }

    if (recipeProductId != null) {
      if (recipeProductId == -1) {
        // Bahan baku yang tidak digunakan di resep manapun
        final subQuery = _db.selectOnly(_db.recipeItems)
          ..addColumns([_db.recipeItems.ingredientId]);
        statement.where((t) => t.id.isNotInQuery(subQuery));
      } else {
        // Bahan baku yang digunakan pada resep produk tsb
        final subQuery =
            _db.selectOnly(_db.recipeItems).join([
                innerJoin(
                  _db.recipes,
                  _db.recipes.id.equalsExp(_db.recipeItems.recipeId),
                ),
              ])
              ..addColumns([_db.recipeItems.ingredientId])
              ..where(
                _db.recipes.productId.equals(recipeProductId) &
                    _db.recipes.isActive.equals(true),
              );
        statement.where((t) => t.id.isInQuery(subQuery));
      }
    }

    return statement.watch();
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
    int? categoryId,
  }) async {
    await _assertNameAvailable(name);
    return _db
        .into(_db.ingredients)
        .insert(
          IngredientsCompanion.insert(
            name: name,
            unit: unit,
            categoryId: Value(categoryId),
          ),
        );
  }

  @override
  Future<void> updateDetails({
    required int id,
    required String name,
    required IngredientUnit unit,
    int? categoryId,
  }) async {
    await _assertNameAvailable(name, excludingId: id);
    await (_db.update(_db.ingredients)..where((t) => t.id.equals(id))).write(
      IngredientsCompanion(
        name: Value(name),
        unit: Value(unit),
        categoryId: Value(categoryId),
      ),
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
  Stream<List<IngredientCategory>> watchCategories() {
    return (_db.select(
      _db.ingredientCategories,
    )..orderBy([(t) => OrderingTerm(expression: t.name)])).watch();
  }

  @override
  Future<int> createCategory(String name) async {
    final trimmed = name.trim();
    final existing =
        await (_db.select(_db.ingredientCategories)
              ..where((t) => t.name.lower().equals(trimmed.toLowerCase())))
            .getSingleOrNull();
    if (existing != null) {
      throw DuplicateIngredientCategoryException(trimmed);
    }
    return _db
        .into(_db.ingredientCategories)
        .insert(IngredientCategoriesCompanion.insert(name: trimmed));
  }

  @override
  Future<void> deleteCategory(int id) async {
    final inUse =
        await (_db.select(_db.ingredients)
              ..where((t) => t.categoryId.equals(id))
              ..limit(1))
            .get();
    if (inUse.isNotEmpty) {
      throw IngredientCategoryInUseException(id);
    }
    await (_db.delete(
      _db.ingredientCategories,
    )..where((t) => t.id.equals(id))).go();
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
  Stream<List<PurchaseBatch>> watchPurchaseBatches() {
    return (_db.select(_db.purchaseBatches)..orderBy([
          (t) =>
              OrderingTerm(expression: t.purchasedAt, mode: OrderingMode.desc),
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
    _assertPositiveLine(quantity: quantity, priceRupiah: totalPriceRupiah);

    await _db.transaction(() async {
      await _applyPurchase(
        ingredientId: ingredientId,
        quantity: quantity,
        totalPriceRupiah: totalPriceRupiah,
        storeName: storeName,
        purchasedAt: purchasedAt,
      );
    });
  }

  @override
  Future<int> recordBatchPurchase({
    required DateTime purchasedAt,
    String? storeName,
    String? note,
    required int totalPriceRupiah,
    required List<BatchPurchaseLineInput> lines,
  }) async {
    if (lines.isEmpty) {
      throw const EmptyPurchaseBatchException();
    }
    if (totalPriceRupiah <= 0) {
      throw ArgumentError.value(
        totalPriceRupiah,
        'totalPriceRupiah',
        'Total belanja harus lebih dari 0',
      );
    }
    for (final line in lines) {
      _assertPositiveLine(
        quantity: line.quantity,
        priceRupiah: line.allocatedPriceRupiah,
      );
    }

    final allocated = lines.fold<int>(
      0,
      (sum, line) => sum + line.allocatedPriceRupiah,
    );
    if (allocated != totalPriceRupiah) {
      throw BatchAllocationMismatchException(
        expectedRupiah: totalPriceRupiah,
        actualRupiah: allocated,
      );
    }

    return _db.transaction(() async {
      final batchId = await _db
          .into(_db.purchaseBatches)
          .insert(
            PurchaseBatchesCompanion.insert(
              purchasedAt: purchasedAt,
              totalPriceRupiah: totalPriceRupiah,
              storeName: Value(storeName),
              note: Value(note),
            ),
          );

      for (final line in lines) {
        await _applyPurchase(
          ingredientId: line.ingredientId,
          quantity: line.quantity,
          totalPriceRupiah: line.allocatedPriceRupiah,
          storeName: storeName,
          purchasedAt: purchasedAt,
          batchId: batchId,
        );
      }

      return batchId;
    });
  }

  @override
  Future<int> importIngredients(List<IngredientImportRow> rows) async {
    if (rows.isEmpty) return 0;

    return _db.transaction(() async {
      final categoryIdByName = <String, int>{};
      for (final category in await _db.select(_db.ingredientCategories).get()) {
        categoryIdByName[category.name.toLowerCase()] = category.id;
      }

      var inserted = 0;
      for (final row in rows) {
        int? categoryId;
        final categoryName = row.categoryName?.trim();
        if (categoryName != null && categoryName.isNotEmpty) {
          final key = categoryName.toLowerCase();
          categoryId =
              categoryIdByName[key] ??
              await _db
                  .into(_db.ingredientCategories)
                  .insert(
                    IngredientCategoriesCompanion.insert(name: categoryName),
                  );
          categoryIdByName[key] = categoryId;
        }

        await _db
            .into(_db.ingredients)
            .insert(
              IngredientsCompanion.insert(
                name: row.name,
                unit: row.unit,
                categoryId: Value(categoryId),
              ),
            );
        inserted++;
      }
      return inserted;
    });
  }

  /// Weighted-average recalculation (erp.md A.2), shared by single and batch
  /// purchases so the rule has exactly one implementation. Callers are
  /// responsible for opening the transaction.
  Future<void> _applyPurchase({
    required int ingredientId,
    required double quantity,
    required int totalPriceRupiah,
    required DateTime purchasedAt,
    String? storeName,
    int? batchId,
  }) async {
    final ingredient = await (_db.select(
      _db.ingredients,
    )..where((t) => t.id.equals(ingredientId))).getSingleOrNull();
    if (ingredient == null) {
      throw IngredientNotFoundException(ingredientId);
    }

    final newStock = ingredient.currentStock + quantity;
    // We use the recorded purchase total directly rather than re-deriving
    // qty × unit price — the total is the real amount the owner paid, so this
    // is both simpler and marginally more accurate than round-tripping
    // through a per-unit price.
    final previousValue =
        ingredient.currentStock * ingredient.currentCostPerUnit;
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
            batchId: Value(batchId),
          ),
        );
  }

  void _assertPositiveLine({
    required double quantity,
    required int priceRupiah,
  }) {
    if (quantity <= 0) {
      throw ArgumentError.value(quantity, 'quantity', 'Qty harus lebih dari 0');
    }
    if (priceRupiah <= 0) {
      throw ArgumentError.value(
        priceRupiah,
        'totalPriceRupiah',
        'Harga harus lebih dari 0',
      );
    }
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

  @override
  Stream<List<IngredientRecipeUsage>> watchRecipesUsingIngredient(
    int ingredientId,
  ) {
    final query =
        _db.select(_db.recipeItems).join([
            innerJoin(
              _db.recipes,
              _db.recipes.id.equalsExp(_db.recipeItems.recipeId),
            ),
            innerJoin(
              _db.products,
              _db.products.id.equalsExp(_db.recipes.productId),
            ),
          ])
          ..where(_db.recipeItems.ingredientId.equals(ingredientId))
          ..where(_db.recipes.isActive.equals(true))
          ..orderBy([OrderingTerm.asc(_db.products.name)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final item = row.readTable(_db.recipeItems);
        final product = row.readTable(_db.products);
        return IngredientRecipeUsage(
          productId: product.id,
          productName: product.name,
          quantity: item.quantityPerBatch,
          kind: item.kind,
        );
      }).toList();
    });
  }

  @override
  Stream<List<IngredientProductionUsage>> watchProductionUsages(
    int ingredientId,
  ) {
    final query =
        _db.select(_db.ingredientUsages).join([
            innerJoin(
              _db.productionSessions,
              _db.productionSessions.id.equalsExp(
                _db.ingredientUsages.sessionId,
              ),
            ),
            innerJoin(
              _db.purchaseOrders,
              _db.purchaseOrders.id.equalsExp(
                _db.productionSessions.purchaseOrderId,
              ),
            ),
          ])
          ..where(_db.ingredientUsages.ingredientId.equals(ingredientId))
          ..orderBy([OrderingTerm.desc(_db.productionSessions.confirmedAt)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final usage = row.readTable(_db.ingredientUsages);
        final session = row.readTable(_db.productionSessions);
        final po = row.readTable(_db.purchaseOrders);
        return IngredientProductionUsage(
          sessionId: session.id,
          sessionDate: session.confirmedAt,
          poLabel: po.label,
          quantityUsed: usage.quantityUsed,
        );
      }).toList();
    });
  }

  @override
  Future<PurchaseBatch?> getPurchaseBatch(int batchId) {
    return (_db.select(
      _db.purchaseBatches,
    )..where((t) => t.id.equals(batchId))).getSingleOrNull();
  }
}
