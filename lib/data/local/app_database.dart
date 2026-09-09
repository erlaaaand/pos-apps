import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/backup_logs_table.dart';
import 'tables/capital_entries_table.dart';
import 'tables/daily_closings_table.dart';
import 'tables/daily_operational_costs_table.dart';
import 'tables/ingredient_categories_table.dart';
import 'tables/ingredient_purchases_table.dart';
import 'tables/ingredient_usages_table.dart';
import 'tables/ingredients_table.dart';
import 'tables/order_cancellation_causes_table.dart';
import 'tables/po_product_quotas_table.dart';
import 'tables/orders_table.dart';
import 'tables/production_session_costs_table.dart';
import 'tables/production_sessions_table.dart';
import 'tables/products_table.dart';
import 'tables/purchase_batches_table.dart';
import 'tables/purchase_orders_table.dart';
import 'tables/recipe_items_table.dart';
import 'tables/recipes_table.dart';

// Re-exported so feature code can import just this file to get the database,
// generated row classes, and the enums used in table definitions.
export 'tables/backup_logs_table.dart';
export 'tables/capital_entries_table.dart';
export 'tables/daily_closings_table.dart';
export 'tables/daily_operational_costs_table.dart';
export 'tables/ingredient_categories_table.dart';
export 'tables/ingredient_purchases_table.dart';
export 'tables/ingredient_usages_table.dart';
export 'tables/ingredients_table.dart';
export 'tables/order_cancellation_causes_table.dart';
export 'tables/po_product_quotas_table.dart';
export 'tables/orders_table.dart';
export 'tables/production_session_costs_table.dart';
export 'tables/production_sessions_table.dart';
export 'tables/products_table.dart';
export 'tables/purchase_batches_table.dart';
export 'tables/purchase_orders_table.dart';
export 'tables/recipe_items_table.dart';
export 'tables/recipes_table.dart';

part 'app_database.g.dart';

/// Base filename (without extension) of the app's SQLite database — shared
/// by [AppDatabase] and [resolveDatabaseFile] so they can never drift apart.
///
/// JANGAN DIUBAH. Nilainya sengaja masih memakai nama lama meskipun paket
/// sudah berganti nama jadi Dapur Kelaris: ini adalah nama berkas nyata di
/// penyimpanan HP. Menggantinya membuat aplikasi membuka database kosong dan
/// seluruh data warung yang sudah ada seolah hilang.
const String kDatabaseFileName = 'business_management';

/// Resolves the on-disk path of the live database file, for Bagian D
/// (backup/restore) to copy/replace directly. Mirrors the directory + name
/// + `.sqlite` convention `driftDatabase()` uses internally.
Future<File> resolveDatabaseFile() async {
  final directory = await getApplicationSupportDirectory();
  return File(p.join(directory.path, '$kDatabaseFileName.sqlite'));
}

/// The app's single SQLite database.
///
/// Versi 1 memuat seluruh skema erp.md (Bagian A–D). Versi 2 menambahkan
/// kebutuhan new_flow.md + update.md: kategori bahan, batch belanja borongan,
/// catatan modal, serta pemisahan bahan/kemasan pada baris resep.
@DriftDatabase(
  tables: [
    IngredientCategories,
    Ingredients,
    PurchaseBatches,
    IngredientPurchases,
    Products,
    Recipes,
    RecipeItems,
    PurchaseOrders,
    PoProductQuotas,
    Orders,
    OrderCancellationCauses,
    ProductionSessions,
    ProductionSessionCosts,
    IngredientUsages,
    DailyOperationalCosts,
    DailyClosings,
    CapitalEntries,
    BackupLogs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // Tabel baru. Dibuat lebih dulu karena kolom FK di bawah merujuknya.
        await m.createTable(ingredientCategories);
        await m.createTable(purchaseBatches);
        await m.createTable(capitalEntries);

        // Kolom baru di tabel lama. Semuanya nullable atau punya default,
        // jadi baris yang sudah ada tetap valid tanpa backfill: bahan lama
        // berkategori kosong, pembelian lama tanpa batch, dan baris resep
        // lama otomatis dianggap `RecipeItemKind.ingredient` (indeks 0).
        await m.addColumn(ingredients, ingredients.categoryId);
        await m.addColumn(ingredientPurchases, ingredientPurchases.batchId);
        await m.addColumn(recipeItems, recipeItems.kind);
      }
    },
    beforeOpen: (details) async {
      // SQLite mematikan penegakan foreign key secara default. Tanpa ini,
      // kolom FK baru (categoryId, batchId) bisa menyimpan id yatim.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: kDatabaseFileName,
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
