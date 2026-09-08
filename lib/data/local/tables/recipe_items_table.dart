import 'package:drift/drift.dart';

import 'ingredients_table.dart';
import 'recipes_table.dart';

/// Satu baris takaran bahan dalam resep (BOM line). Wajib merujuk
/// [Ingredients] yang sudah terdaftar — erp.md A.3 melarang bahan "muncul"
/// langsung dari form resep tanpa riwayat pembelian.
@DataClassName('RecipeItem')
class RecipeItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get recipeId => integer().references(Recipes, #id)();

  IntColumn get ingredientId => integer().references(Ingredients, #id)();

  /// Quantity required per production batch, in the ingredient's unit.
  RealColumn get quantityPerBatch => real()();
}
