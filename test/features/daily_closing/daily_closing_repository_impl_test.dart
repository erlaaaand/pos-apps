import 'package:dapur_kelaris/data/local/app_database.dart';
import 'package:dapur_kelaris/features/backup/data/backup_repository_impl.dart';
import 'package:dapur_kelaris/features/daily_closing/data/daily_closing_repository_impl.dart';
import 'package:dapur_kelaris/features/daily_closing/domain/daily_closing_exceptions.dart';
import 'package:dapur_kelaris/features/ingredients/data/ingredient_repository_impl.dart';
import 'package:dapur_kelaris/features/orders/data/order_repository_impl.dart';
import 'package:dapur_kelaris/features/production/data/production_repository_impl.dart';
import 'package:dapur_kelaris/features/products/data/recipe_repository_impl.dart';
import 'package:dapur_kelaris/features/products/domain/recipe_item_input.dart';
import 'package:dapur_kelaris/features/purchase_orders/data/purchase_order_repository_impl.dart';
import 'package:dapur_kelaris/features/purchase_orders/domain/po_quota_input.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late IngredientRepositoryImpl ingredients;
  late RecipeRepositoryImpl recipes;
  late PurchaseOrderRepositoryImpl purchaseOrders;
  late OrderRepositoryImpl orders;
  late ProductionRepositoryImpl production;
  late DailyClosingRepositoryImpl closing;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    ingredients = IngredientRepositoryImpl(db);
    recipes = RecipeRepositoryImpl(db);
    purchaseOrders = PurchaseOrderRepositoryImpl(db);
    orders = OrderRepositoryImpl(db);
    production = ProductionRepositoryImpl(db);
    closing = DailyClosingRepositoryImpl(db, BackupRepositoryImpl(db));
  });

  tearDown(() => db.close());

  /// Produces two `readyForPickup` orders (Rp15.000 each, HPP Rp5.000 each
  /// since the batch needs 10g of a Rp500/g ingredient): the caller
  /// completes however many of them it wants picked up, leaving the rest to
  /// become waste at closing.
  Future<List<int>> seedTwoReadyOrders() async {
    final durianId = await ingredients.create(
      name: 'Durian',
      unit: IngredientUnit.gram,
    );
    await ingredients.recordPurchase(
      ingredientId: durianId,
      quantity: 100,
      totalPriceRupiah: 50000,
      purchasedAt: DateTime(2026, 1, 1),
    );
    final productId = await recipes.createProduct(
      name: 'Es Teler Durian',
      sellingPriceRupiah: 15000,
      items: [RecipeItemInput(ingredientId: durianId, quantityPerBatch: 10)],
    );
    final poId = await purchaseOrders.create(
      label: 'Pagi',
      quotas: [PoQuotaInput(productId: productId, quotaQuantity: 20)],
    );
    await purchaseOrders.open(poId);

    final orderId1 = await orders.create(
      purchaseOrderId: poId,
      productId: productId,
      quantity: 1,
    );
    final orderId2 = await orders.create(
      purchaseOrderId: poId,
      productId: productId,
      quantity: 1,
    );

    await purchaseOrders.close(poId);
    await production.confirmCook(
      purchaseOrderId: poId,
      orderIdsToCook: [orderId1, orderId2],
      sessionCosts: const [],
    );

    return [orderId1, orderId2];
  }

  test('previewToday counts completed orders as revenue/HPP and pending readyForPickup as projected waste', () async {
    final orderIds = await seedTwoReadyOrders();
    await orders.complete(orderIds.first);

    final summary = await closing.previewToday();

    expect(summary.revenueRupiah, 15000);
    expect(summary.hppRupiah, 5000);
    expect(summary.projectedWasteCostRupiah, 5000);
    expect(summary.ordersPendingPickupCount, 1);
    expect(summary.netProfitRupiah, 15000 - 5000 - 0 - 5000);
  });

  test('closeToday marks lingering readyForPickup orders as wasted and snapshots totals', () async {
    final orderIds = await seedTwoReadyOrders();
    await orders.complete(orderIds.first);
    await closing.addOperationalCost(name: 'Minyak motor', amountRupiah: 12000);

    final result = await closing.closeToday();

    expect(result.totalRevenueRupiah, 15000);
    expect(result.totalHppRupiah, 5000);
    expect(result.totalOperationalCostRupiah, 12000);
    expect(result.totalWasteCostRupiah, 5000);
    expect(result.netProfitRupiah, 15000 - 5000 - 12000 - 5000);

    final wastedOrder = await orders.getById(orderIds.last);
    expect(wastedOrder!.status, OrderStatus.wasted);
  });

  test('closeToday throws when already closed today', () async {
    await closing.closeToday();

    expect(
      () => closing.closeToday(),
      throwsA(isA<DayAlreadyClosedException>()),
    );
  });
}
