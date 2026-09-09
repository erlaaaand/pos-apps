import 'package:dapur_kelaris/data/local/app_database.dart';
import 'package:dapur_kelaris/features/ingredients/data/ingredient_repository_impl.dart';
import 'package:dapur_kelaris/features/ingredients/domain/batch_purchase_line_input.dart';
import 'package:dapur_kelaris/features/ingredients/domain/ingredient_exceptions.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pembelian borongan (new_flow.md A.2): satu transaksi belanja, beberapa
/// bahan, satu harga total yang dibagi ke tiap bahan.
void main() {
  late AppDatabase db;
  late IngredientRepositoryImpl repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = IngredientRepositoryImpl(db);
  });

  tearDown(() => db.close());

  Future<int> addIngredient(String name, IngredientUnit unit) {
    return repository.create(name: name, unit: unit);
  }

  test('splits one shopping total across several ingredients', () async {
    final kolang = await addIngredient('Kolang-kaling', IngredientUnit.gram);
    final pandan = await addIngredient('Daun Pandan', IngredientUnit.lembar);
    final jahe = await addIngredient('Jahe', IngredientUnit.gram);

    await repository.recordBatchPurchase(
      purchasedAt: DateTime(2026, 9, 9),
      storeName: 'Pasar Legi',
      totalPriceRupiah: 20000,
      lines: [
        BatchPurchaseLineInput(
          ingredientId: kolang,
          quantity: 500,
          allocatedPriceRupiah: 6666,
        ),
        BatchPurchaseLineInput(
          ingredientId: pandan,
          quantity: 10,
          allocatedPriceRupiah: 6666,
        ),
        BatchPurchaseLineInput(
          ingredientId: jahe,
          quantity: 200,
          allocatedPriceRupiah: 6668,
        ),
      ],
    );

    final batches = await db.select(db.purchaseBatches).get();
    expect(batches, hasLength(1));
    expect(batches.single.totalPriceRupiah, 20000);
    expect(batches.single.storeName, 'Pasar Legi');

    final purchases = await db.select(db.ingredientPurchases).get();
    expect(purchases, hasLength(3));
    expect(
      purchases.every((p) => p.batchId == batches.single.id),
      isTrue,
      reason: 'tiap baris harus menempel ke batch belanjanya',
    );
    expect(
      purchases.fold<int>(0, (sum, p) => sum + p.totalPriceRupiah),
      20000,
      reason: 'total alokasi tidak boleh meleset dari yang dibayar',
    );
  });

  test('each ingredient still gets its own weighted-average cost', () async {
    final kolang = await addIngredient('Kolang-kaling', IngredientUnit.gram);
    final jahe = await addIngredient('Jahe', IngredientUnit.gram);

    await repository.recordBatchPurchase(
      purchasedAt: DateTime(2026, 9, 9),
      totalPriceRupiah: 20000,
      lines: [
        BatchPurchaseLineInput(
          ingredientId: kolang,
          quantity: 500,
          allocatedPriceRupiah: 15000,
        ),
        BatchPurchaseLineInput(
          ingredientId: jahe,
          quantity: 100,
          allocatedPriceRupiah: 5000,
        ),
      ],
    );

    final kolangRow = await repository.getById(kolang);
    final jaheRow = await repository.getById(jahe);

    // Harga modal dihitung per bahan dari porsi biayanya sendiri.
    expect(kolangRow!.currentStock, 500);
    expect(kolangRow.currentCostPerUnit, 15000 / 500);
    expect(jaheRow!.currentStock, 100);
    expect(jaheRow.currentCostPerUnit, 5000 / 100);
  });

  test('a batch keeps averaging against stock bought earlier', () async {
    final jahe = await addIngredient('Jahe', IngredientUnit.gram);

    // Pembelian satuan lebih dulu: 100 gram seharga Rp5.000 -> Rp50/gram.
    await repository.recordPurchase(
      ingredientId: jahe,
      quantity: 100,
      totalPriceRupiah: 5000,
      purchasedAt: DateTime(2026, 9, 8),
    );

    // Lalu ikut borongan: tambahan 100 gram dengan porsi biaya Rp7.000.
    await repository.recordBatchPurchase(
      purchasedAt: DateTime(2026, 9, 9),
      totalPriceRupiah: 7000,
      lines: [
        BatchPurchaseLineInput(
          ingredientId: jahe,
          quantity: 100,
          allocatedPriceRupiah: 7000,
        ),
      ],
    );

    final row = await repository.getById(jahe);
    expect(row!.currentStock, 200);
    // (100 x 50 + 7000) / 200 = 60
    expect(row.currentCostPerUnit, 60);
  });

  test('rejects a split that does not add up to the amount paid', () async {
    final jahe = await addIngredient('Jahe', IngredientUnit.gram);

    expect(
      () => repository.recordBatchPurchase(
        purchasedAt: DateTime(2026, 9, 9),
        totalPriceRupiah: 20000,
        lines: [
          BatchPurchaseLineInput(
            ingredientId: jahe,
            quantity: 100,
            allocatedPriceRupiah: 19000,
          ),
        ],
      ),
      throwsA(isA<BatchAllocationMismatchException>()),
    );
  });

  test('a rejected batch writes nothing at all', () async {
    final jahe = await addIngredient('Jahe', IngredientUnit.gram);

    await expectLater(
      repository.recordBatchPurchase(
        purchasedAt: DateTime(2026, 9, 9),
        totalPriceRupiah: 20000,
        lines: [
          BatchPurchaseLineInput(
            ingredientId: jahe,
            quantity: 100,
            allocatedPriceRupiah: 19000,
          ),
        ],
      ),
      throwsA(isA<BatchAllocationMismatchException>()),
    );

    expect(await db.select(db.purchaseBatches).get(), isEmpty);
    expect(await db.select(db.ingredientPurchases).get(), isEmpty);
    final row = await repository.getById(jahe);
    expect(row!.currentStock, 0, reason: 'stok tidak boleh ikut berubah');
  });

  test('rejects a batch with no ingredient lines', () async {
    expect(
      () => repository.recordBatchPurchase(
        purchasedAt: DateTime(2026, 9, 9),
        totalPriceRupiah: 20000,
        lines: const [],
      ),
      throwsA(isA<EmptyPurchaseBatchException>()),
    );
  });
}
