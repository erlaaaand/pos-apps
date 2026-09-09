import 'package:dapur_kelaris/data/local/app_database.dart';
import 'package:dapur_kelaris/features/orders/domain/order_detail.dart';
import 'package:dapur_kelaris/features/production/domain/fifo_selector.dart';
import 'package:flutter_test/flutter_test.dart';

CustomerOrder _order(int id, int quantity, DateTime orderedAt) {
  return CustomerOrder(
    id: id,
    purchaseOrderId: 1,
    productId: 1,
    recipeId: 1,
    quantity: quantity,
    unitPriceRupiah: 10000,
    status: OrderStatus.waiting,
    orderedAt: orderedAt,
  );
}

void main() {
  test('includes orders oldest-first while stock allows', () {
    final orders = [
      OrderDetail(
        order: _order(1, 5, DateTime(2026, 1, 1, 8)),
        productName: 'A',
      ),
      OrderDetail(
        order: _order(2, 5, DateTime(2026, 1, 1, 9)),
        productName: 'A',
      ),
      OrderDetail(
        order: _order(3, 5, DateTime(2026, 1, 1, 10)),
        productName: 'A',
      ),
    ];
    // Each order needs 1 unit of ingredient 100 per order (need scales with
    // qty in the real repository; here we keep it simple and per-order).
    final need = {
      1: {100: 5.0},
      2: {100: 5.0},
      3: {100: 5.0},
    };
    // Only enough stock for the first two orders.
    final stock = {100: 10.0};

    final selected = computeFifoSelection(
      ordersOldestFirst: orders,
      ingredientNeedByOrderId: need,
      availableStockByIngredientId: stock,
    );

    expect(selected, [1, 2]);
  });

  test(
    'skips an order that would exceed stock but keeps checking later ones',
    () {
      final orders = [
        OrderDetail(
          order: _order(1, 1, DateTime(2026, 1, 1, 8)),
          productName: 'A',
        ),
        OrderDetail(
          order: _order(2, 1, DateTime(2026, 1, 1, 9)),
          productName: 'A',
        ),
        OrderDetail(
          order: _order(3, 1, DateTime(2026, 1, 1, 10)),
          productName: 'A',
        ),
      ];
      final need = {
        1: {100: 8.0}, // too big, skipped
        2: {100: 3.0},
        3: {100: 3.0},
      };
      final stock = {100: 6.0};

      final selected = computeFifoSelection(
        ordersOldestFirst: orders,
        ingredientNeedByOrderId: need,
        availableStockByIngredientId: stock,
      );

      // Order 1 doesn't fit even alone; 2 and 3 together (6.0) exactly fit.
      expect(selected, [2, 3]);
    },
  );

  test('handles multiple ingredients per order independently', () {
    final orders = [
      OrderDetail(
        order: _order(1, 1, DateTime(2026, 1, 1, 8)),
        productName: 'A',
      ),
      OrderDetail(
        order: _order(2, 1, DateTime(2026, 1, 1, 9)),
        productName: 'A',
      ),
    ];
    final need = {
      1: {100: 2.0, 200: 1.0},
      2: {100: 2.0, 200: 1.0},
    };
    // Ingredient 200 only has enough for one order even though 100 has
    // enough for both.
    final stock = {100: 10.0, 200: 1.0};

    final selected = computeFifoSelection(
      ordersOldestFirst: orders,
      ingredientNeedByOrderId: need,
      availableStockByIngredientId: stock,
    );

    expect(selected, [1]);
  });

  test('returns an empty selection when nothing fits', () {
    final orders = [
      OrderDetail(
        order: _order(1, 1, DateTime(2026, 1, 1, 8)),
        productName: 'A',
      ),
    ];
    final need = {
      1: {100: 5.0},
    };
    final stock = {100: 1.0};

    final selected = computeFifoSelection(
      ordersOldestFirst: orders,
      ingredientNeedByOrderId: need,
      availableStockByIngredientId: stock,
    );

    expect(selected, isEmpty);
  });
}
