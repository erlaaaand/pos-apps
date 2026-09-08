import 'package:business_management/data/local/app_database.dart';
import 'package:business_management/features/ingredients/data/ingredient_repository_impl.dart';
import 'package:business_management/features/products/data/recipe_repository_impl.dart';
import 'package:business_management/features/products/domain/product_exceptions.dart';
import 'package:business_management/features/products/domain/recipe_item_input.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late RecipeRepositoryImpl repository;
  late IngredientRepositoryImpl ingredients;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = RecipeRepositoryImpl(db);
    ingredients = IngredientRepositoryImpl(db);
  });

  tearDown(() => db.close());

  Future<int> seedIngredientWithCost({
    required String name,
    required double costPerUnit,
  }) async {
    final id = await ingredients.create(
      name: name,
      unit: IngredientUnit.gram,
    );
    // A single purchase of 1 unit at costPerUnit sets currentCostPerUnit
    // exactly, per the weighted-average formula on a zero starting stock.
    await ingredients.recordPurchase(
      ingredientId: id,
      quantity: 1,
      totalPriceRupiah: costPerUnit.round(),
      purchasedAt: DateTime(2026, 1, 1),
    );
    return id;
  }

  group('createProduct', () {
    test('creates a product with its first active recipe', () async {
      final durianId = await seedIngredientWithCost(
        name: 'Durian',
        costPerUnit: 500,
      );

      final productId = await repository.createProduct(
        name: 'Es Teler Durian',
        sellingPriceRupiah: 15000,
        items: [RecipeItemInput(ingredientId: durianId, quantityPerBatch: 10)],
      );

      final recipe = await repository.watchActiveRecipe(productId).first;
      expect(recipe, isNotNull);
      expect(recipe!.sellingPriceRupiah, 15000);
      expect(recipe.isActive, isTrue);
    });

    test('rejects an empty BOM', () async {
      expect(
        () => repository.createProduct(
          name: 'Es Teler Durian',
          sellingPriceRupiah: 15000,
          items: const [],
        ),
        throwsA(isA<EmptyRecipeException>()),
      );
    });

    test('rejects a duplicate product name', () async {
      final durianId = await seedIngredientWithCost(
        name: 'Durian',
        costPerUnit: 500,
      );
      final items = [
        RecipeItemInput(ingredientId: durianId, quantityPerBatch: 10),
      ];

      await repository.createProduct(
        name: 'Es Teler Durian',
        sellingPriceRupiah: 15000,
        items: items,
      );

      expect(
        () => repository.createProduct(
          name: 'Es Teler Durian',
          sellingPriceRupiah: 16000,
          items: items,
        ),
        throwsA(isA<DuplicateProductNameException>()),
      );
    });
  });

  group('computeHpp', () {
    test('sums quantity × current ingredient cost across the BOM', () async {
      final durianId = await seedIngredientWithCost(
        name: 'Durian',
        costPerUnit: 500,
      );
      final ketanId = await seedIngredientWithCost(
        name: 'Ketan',
        costPerUnit: 20,
      );

      final productId = await repository.createProduct(
        name: 'Es Teler Durian',
        sellingPriceRupiah: 15000,
        items: [
          RecipeItemInput(ingredientId: durianId, quantityPerBatch: 10),
          RecipeItemInput(ingredientId: ketanId, quantityPerBatch: 50),
        ],
      );
      final recipe = await repository.watchActiveRecipe(productId).first;

      final hpp = await repository.computeHpp(recipe!.id);

      // 10*500 + 50*20 = 6000
      expect(hpp, 6000);
    });
  });

  group('addRecipeVersion', () {
    test(
      'deactivates the old recipe and activates the new one atomically',
      () async {
        final durianId = await seedIngredientWithCost(
          name: 'Durian',
          costPerUnit: 500,
        );
        final productId = await repository.createProduct(
          name: 'Es Teler Durian',
          sellingPriceRupiah: 15000,
          items: [
            RecipeItemInput(ingredientId: durianId, quantityPerBatch: 10),
          ],
        );
        final oldRecipe = await repository.watchActiveRecipe(productId).first;

        await repository.addRecipeVersion(
          productId: productId,
          sellingPriceRupiah: 18000,
          items: [
            RecipeItemInput(ingredientId: durianId, quantityPerBatch: 12),
          ],
        );

        final history = await repository.watchRecipeHistory(productId).first;
        expect(history, hasLength(2));

        final oldAfterUpdate = history.firstWhere((r) => r.id == oldRecipe!.id);
        expect(oldAfterUpdate.isActive, isFalse);

        final newActive = await repository.watchActiveRecipe(productId).first;
        expect(newActive!.sellingPriceRupiah, 18000);
        expect(newActive.id, isNot(oldRecipe!.id));
      },
    );

    test('throws for a nonexistent product', () async {
      final durianId = await seedIngredientWithCost(
        name: 'Durian',
        costPerUnit: 500,
      );

      expect(
        () => repository.addRecipeVersion(
          productId: 9999,
          sellingPriceRupiah: 18000,
          items: [
            RecipeItemInput(ingredientId: durianId, quantityPerBatch: 12),
          ],
        ),
        throwsA(isA<ProductNotFoundException>()),
      );
    });
  });
}
