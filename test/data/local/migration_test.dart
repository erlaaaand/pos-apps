import 'dart:io';

import 'package:dapur_kelaris/data/local/app_database.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

/// Bagian D memulihkan file `.db` mentah, dan HP pemilik sudah berisi data
/// dari skema v1. Migrasi v1→v2 karena itu harus terbukti tidak menghapus
/// apa pun — kalau gagal, data usaha yang sudah berjalan ikut hilang.
void main() {
  late Directory tempRoot;
  late File dbFile;

  setUp(() async {
    tempRoot = await Directory.systemTemp.createTemp('migration_test_');
    dbFile = File('${tempRoot.path}/business_management.sqlite');
  });

  tearDown(() async {
    if (await tempRoot.exists()) {
      await tempRoot.delete(recursive: true);
    }
  });

  /// Menulis file database yang bentuknya persis skema v1: hanya tabel yang
  /// disentuh migrasi, tanpa kolom yang baru ada di v2.
  void createV1DatabaseWithData() {
    final raw = sqlite3.open(dbFile.path);
    raw.execute('PRAGMA user_version = 1');

    raw.execute('''
      CREATE TABLE ingredients (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        unit INTEGER NOT NULL,
        current_stock REAL NOT NULL DEFAULT 0.0,
        current_cost_per_unit REAL NOT NULL DEFAULT 0.0,
        created_at INTEGER NOT NULL,
        UNIQUE (name)
      )
    ''');
    raw.execute('''
      CREATE TABLE ingredient_purchases (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        ingredient_id INTEGER NOT NULL REFERENCES ingredients (id),
        quantity REAL NOT NULL,
        total_price_rupiah INTEGER NOT NULL,
        store_name TEXT NULL,
        purchased_at INTEGER NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
    raw.execute('''
      CREATE TABLE products (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0, 1)),
        created_at INTEGER NOT NULL,
        UNIQUE (name)
      )
    ''');
    raw.execute('''
      CREATE TABLE recipes (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL REFERENCES products (id),
        selling_price_rupiah INTEGER NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0, 1)),
        created_at INTEGER NOT NULL
      )
    ''');
    raw.execute('''
      CREATE TABLE recipe_items (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        recipe_id INTEGER NOT NULL REFERENCES recipes (id),
        ingredient_id INTEGER NOT NULL REFERENCES ingredients (id),
        quantity_per_batch REAL NOT NULL
      )
    ''');

    const epoch = 1757000000;
    raw.execute(
      'INSERT INTO ingredients (id, name, unit, current_stock, '
      'current_cost_per_unit, created_at) VALUES (1, ?, 1, 5.0, 30000.0, ?)',
      ['Durian', epoch],
    );
    raw.execute(
      'INSERT INTO ingredient_purchases (id, ingredient_id, quantity, '
      'total_price_rupiah, store_name, purchased_at, created_at) '
      'VALUES (1, 1, 5.0, 150000, ?, ?, ?)',
      ['Pasar Kliwon', epoch, epoch],
    );
    raw.execute(
      'INSERT INTO products (id, name, is_active, created_at) '
      'VALUES (1, ?, 1, ?)',
      ['Es Teler Durian', epoch],
    );
    raw.execute(
      'INSERT INTO recipes (id, product_id, selling_price_rupiah, is_active, '
      'created_at) VALUES (1, 1, 15000, 1, ?)',
      [epoch],
    );
    raw.execute(
      'INSERT INTO recipe_items (id, recipe_id, ingredient_id, '
      'quantity_per_batch) VALUES (1, 1, 1, 0.2)',
    );

    raw.close();
  }

  test('v1 database migrates to v2 without losing existing rows', () async {
    createV1DatabaseWithData();

    final db = AppDatabase(NativeDatabase(dbFile));
    addTearDown(db.close);

    // Membaca apa pun memaksa drift menjalankan onUpgrade lebih dulu.
    final ingredients = await db.select(db.ingredients).get();

    expect(ingredients, hasLength(1));
    final durian = ingredients.single;
    expect(durian.name, 'Durian');
    expect(durian.unit, IngredientUnit.kilogram);
    expect(durian.currentStock, 5.0);
    expect(durian.currentCostPerUnit, 30000.0);

    final purchases = await db.select(db.ingredientPurchases).get();
    expect(purchases, hasLength(1));
    expect(purchases.single.totalPriceRupiah, 150000);
    expect(purchases.single.storeName, 'Pasar Kliwon');

    final recipeItems = await db.select(db.recipeItems).get();
    expect(recipeItems, hasLength(1));
    expect(recipeItems.single.quantityPerBatch, 0.2);
  });

  test('new v2 columns default sensibly for rows written under v1', () async {
    createV1DatabaseWithData();

    final db = AppDatabase(NativeDatabase(dbFile));
    addTearDown(db.close);

    final durian = await db.select(db.ingredients).getSingle();
    expect(
      durian.categoryId,
      isNull,
      reason: 'bahan lama belum punya kategori',
    );

    final purchase = await db.select(db.ingredientPurchases).getSingle();
    expect(
      purchase.batchId,
      isNull,
      reason: 'pembelian satuan lama bukan bagian dari batch borongan',
    );

    final recipeItem = await db.select(db.recipeItems).getSingle();
    expect(
      recipeItem.kind,
      RecipeItemKind.ingredient,
      reason: 'baris resep lama harus dianggap bahan baku, bukan kemasan',
    );
  });

  test('new v2 tables exist and are writable after migrating', () async {
    createV1DatabaseWithData();

    final db = AppDatabase(NativeDatabase(dbFile));
    addTearDown(db.close);

    expect(await db.select(db.ingredientCategories).get(), isEmpty);
    expect(await db.select(db.purchaseBatches).get(), isEmpty);
    expect(await db.select(db.capitalEntries).get(), isEmpty);

    final categoryId = await db
        .into(db.ingredientCategories)
        .insert(IngredientCategoriesCompanion.insert(name: 'Buah'));
    await (db.update(db.ingredients)..where((t) => t.id.equals(1))).write(
      IngredientsCompanion(categoryId: Value(categoryId)),
    );

    final durian = await db.select(db.ingredients).getSingle();
    expect(durian.categoryId, categoryId);

    await db
        .into(db.capitalEntries)
        .insert(
          CapitalEntriesCompanion.insert(
            kind: CapitalEntryKind.initial,
            amountRupiah: 2000000,
            recordedAt: DateTime(2026, 9, 9),
          ),
        );
    expect(await db.select(db.capitalEntries).get(), hasLength(1));
  });

  test('a fresh database is created directly at v2', () async {
    final db = AppDatabase(NativeDatabase(dbFile));
    addTearDown(db.close);

    expect(await db.select(db.ingredients).get(), isEmpty);
    expect(await db.select(db.capitalEntries).get(), isEmpty);

    // Semua tabel v2 harus ada, bukan cuma yang disentuh migrasi.
    expect(await db.select(db.orders).get(), isEmpty);
    expect(await db.select(db.dailyClosings).get(), isEmpty);
  });
}
