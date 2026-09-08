import '../../../data/local/app_database.dart';
import '../domain/order_detail.dart';

/// Abstraction over pesanan masuk (B.2) and their completion (B.4).
abstract interface class OrderRepository {
  Stream<List<OrderDetail>> watchByPurchaseOrder(int purchaseOrderId);

  Stream<List<OrderDetail>> watchWaitingByPurchaseOrder(int purchaseOrderId);

  Future<CustomerOrder?> getById(int id);

  /// Records a WhatsApp order against an open PO. Snapshots the product's
  /// current active recipe (id + selling price) onto the order so later
  /// recipe/price changes never retroactively edit it.
  Future<int> create({
    required int purchaseOrderId,
    required int productId,
    required int quantity,
    String? buyerContact,
    String? note,
  });

  /// Manual pre-production cancellation (e.g. buyer changed their mind) —
  /// distinct from the bahan-kurang cancellation applied in bulk by
  /// `ProductionService` at B.3.
  Future<void> cancel(int orderId, {required String reason});

  /// B.4: buyer picked up and paid — status readyForPickup → completed.
  Future<void> complete(int orderId);
}
