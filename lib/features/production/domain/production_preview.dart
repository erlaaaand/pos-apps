import '../../orders/domain/order_detail.dart';
import 'ingredient_shortfall.dart';

/// Result of checking a closed PO's ingredient needs against current stock
/// (B.3), before the owner confirms which orders actually get cooked.
class ProductionPreview {
  const ProductionPreview({
    required this.waitingOrders,
    required this.shortfalls,
    required this.suggestedOrderIdsToCook,
  });

  /// All `waiting` orders in the PO, sorted oldest-first (FIFO order).
  final List<OrderDetail> waitingOrders;

  /// Empty when total need across [waitingOrders] fits current stock.
  final List<IngredientShortfall> shortfalls;

  /// Default FIFO selection of order ids that fit within current stock —
  /// the owner can override this per erp.md B.3 ("bisa diubah manual").
  final List<int> suggestedOrderIdsToCook;

  bool get isSufficient => shortfalls.isEmpty;
}
