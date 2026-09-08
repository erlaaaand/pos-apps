import 'package:drift/drift.dart';

import '../../../core/date/week_start.dart';
import '../../../data/local/app_database.dart';
import '../domain/ingredient_bottleneck.dart';
import '../domain/ingredient_price_point.dart';
import '../domain/menu_performance.dart';
import '../domain/po_slot_performance.dart';
import '../domain/weekly_product_sales.dart';
import 'analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  AnalyticsRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<List<WeeklyProductSales>> weeklySalesTrend() async {
    final rows = await (_db.select(_db.orders).join([
          innerJoin(
            _db.products,
            _db.products.id.equalsExp(_db.orders.productId),
          ),
        ])
          ..where(_db.orders.status.equalsValue(OrderStatus.completed)))
        .get();

    final buckets = <(String, DateTime), (int, int)>{};
    for (final row in rows) {
      final order = row.readTable(_db.orders);
      final productName = row.readTable(_db.products).name;
      final key = (productName, weekStart(order.orderedAt));
      final existing = buckets[key] ?? (0, 0);
      buckets[key] = (
        existing.$1 + order.quantity,
        existing.$2 + order.unitPriceRupiah * order.quantity,
      );
    }

    final result = buckets.entries
        .map(
          (entry) => WeeklyProductSales(
            productName: entry.key.$1,
            weekStart: entry.key.$2,
            quantitySold: entry.value.$1,
            revenueRupiah: entry.value.$2,
          ),
        )
        .toList()
      ..sort((a, b) {
        final byWeek = b.weekStart.compareTo(a.weekStart);
        return byWeek != 0 ? byWeek : a.productName.compareTo(b.productName);
      });
    return result;
  }

  @override
  Future<List<PoSlotPerformance>> poSlotPerformance() async {
    final rows = await (_db.select(_db.orders).join([
          innerJoin(
            _db.products,
            _db.products.id.equalsExp(_db.orders.productId),
          ),
          innerJoin(
            _db.purchaseOrders,
            _db.purchaseOrders.id.equalsExp(_db.orders.purchaseOrderId),
          ),
        ])
          ..where(_db.orders.status.equalsValue(OrderStatus.completed)))
        .get();

    final buckets = <(String, String), (int, int)>{};
    for (final row in rows) {
      final order = row.readTable(_db.orders);
      final productName = row.readTable(_db.products).name;
      final slotLabel = row.readTable(_db.purchaseOrders).label;
      final key = (slotLabel, productName);
      final existing = buckets[key] ?? (0, 0);
      buckets[key] = (
        existing.$1 + order.quantity,
        existing.$2 + order.unitPriceRupiah * order.quantity,
      );
    }

    return buckets.entries
        .map(
          (entry) => PoSlotPerformance(
            slotLabel: entry.key.$1,
            productName: entry.key.$2,
            quantitySold: entry.value.$1,
            revenueRupiah: entry.value.$2,
          ),
        )
        .toList()
      ..sort((a, b) => b.revenueRupiah.compareTo(a.revenueRupiah));
  }

  @override
  Future<List<MenuPerformance>> menuPerformance() async {
    final products = await _db.select(_db.products).get();
    final rows = await _db.select(_db.orders).get();

    final ordersByProduct = <int, List<CustomerOrder>>{};
    for (final order in rows) {
      (ordersByProduct[order.productId] ??= []).add(order);
    }

    return products.map((product) {
      final productOrders = ordersByProduct[product.id] ?? const [];
      var completedCount = 0;
      var cancelledCount = 0;
      var quantitySold = 0;
      var revenue = 0;
      var hpp = 0;
      for (final order in productOrders) {
        if (order.status == OrderStatus.completed) {
          completedCount++;
          quantitySold += order.quantity;
          revenue += order.unitPriceRupiah * order.quantity;
          hpp += order.hppSnapshotRupiah ?? 0;
        } else if (order.status == OrderStatus.cancelled) {
          cancelledCount++;
        }
      }
      return MenuPerformance(
        productName: product.name,
        isActive: product.isActive,
        completedCount: completedCount,
        cancelledCount: cancelledCount,
        totalQuantitySold: quantitySold,
        totalRevenueRupiah: revenue,
        totalHppRupiah: hpp,
      );
    }).toList()..sort((a, b) => b.totalRevenueRupiah.compareTo(a.totalRevenueRupiah));
  }

  @override
  Future<List<IngredientBottleneck>> cancellationBottlenecks() async {
    final rows = await (_db.select(_db.orderCancellationCauses).join([
      innerJoin(
        _db.ingredients,
        _db.ingredients.id.equalsExp(_db.orderCancellationCauses.ingredientId),
      ),
    ])).get();

    final counts = <String, int>{};
    for (final row in rows) {
      final name = row.readTable(_db.ingredients).name;
      counts[name] = (counts[name] ?? 0) + 1;
    }

    return counts.entries
        .map(
          (entry) => IngredientBottleneck(
            ingredientName: entry.key,
            cancellationCount: entry.value,
          ),
        )
        .toList()
      ..sort((a, b) => b.cancellationCount.compareTo(a.cancellationCount));
  }

  @override
  Future<List<IngredientPricePoint>> ingredientPriceTrend() async {
    final rows = await (_db.select(_db.ingredientPurchases).join([
          innerJoin(
            _db.ingredients,
            _db.ingredients.id.equalsExp(_db.ingredientPurchases.ingredientId),
          ),
        ])
          ..orderBy([OrderingTerm(expression: _db.ingredientPurchases.purchasedAt)]))
        .get();

    return rows.map((row) {
      final purchase = row.readTable(_db.ingredientPurchases);
      final ingredient = row.readTable(_db.ingredients);
      return IngredientPricePoint(
        ingredientName: ingredient.name,
        purchasedAt: purchase.purchasedAt,
        pricePerUnit: purchase.totalPriceRupiah / purchase.quantity,
        storeName: purchase.storeName,
      );
    }).toList();
  }
}
