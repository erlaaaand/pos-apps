import 'package:business_management/data/local/app_database.dart';
import 'package:business_management/features/ingredients/data/ingredient_repository_impl.dart';
import 'package:business_management/features/ingredients/domain/ingredient_exceptions.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late IngredientRepositoryImpl repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = IngredientRepositoryImpl(db);
  });

  tearDown(() => db.close());

  group('create', () {
    test('starts stock and cost at zero', () async {
      final id = await repository.create(
        name: 'Gula Pasir',
        unit: IngredientUnit.kilogram,
      );

      final ingredient = await repository.getById(id);

      expect(ingredient!.currentStock, 0);
      expect(ingredient.currentCostPerUnit, 0);
    });

    test('rejects a duplicate name case-insensitively', () async {
      await repository.create(
        name: 'Gula Pasir',
        unit: IngredientUnit.kilogram,
      );

      expect(
        () => repository.create(
          name: 'gula pasir',
          unit: IngredientUnit.kilogram,
        ),
        throwsA(isA<DuplicateIngredientNameException>()),
      );
    });
  });

  group('recordPurchase', () {
    test(
      'sets cost per unit from the first purchase (erp.md A.1)',
      () async {
        final id = await repository.create(
          name: 'Gula Pasir',
          unit: IngredientUnit.kilogram,
        );

        await repository.recordPurchase(
          ingredientId: id,
          quantity: 2,
          totalPriceRupiah: 30000,
          purchasedAt: DateTime(2026, 1, 1),
        );

        final ingredient = await repository.getById(id);
        expect(ingredient!.currentStock, 2);
        expect(ingredient.currentCostPerUnit, 15000);
      },
    );

    test(
      'recalculates cost as a weighted average across purchases (erp.md A.2 formula)',
      () async {
        final id = await repository.create(
          name: 'Gula Pasir',
          unit: IngredientUnit.kilogram,
        );

        // stok_lama=2, harga_lama=15000 -> nilai lama 30000
        await repository.recordPurchase(
          ingredientId: id,
          quantity: 2,
          totalPriceRupiah: 30000,
          purchasedAt: DateTime(2026, 1, 1),
        );

        // beli 3kg seharga 60000 (20000/kg) -> (30000+60000)/(2+3) = 18000
        await repository.recordPurchase(
          ingredientId: id,
          quantity: 3,
          totalPriceRupiah: 60000,
          purchasedAt: DateTime(2026, 1, 2),
        );

        final ingredient = await repository.getById(id);
        expect(ingredient!.currentStock, 5);
        expect(ingredient.currentCostPerUnit, 18000);
      },
    );

    test('rejects zero or negative quantity', () async {
      final id = await repository.create(
        name: 'Gula Pasir',
        unit: IngredientUnit.kilogram,
      );

      expect(
        () => repository.recordPurchase(
          ingredientId: id,
          quantity: 0,
          totalPriceRupiah: 10000,
          purchasedAt: DateTime(2026, 1, 1),
        ),
        throwsArgumentError,
      );
    });

    test('rejects zero or negative price', () async {
      final id = await repository.create(
        name: 'Gula Pasir',
        unit: IngredientUnit.kilogram,
      );

      expect(
        () => repository.recordPurchase(
          ingredientId: id,
          quantity: 1,
          totalPriceRupiah: 0,
          purchasedAt: DateTime(2026, 1, 1),
        ),
        throwsArgumentError,
      );
    });

    test('is recorded in purchase history', () async {
      final id = await repository.create(
        name: 'Gula Pasir',
        unit: IngredientUnit.kilogram,
      );

      await repository.recordPurchase(
        ingredientId: id,
        quantity: 2,
        totalPriceRupiah: 30000,
        storeName: 'Pasar Induk',
        purchasedAt: DateTime(2026, 1, 1),
      );

      final history = await repository.watchPurchases(id).first;
      expect(history, hasLength(1));
      expect(history.first.storeName, 'Pasar Induk');
    });
  });

  group('delete', () {
    test('succeeds when the ingredient has no history', () async {
      final id = await repository.create(
        name: 'Gula Pasir',
        unit: IngredientUnit.kilogram,
      );

      await repository.delete(id);

      expect(await repository.getById(id), isNull);
    });

    test('throws when the ingredient has purchase history', () async {
      final id = await repository.create(
        name: 'Gula Pasir',
        unit: IngredientUnit.kilogram,
      );
      await repository.recordPurchase(
        ingredientId: id,
        quantity: 1,
        totalPriceRupiah: 1000,
        purchasedAt: DateTime(2026, 1, 1),
      );

      expect(
        () => repository.delete(id),
        throwsA(isA<IngredientInUseException>()),
      );
    });
  });
}
