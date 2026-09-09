import 'dart:io';

import 'package:dapur_kelaris/data/local/app_database.dart';
import 'package:dapur_kelaris/features/ingredients/data/ingredient_repository_impl.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_windows/path_provider_windows.dart';

void main() {
  test('seed initial 24 ingredients and generate excel file', () async {
    final pathProvider = PathProviderWindows();
    final appSupportDir = await pathProvider.getApplicationSupportPath();
    expect(appSupportDir, isNotNull);

    final dbFile = File(p.join(appSupportDir!, '$kDatabaseFileName.sqlite'));
    print('Target database path: ${dbFile.path}');

    final db = AppDatabase(NativeDatabase(dbFile));
    final repository = IngredientRepositoryImpl(db);

    final initialData = [
      _SeedItem('Durian', IngredientUnit.gram, 'Buah-buahan', 1000, 60000),
      _SeedItem('Semangka', IngredientUnit.gram, 'Buah-buahan', 1500, 15000),
      _SeedItem('Melon', IngredientUnit.gram, 'Buah-buahan', 550, 8000),
      _SeedItem('Nangka', IngredientUnit.gram, 'Buah-buahan', 700, 18000),
      _SeedItem('Agar powder', IngredientUnit.sachet, 'Bahan Dapur', 1, 4500),
      _SeedItem('Nutrijel', IngredientUnit.sachet, 'Bahan Dapur', 1, 3500),
      _SeedItem('Susu Evorasi', IngredientUnit.gram, 'Bahan Dapur', 500, 17000),
      _SeedItem('Susu Cream', IngredientUnit.gram, 'Bahan Dapur', 365, 17000),
      _SeedItem('Mangga', IngredientUnit.gram, 'Buah-buahan', 300, 15000),
      _SeedItem('Es batu', IngredientUnit.gram, 'Bahan Dapur', 6000, 10000),
      _SeedItem('Anggur', IngredientUnit.gram, 'Buah-buahan', 150, 10000),
      _SeedItem('Beras ketan', IngredientUnit.gram, 'Bahan Dapur', 1000, 25000),
      _SeedItem(
        'Santan',
        IngredientUnit.milliliter,
        'Bahan Dapur',
        1000,
        12000,
      ),
      _SeedItem('Gula', IngredientUnit.gram, 'Bahan Dapur', 1000, 19000),
      _SeedItem('Kelapa parut', IngredientUnit.gram, 'Bahan Dapur', 500, 8000),
      _SeedItem('Keju', IngredientUnit.gram, 'Bahan Dapur', 500, 30000),
      _SeedItem(
        'Kolang-kaling (Paket Pelengkap)',
        IngredientUnit.pcs,
        'Paket Pelengkap',
        1,
        5000,
      ),
      _SeedItem(
        'Pandan (Paket Pelengkap)',
        IngredientUnit.pcs,
        'Paket Pelengkap',
        1,
        5000,
      ),
      _SeedItem(
        'Jahe (Paket Pelengkap)',
        IngredientUnit.pcs,
        'Paket Pelengkap',
        1,
        5000,
      ),
      _SeedItem('Air', IngredientUnit.pcs, 'Paket Pelengkap', 1, 0),
      _SeedItem('Cup 300g', IngredientUnit.pcs, 'Kemasan', 25, 16000),
      _SeedItem('Sendok 300g', IngredientUnit.pcs, 'Kemasan', 50, 16000),
      _SeedItem('Cup 450g', IngredientUnit.pcs, 'Kemasan', 25, 22500),
      _SeedItem('Sendok 450g', IngredientUnit.pcs, 'Kemasan', 25, 8000),
    ];

    final now = DateTime.now();

    for (final item in initialData) {
      // 1. Dapatkan / Buat Kategori
      final categories = await repository.watchCategories().first;
      int? catId;
      for (final c in categories) {
        if (c.name.toLowerCase() == item.categoryName.toLowerCase()) {
          catId = c.id;
          break;
        }
      }
      catId ??= await repository.createCategory(item.categoryName);

      // 2. Cek apakah bahan sudah ada
      final existing = await repository.watchAll().first;
      Ingredient? existingIngredient;
      for (final ing in existing) {
        if (ing.name.toLowerCase() == item.name.toLowerCase()) {
          existingIngredient = ing;
          break;
        }
      }

      int ingredientId;
      if (existingIngredient == null) {
        ingredientId = await repository.create(
          name: item.name,
          unit: item.unit,
          categoryId: catId,
        );
        print('Bahan dibuat: ${item.name}');
      } else {
        ingredientId = existingIngredient.id;
        print('Bahan sudah ada: ${item.name} (id: $ingredientId)');
      }

      // 3. Catat Pembelian Awal jika total harga > 0 dan belum ada riwayat pembelian
      if (item.totalPriceRupiah > 0) {
        final purchases = await repository.watchPurchases(ingredientId).first;
        if (purchases.isEmpty) {
          await repository.recordPurchase(
            ingredientId: ingredientId,
            quantity: item.qty,
            totalPriceRupiah: item.totalPriceRupiah,
            storeName: 'Belanja Awal',
            purchasedAt: now,
          );
          print(
            ' -> Pembelian dicatat: ${item.name} (+${item.qty}, Rp ${item.totalPriceRupiah})',
          );
        }
      }
    }

    await db.close();
  });
}

class _SeedItem {
  final String name;
  final IngredientUnit unit;
  final String categoryName;
  final double qty;
  final int totalPriceRupiah;

  _SeedItem(
    this.name,
    this.unit,
    this.categoryName,
    this.qty,
    this.totalPriceRupiah,
  );
}
