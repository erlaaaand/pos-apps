import 'package:drift/drift.dart';

import 'ingredients_table.dart';

/// Riwayat pembelian bahan baku (A.2). Every row is immutable once inserted —
/// it is the source of truth that [Ingredients.currentStock] and
/// [Ingredients.currentCostPerUnit] are recalculated from, and it also feeds
/// the ingredient price-trend report in Bagian C.
@DataClassName('IngredientPurchase')
class IngredientPurchases extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get ingredientId => integer().references(Ingredients, #id)();

  /// Quantity bought, in the ingredient's unit.
  RealColumn get quantity => real()();

  /// Total price actually paid, in whole Rupiah. This — not qty × unit price
  /// — is the authoritative money figure used for the weighted-average
  /// recalculation, since it's what the owner actually entered.
  IntColumn get totalPriceRupiah => integer()();

  TextColumn get storeName => text().nullable()();

  /// Date the purchase happened (as entered by the owner).
  DateTimeColumn get purchasedAt => dateTime()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
