import 'package:drift/drift.dart';

import 'ingredient_categories_table.dart';

/// Satuan bahan baku (A.1), diperluas untuk konteks masakan sesuai update.md.
///
/// Disimpan sebagai indeks integer ([intEnum]): lima nilai pertama adalah
/// satuan asli aplikasi dan indeksnya sudah menempel di data lama — **jangan
/// pernah diurut ulang atau dihapus, hanya boleh ditambah di akhir**.
enum IngredientUnit {
  // --- Berat & volume dasar (indeks 0-4, dari versi pertama) ---
  gram,
  kilogram,
  pcs,
  milliliter,
  liter,

  // --- Takaran dapur ---
  sendokTeh,
  sendokMakan,
  gelas,

  // --- Satuan hitung alami ---
  buah,
  butir,
  lembar,
  ikat,

  // --- Kemasan beli / kemasan jual ---
  bungkus,
  sachet,
  botol,
  kaleng,
  pack,

  // --- Berat tambahan ---
  ons,
}

/// Master bahan baku (A.1). [currentStock] and [currentCostPerUnit] are never
/// written directly by the UI — they are derived exclusively from recorded
/// purchases (see [IngredientPurchases]) via the weighted-average formula in
/// `IngredientRepository.recordPurchase`.
@DataClassName('Ingredient')
class Ingredients extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get unit => intEnum<IngredientUnit>()();

  /// Pengelompokan opsional (update.md). Nullable karena bahan lama belum
  /// punya kategori dan pemilik boleh membiarkannya kosong.
  IntColumn get categoryId =>
      integer().nullable().references(IngredientCategories, #id)();

  /// Quantity on hand, in [unit].
  RealColumn get currentStock => real().withDefault(const Constant(0))();

  /// Weighted-average cost per [unit], in whole Rupiah. Stored as a double
  /// because it is a *ratio* (total Rupiah spent / quantity bought) and is
  /// only ever an intermediate figure for computing recipe HPP — every
  /// actually-recorded money amount derived from it (a purchase total, a
  /// sale's HPP snapshot) is rounded to a whole-Rupiah [int] at the point it
  /// becomes a real transaction. See ADR note in `PurchaseRepository`.
  RealColumn get currentCostPerUnit => real().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {name},
  ];
}
