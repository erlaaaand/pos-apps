import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/backup_logs_table.dart';
import 'tables/daily_closings_table.dart';
import 'tables/daily_operational_costs_table.dart';
import 'tables/ingredient_purchases_table.dart';
import 'tables/ingredient_usages_table.dart';
import 'tables/ingredients_table.dart';
import 'tables/order_cancellation_causes_table.dart';
import 'tables/po_product_quotas_table.dart';
import 'tables/orders_table.dart';
import 'tables/production_session_costs_table.dart';
import 'tables/production_sessions_table.dart';
import 'tables/products_table.dart';
import 'tables/purchase_orders_table.dart';
import 'tables/recipe_items_table.dart';
import 'tables/recipes_table.dart';

// Re-exported so feature code can import just this file to get the database,
// generated row classes, and the enums used in table definitions.
export 'tables/backup_logs_table.dart';
export 'tables/daily_closings_table.dart';
export 'tables/daily_operational_costs_table.dart';
export 'tables/ingredient_purchases_table.dart';
export 'tables/ingredient_usages_table.dart';
export 'tables/ingredients_table.dart';
export 'tables/order_cancellation_causes_table.dart';
export 'tables/po_product_quotas_table.dart';
export 'tables/orders_table.dart';
export 'tables/production_session_costs_table.dart';
export 'tables/production_sessions_table.dart';
export 'tables/products_table.dart';
export 'tables/purchase_orders_table.dart';
export 'tables/recipe_items_table.dart';
export 'tables/recipes_table.dart';

part 'app_database.g.dart';

/// Base filename (without extension) of the app's SQLite database — shared
/// by [AppDatabase] and [resolveDatabaseFile] so they can never drift apart.
const String kDatabaseFileName = 'business_management';

/// Resolves the on-disk path of the live database file, for Bagian D
/// (backup/restore) to copy/replace directly. Mirrors the directory + name
/// + `.sqlite` convention `driftDatabase()` uses internally.
Future<File> resolveDatabaseFile() async {
  final directory = await getApplicationSupportDirectory();
  return File(p.join(directory.path, '$kDatabaseFileName.sqlite'));
}

/// The app's single SQLite database. Schema covers every module in erp.md
/// (Bagian A–D) from the start, per the spec's explicit instruction to avoid
/// future migrations as later phases are built — even though only Bagian A
/// has repositories/UI wired up so far.
@DriftDatabase(
  tables: [
    Ingredients,
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
    BackupLogs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: kDatabaseFileName,
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
