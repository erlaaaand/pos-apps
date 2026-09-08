import '../../orders/domain/order_detail.dart';

/// Pure FIFO allocator for B.3's "tetap dimasak sebagian" flow: greedily
/// includes orders oldest-first as long as every ingredient they need still
/// fits in the running stock balance. No I/O — kept separate from
/// [ProductionRepository] so the allocation rule can be unit tested without
/// a database.
List<int> computeFifoSelection({
  required List<OrderDetail> ordersOldestFirst,
  required Map<int, Map<int, double>> ingredientNeedByOrderId,
  required Map<int, double> availableStockByIngredientId,
}) {
  final remainingStock = Map<int, double>.from(availableStockByIngredientId);
  final selected = <int>[];

  for (final detail in ordersOldestFirst) {
    final need = ingredientNeedByOrderId[detail.order.id] ?? const {};
    final fits = need.entries.every(
      (entry) => (remainingStock[entry.key] ?? 0) >= entry.value,
    );
    if (!fits) continue;

    for (final entry in need.entries) {
      remainingStock[entry.key] = (remainingStock[entry.key] ?? 0) - entry.value;
    }
    selected.add(detail.order.id);
  }

  return selected;
}
