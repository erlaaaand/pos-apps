import 'package:drift/drift.dart';

/// Unit of measure for a raw ingredient, per erp.md A.1 (gram/kg/pcs/ml/liter).
enum IngredientUnit { gram, kilogram, pcs, milliliter, liter }

/// Master bahan baku (A.1). [currentStock] and [currentCostPerUnit] are never
/// written directly by the UI — they are derived exclusively from recorded
/// purchases (see [IngredientPurchases]) via the weighted-average formula in
/// `IngredientRepository.recordPurchase`.
@DataClassName('Ingredient')
class Ingredients extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get unit => intEnum<IngredientUnit>()();

  /// Quantity on hand, in [unit].
  RealColumn get currentStock => real().withDefault(const Constant(0))();

  /// Weighted-average cost per [unit], in whole Rupiah. Stored as a double
  /// because it is a *ratio* (total Rupiah spent / quantity bought) and is
  /// only ever an intermediate figure for computing recipe HPP — every
  /// actually-recorded money amount derived from it (a purchase total, a
  /// sale's HPP snapshot) is rounded to a whole-Rupiah [int] at the point it
  /// becomes a real transaction. See ADR note in `PurchaseRepository`.
  RealColumn get currentCostPerUnit =>
      real().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {name},
  ];
}
