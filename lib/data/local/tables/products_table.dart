import 'package:drift/drift.dart';

/// Master produk (A.3). A product's price and BOM live on its active
/// [Recipes] row, not here — [Products] gives the product a stable identity
/// across recipe revisions (needed so analytics can track a product's trend
/// across recipe changes, and so "nonaktifkan resep lama" doesn't orphan
/// past sales history).
@DataClassName('Product')
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  /// Only active products are selectable for new orders (B.2). Default true
  /// per erp.md A.3 ("default Aktif untuk produk baru").
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {name},
  ];
}
