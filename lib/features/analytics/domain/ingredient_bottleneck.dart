/// How often an ingredient shortage caused an order cancellation (Bagian C:
/// "laporan pembatalan & bottleneck bahan"), for restock prioritization.
class IngredientBottleneck {
  const IngredientBottleneck({
    required this.ingredientName,
    required this.cancellationCount,
  });

  final String ingredientName;
  final int cancellationCount;
}
