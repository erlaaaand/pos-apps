import 'package:dapur_kelaris/data/local/app_database.dart';
import 'package:dapur_kelaris/features/ingredients/data/ingredient_repository_impl.dart';
import 'package:dapur_kelaris/features/orders/data/order_repository_impl.dart';
import 'package:dapur_kelaris/features/production/data/production_repository_impl.dart';
import 'package:dapur_kelaris/features/production/domain/production_exceptions.dart';
import 'package:dapur_kelaris/features/production/domain/session_cost_input.dart';
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

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    ingredients = IngredientRepositoryImpl(db);
    recipes = RecipeRepositoryImpl(db);
    purchaseOrders = PurchaseOrderRepositoryImpl(db);
    orders = OrderRepositoryImpl(db);
    production = ProductionRepositoryImpl(db);
  });

  tearDown(() => db.close());

  /// Seeds a "Durian" ingredient at 500/gram, a product needing 10g/batch
  /// (so each order unit costs 5000 HPP), a stocked amount of durian, an
  /// open+closed PO, and one order of the given [quantity].
  Future<({int productId, int poId, int orderId, int ingredientId})>
  seedOneOrder({required double stockGrams, required int quantity}) async {
    final durianId = await ingredients.create(
      name: 'Durian',
      unit: IngredientUnit.gram,
    );
    await ingredients.recordPurchase(
      ingredientId: durianId,
      quantity: stockGrams,
      totalPriceRupiah: (stockGrams * 500).round(),
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

    final orderId = await orders.create(
      purchaseOrderId: poId,
      productId: productId,
      quantity: quantity,
    );

    await purchaseOrders.close(poId);

    return (
      productId: productId,
      poId: poId,
      orderId: orderId,
      ingredientId: durianId,
    );
  }

  group('preview', () {
    test('reports sufficient when stock covers all waiting orders', () async {
      final seed = await seedOneOrder(stockGrams: 100, quantity: 2);

      final preview = await production.preview(seed.poId);

      expect(preview.isSufficient, isTrue);
      expect(preview.shortfalls, isEmpty);
      expect(preview.suggestedOrderIdsToCook, [seed.orderId]);
    });

    test('reports a shortfall when stock is not enough', () async {
      // needs 2 * 10g = 20g, only 5g in stock.
      final seed = await seedOneOrder(stockGrams: 5, quantity: 2);

      final preview = await production.preview(seed.poId);

      expect(preview.isSufficient, isFalse);
      expect(preview.shortfalls, hasLength(1));
      expect(preview.shortfalls.single.ingredientId, seed.ingredientId);
      expect(preview.shortfalls.single.needed, 20);
      expect(preview.shortfalls.single.available, 5);
    });

    test('throws when the PO is not closed', () async {
      final durianId = await ingredients.create(
        name: 'Durian',
        unit: IngredientUnit.gram,
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

      expect(
        () => production.preview(poId),
        throwsA(isA<PurchaseOrderNotClosedException>()),
      );
    });
  });

  group('confirmCook', () {
    test(
      'cooks the order, deducts realized stock, and snapshots HPP',
      () async {
        final seed = await seedOneOrder(stockGrams: 100, quantity: 2);

        await production.confirmCook(
          purchaseOrderId: seed.poId,
          orderIdsToCook: [seed.orderId],
          sessionCosts: const [],
        );

        final order = await orders.getById(seed.orderId);
        expect(order!.status, OrderStatus.readyForPickup);
        // 2 batches * 10g * Rp500/g = Rp10.000
        expect(order.hppSnapshotRupiah, 10000);

        final ingredient = await ingredients.getById(seed.ingredientId);
        expect(ingredient!.currentStock, 80); // 100 - 20g used
        expect(ingredient.currentCostPerUnit, 500); // unaffected by usage

        final po = await purchaseOrders.getById(seed.poId);
        expect(po!.status, PoStatus.cooked);
      },
    );

    test(
      'cancels orders excluded from the selection as bahan baku tidak cukup',
      () async {
        final seed = await seedOneOrder(stockGrams: 5, quantity: 2);

        await production.confirmCook(
          purchaseOrderId: seed.poId,
          orderIdsToCook: const [], // simulate: nothing fits, all cancelled
          sessionCosts: const [],
        );

        final order = await orders.getById(seed.orderId);
        expect(order!.status, OrderStatus.cancelled);
        expect(order.cancellationReason, 'Bahan baku tidak cukup');

        final ingredient = await ingredients.getById(seed.ingredientId);
        expect(ingredient!.currentStock, 5); // untouched
      },
    );

    test('records the session resource cost', () async {
      final seed = await seedOneOrder(stockGrams: 100, quantity: 1);

      await production.confirmCook(
        purchaseOrderId: seed.poId,
        orderIdsToCook: [seed.orderId],
        sessionCosts: const [
          SessionCostInput(name: 'Gas', amountRupiah: 12000),
        ],
      );

      final session = await (db.select(
        db.productionSessions,
      )..where((t) => t.purchaseOrderId.equals(seed.poId))).getSingle();
      final costs = await (db.select(
        db.productionSessionCosts,
      )..where((t) => t.sessionId.equals(session.id))).get();

      expect(costs, hasLength(1));
      expect(costs.single.name, 'Gas');
      expect(costs.single.amountRupiah, 12000);
    });
  });
}
