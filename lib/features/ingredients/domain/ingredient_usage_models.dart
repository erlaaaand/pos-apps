import '../../../data/local/app_database.dart';

/// Rincian resep produk aktif yang memakai bahan baku ini.
class IngredientRecipeUsage {
  const IngredientRecipeUsage({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.kind,
  });

  final int productId;
  final String productName;
  final double quantity;
  final RecipeItemKind kind;
}

/// Rincian riwayat pemakaian bahan baku dalam satu sesi produksi.
class IngredientProductionUsage {
  const IngredientProductionUsage({
    required this.sessionId,
    required this.sessionDate,
    required this.poLabel,
    required this.quantityUsed,
  });

  final int sessionId;
  final DateTime sessionDate;
  final String? poLabel;
  final double quantityUsed;
}
