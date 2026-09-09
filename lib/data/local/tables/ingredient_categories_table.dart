import 'package:drift/drift.dart';

/// Pengelompokan bahan baku (mis. "Buah", "Kemasan", "Bumbu") supaya daftar
/// bahan yang makin panjang tetap bisa dikelola — update.md meminta
/// inventory/kategori + filtering di Master Bahan Baku.
///
/// Kategori sengaja dipisah jadi tabel sendiri, bukan kolom teks bebas di
/// [Ingredients], supaya rename kategori cukup sekali dan filter bisa pakai
/// id yang stabil.
@DataClassName('IngredientCategory')
class IngredientCategories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {name},
  ];
}
