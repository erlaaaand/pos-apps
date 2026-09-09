import 'package:drift/drift.dart';

import '../../../data/local/app_database.dart';
import '../domain/order_detail.dart';
import '../domain/order_exceptions.dart';
import 'order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<OrderDetail>> watchByPurchaseOrder(int purchaseOrderId) {
    return _watchOrders((t) => t.purchaseOrderId.equals(purchaseOrderId));
  }

  @override
  Stream<List<OrderDetail>> watchWaitingByPurchaseOrder(int purchaseOrderId) {
    return _watchOrders(
      (t) =>
          t.purchaseOrderId.equals(purchaseOrderId) &
          t.status.equalsValue(OrderStatus.waiting),
    );
  }

  Stream<List<OrderDetail>> _watchOrders(
    Expression<bool> Function($OrdersTable t) predicate,
  ) {
    final query =
        _db.select(_db.orders).join([
            innerJoin(
              _db.products,
              _db.products.id.equalsExp(_db.orders.productId),
            ),
          ])
          ..where(predicate(_db.orders))
          ..orderBy([OrderingTerm(expression: _db.orders.orderedAt)]);

    return query.watch().map(
      (rows) => rows
          .map(
            (row) => OrderDetail(
              order: row.readTable(_db.orders),
              productName: row.readTable(_db.products).name,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<CustomerOrder?> getById(int id) {
    return (_db.select(
      _db.orders,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  @override
  Future<int> create({
    required int purchaseOrderId,
    required int productId,
    required int quantity,
    String? buyerContact,
    String? note,
  }) async {
    if (quantity <= 0) {
      throw ArgumentError.value(quantity, 'quantity', 'Qty harus lebih dari 0');
    }

    final po = await (_db.select(
      _db.purchaseOrders,
    )..where((t) => t.id.equals(purchaseOrderId))).getSingleOrNull();
    if (po == null || po.status != PoStatus.open) {
      throw const PurchaseOrderNotOpenException();
    }

    final product = await (_db.select(
      _db.products,
    )..where((t) => t.id.equals(productId))).getSingleOrNull();
    if (product == null || !product.isActive) {
      throw ProductNotActiveException(product?.name ?? 'Produk');
    }

    final recipe =
        await (_db.select(_db.recipes)..where(
              (t) => t.productId.equals(productId) & t.isActive.equals(true),
            ))
            .getSingleOrNull();
    if (recipe == null) {
      throw NoActiveRecipeException(product.name);
    }

    return _db
        .into(_db.orders)
        .insert(
          OrdersCompanion.insert(
            purchaseOrderId: purchaseOrderId,
            productId: productId,
            recipeId: recipe.id,
            quantity: quantity,
            unitPriceRupiah: recipe.sellingPriceRupiah,
            buyerContact: Value(buyerContact),
            note: Value(note),
          ),
        );
  }

  @override
  Future<void> cancel(int orderId, {required String reason}) async {
    final order = await getById(orderId);
    if (order == null) throw OrderNotFoundException(orderId);
    if (order.status != OrderStatus.waiting) {
      throw const InvalidOrderStatusTransitionException();
    }

    await (_db.update(_db.orders)..where((t) => t.id.equals(orderId))).write(
      OrdersCompanion(
        status: const Value(OrderStatus.cancelled),
        cancellationReason: Value(reason),
      ),
    );
  }

  @override
  Future<void> complete(int orderId) async {
    final order = await getById(orderId);
    if (order == null) throw OrderNotFoundException(orderId);
    if (order.status != OrderStatus.readyForPickup) {
      throw const InvalidOrderStatusTransitionException();
    }

    await (_db.update(_db.orders)..where((t) => t.id.equals(orderId))).write(
      OrdersCompanion(
        status: const Value(OrderStatus.completed),
        completedAt: Value(DateTime.now()),
      ),
    );
  }
}
