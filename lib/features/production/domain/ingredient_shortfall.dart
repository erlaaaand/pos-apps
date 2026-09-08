import '../../../data/local/app_database.dart';

/// One ingredient whose total need across a PO's waiting orders exceeds
/// current stock (B.3).
class IngredientShortfall {
  const IngredientShortfall({
    required this.ingredientId,
    required this.ingredientName,
    required this.unit,
    required this.needed,
    required this.available,
  });

  final int ingredientId;
  final String ingredientName;
  final IngredientUnit unit;
  final double needed;
  final double available;

  double get shortBy => needed - available;
}
