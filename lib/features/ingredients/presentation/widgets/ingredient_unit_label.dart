import '../../../../data/local/app_database.dart';

/// Display labels for [IngredientUnit] — kept in one place so every screen
/// shows the same wording.
extension IngredientUnitLabel on IngredientUnit {
  String get label => switch (this) {
    IngredientUnit.gram => 'Gram',
    IngredientUnit.kilogram => 'Kilogram',
    IngredientUnit.pcs => 'Pcs',
    IngredientUnit.milliliter => 'Mililiter',
    IngredientUnit.liter => 'Liter',
  };

  String get shortLabel => switch (this) {
    IngredientUnit.gram => 'gram',
    IngredientUnit.kilogram => 'kg',
    IngredientUnit.pcs => 'pcs',
    IngredientUnit.milliliter => 'ml',
    IngredientUnit.liter => 'liter',
  };
}
