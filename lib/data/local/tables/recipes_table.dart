import 'package:drift/drift.dart';

import 'products_table.dart';

/// Resep/BOM (A.3). Recipes are immutable once created and are **never**
/// deleted or edited in place — "Tambah Resep Baru" for an existing product
/// inserts a new row and deactivates the old one in the same transaction, so
/// past orders that reference an old (now-inactive) recipe keep their exact
/// historical BOM/price/HPP basis intact. This is what makes the HPP
/// snapshot on [Orders] trustworthy even after prices or recipes change.
@DataClassName('Recipe')
class Recipes extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get productId => integer().references(Products, #id)();

  /// Selling price at the time this recipe version was created, in whole
  /// Rupiah. Copied onto each [Orders] row at order time so a later recipe
  /// revision never retroactively changes an already-placed order's price.
  IntColumn get sellingPriceRupiah => integer()();

  /// At most one recipe per product should be active at a time — enforced
  /// by `RecipeRepository.addRecipe`, not by a DB constraint (SQLite can't
  /// express "unique where isActive" portably without a partial index).
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
