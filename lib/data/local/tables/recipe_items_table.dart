import 'package:drift/drift.dart';

import 'ingredients_table.dart';
import 'recipes_table.dart';

/// Pemisahan baris resep (new_flow.md A.3): bahan yang termakan/terminum
/// versus kemasan (cup, sendok, dst).
///
/// Keduanya sama-sama merujuk [Ingredients] — pemisahan ini murni struktural
/// supaya breakdown HPP bisa menunjukkan berapa besar porsi biaya kemasan
/// dibanding bahan baku.
///
/// Disimpan sebagai indeks integer ([intEnum]) — hanya boleh ditambah di
/// akhir. Baris resep lama otomatis bernilai `ingredient` (indeks 0).
enum RecipeItemKind { ingredient, packaging }

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

  /// Bahan baku atau kemasan. Default `ingredient` supaya resep yang dibuat
  /// sebelum pemisahan ini tetap valid tanpa perlu ditebak ulang.
  IntColumn get kind =>
      intEnum<RecipeItemKind>().withDefault(const Constant(0))();
}
