import 'package:drift/drift.dart';

import '../../../data/local/app_database.dart';
import '../domain/product_exceptions.dart';
import '../domain/product_with_active_recipe.dart';
import '../domain/recipe_item_detail.dart';
import '../domain/recipe_item_input.dart';
import 'recipe_repository.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  RecipeRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Product>> watchAllProducts() {
    return (_db.select(
      _db.products,
    )..orderBy([(t) => OrderingTerm(expression: t.name)])).watch();
  }

  @override
  Stream<List<ProductWithActiveRecipe>> watchProductsWithActiveRecipe() {
    final query = _db.select(_db.products).join([
      innerJoin(
        _db.recipes,
        _db.recipes.productId.equalsExp(_db.products.id) &
            _db.recipes.isActive.equals(true),
      ),
    ])..orderBy([OrderingTerm(expression: _db.products.name)]);

    return query.watch().map(
      (rows) => rows
          .map(
            (row) => ProductWithActiveRecipe(
              product: row.readTable(_db.products),
              recipe: row.readTable(_db.recipes),
            ),
          )
          .toList(),
    );
  }

  @override
  Stream<Product?> watchProductById(int id) {
    return (_db.select(
      _db.products,
    )..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  @override
  Future<Product?> getProductById(int id) {
    return (_db.select(
      _db.products,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  @override
  Future<void> setProductActive(int productId, {required bool isActive}) {
    return (_db.update(_db.products)..where((t) => t.id.equals(productId)))
        .write(ProductsCompanion(isActive: Value(isActive)));
  }

  @override
  Stream<Recipe?> watchActiveRecipe(int productId) {
    return (_db.select(_db.recipes)
          ..where(
            (t) => t.productId.equals(productId) & t.isActive.equals(true),
          )
          ..limit(1))
        .watchSingleOrNull();
  }

  @override
  Stream<List<Recipe>> watchRecipeHistory(int productId) {
    return (_db.select(_db.recipes)
          ..where((t) => t.productId.equals(productId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  @override
  Stream<List<RecipeItemDetail>> watchRecipeItems(int recipeId) {
    final query = _db.select(_db.recipeItems).join([
      innerJoin(
        _db.ingredients,
        _db.ingredients.id.equalsExp(_db.recipeItems.ingredientId),
      ),
    ])..where(_db.recipeItems.recipeId.equals(recipeId));

    return query.watch().map(
      (rows) => rows.map((row) {
        final item = row.readTable(_db.recipeItems);
        final ingredient = row.readTable(_db.ingredients);
        return RecipeItemDetail(
          recipeItemId: item.id,
          ingredientId: ingredient.id,
          ingredientName: ingredient.name,
          unit: ingredient.unit,
          quantityPerBatch: item.quantityPerBatch,
          currentCostPerUnit: ingredient.currentCostPerUnit,
          kind: item.kind,
        );
      }).toList(),
    );
  }

  @override
  Future<double> computeHpp(int recipeId) async {
    final query = _db.select(_db.recipeItems).join([
      innerJoin(
        _db.ingredients,
        _db.ingredients.id.equalsExp(_db.recipeItems.ingredientId),
      ),
    ])..where(_db.recipeItems.recipeId.equals(recipeId));

    final rows = await query.get();
    var total = 0.0;
    for (final row in rows) {
      final item = row.readTable(_db.recipeItems);
      final ingredient = row.readTable(_db.ingredients);
      total += item.quantityPerBatch * ingredient.currentCostPerUnit;
    }
    return total;
  }

  @override
  Future<int> createProduct({
    required String name,
    int sellingPriceRupiah = 0,
    required List<RecipeItemInput> items,
  }) async {
    _assertValidRecipeInput(sellingPriceRupiah, items);
    await _assertProductNameAvailable(name);

    return _db.transaction(() async {
      final productId = await _db
          .into(_db.products)
          .insert(ProductsCompanion.insert(name: name));

      final recipeId = await _db
          .into(_db.recipes)
          .insert(
            RecipesCompanion.insert(
              productId: productId,
              sellingPriceRupiah: sellingPriceRupiah,
            ),
          );

      await _insertRecipeItems(recipeId, items);
      return productId;
    });
  }

  @override
  Future<int> addRecipeVersion({
    required int productId,
    int sellingPriceRupiah = 0,
    required List<RecipeItemInput> items,
  }) async {
    _assertValidRecipeInput(sellingPriceRupiah, items);

    final product = await getProductById(productId);
    if (product == null) throw ProductNotFoundException(productId);

    return _db.transaction(() async {
      await (_db.update(_db.recipes)..where(
            (t) => t.productId.equals(productId) & t.isActive.equals(true),
          ))
          .write(const RecipesCompanion(isActive: Value(false)));

      final recipeId = await _db
          .into(_db.recipes)
          .insert(
            RecipesCompanion.insert(
              productId: productId,
              sellingPriceRupiah: sellingPriceRupiah,
            ),
          );

      await _insertRecipeItems(recipeId, items);
      return recipeId;
    });
  }

  Future<void> _insertRecipeItems(
    int recipeId,
    List<RecipeItemInput> items,
  ) async {
    for (final item in items) {
      await _db
          .into(_db.recipeItems)
          .insert(
            RecipeItemsCompanion.insert(
              recipeId: recipeId,
              ingredientId: item.ingredientId,
              quantityPerBatch: item.quantityPerBatch,
              kind: Value(item.kind),
            ),
          );
    }
  }

  void _assertValidRecipeInput(
    int sellingPriceRupiah,
    List<RecipeItemInput> items,
  ) {
    if (sellingPriceRupiah < 0) {
      throw ArgumentError.value(
        sellingPriceRupiah,
        'sellingPriceRupiah',
        'Harga jual tidak boleh negatif',
      );
    }
    if (items.isEmpty) {
      throw const EmptyRecipeException();
    }
  }

  Future<void> _assertProductNameAvailable(String name) async {
    final existing =
        await (_db.select(_db.products)
              ..where((t) => t.name.lower().equals(name.toLowerCase())))
            .getSingleOrNull();
    if (existing != null) {
      throw DuplicateProductNameException(name);
    }
  }
}
