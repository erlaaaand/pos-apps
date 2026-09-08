import 'package:drift/drift.dart';

import '../../../data/local/app_database.dart';
import '../../orders/domain/order_detail.dart';
import '../domain/fifo_selector.dart';
import '../domain/ingredient_shortfall.dart';
import '../domain/production_exceptions.dart';
import '../domain/production_preview.dart';
import '../domain/session_cost_input.dart';
import 'production_repository.dart';

class ProductionRepositoryImpl implements ProductionRepository {
  ProductionRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<ProductionPreview> preview(int purchaseOrderId) async {
    final po = await (_db.select(
      _db.purchaseOrders,
    )..where((t) => t.id.equals(purchaseOrderId))).getSingleOrNull();
    if (po == null || po.status != PoStatus.closed) {
      throw const PurchaseOrderNotClosedException();
    }

    final waitingOrders = await _fetchWaitingOrders(purchaseOrderId);

    final bomCache = <int, List<RecipeItem>>{};
    final needByOrderId = <int, Map<int, double>>{};
    final totalNeeded = <int, double>{};

    for (final detail in waitingOrders) {
      final recipeId = detail.order.recipeId;
      final bom = bomCache[recipeId] ??= await (_db.select(
        _db.recipeItems,
      )..where((t) => t.recipeId.equals(recipeId))).get();

      final need = <int, double>{};
      for (final item in bom) {
        final qty = item.quantityPerBatch * detail.order.quantity;
        need[item.ingredientId] = (need[item.ingredientId] ?? 0) + qty;
        totalNeeded[item.ingredientId] = (totalNeeded[item.ingredientId] ?? 0) + qty;
      }
      needByOrderId[detail.order.id] = need;
    }

    final ingredientIds = totalNeeded.keys.toList();
    final ingredients = ingredientIds.isEmpty
        ? <Ingredient>[]
        : await (_db.select(
            _db.ingredients,
          )..where((t) => t.id.isIn(ingredientIds))).get();
    final ingredientById = {for (final i in ingredients) i.id: i};

    final shortfalls = <IngredientShortfall>[];
    final availableStock = <int, double>{};
    for (final entry in totalNeeded.entries) {
      final ingredient = ingredientById[entry.key]!;
      availableStock[entry.key] = ingredient.currentStock;
      if (entry.value > ingredient.currentStock) {
        shortfalls.add(
          IngredientShortfall(
            ingredientId: ingredient.id,
            ingredientName: ingredient.name,
            unit: ingredient.unit,
            needed: entry.value,
            available: ingredient.currentStock,
          ),
        );
      }
    }

    final allOrderIds = waitingOrders.map((d) => d.order.id).toList();
    final suggested = shortfalls.isEmpty
        ? allOrderIds
        : computeFifoSelection(
            ordersOldestFirst: waitingOrders,
            ingredientNeedByOrderId: needByOrderId,
            availableStockByIngredientId: availableStock,
          );

    return ProductionPreview(
      waitingOrders: waitingOrders,
      shortfalls: shortfalls,
      suggestedOrderIdsToCook: suggested,
    );
  }

  @override
  Future<void> confirmCook({
    required int purchaseOrderId,
    required List<int> orderIdsToCook,
    required List<SessionCostInput> sessionCosts,
  }) async {
    // orderIdsToCook may legitimately be empty — when nothing fits the
    // available stock at all, the owner's only option is to cancel every
    // waiting order. The PO still needs to reach `cooked` so it doesn't
    // get stuck blocking the daily close, and a session row is still
    // recorded for traceability even though it used zero ingredients.
    await _db.transaction(() async {
      final po = await (_db.select(
        _db.purchaseOrders,
      )..where((t) => t.id.equals(purchaseOrderId))).getSingleOrNull();
      if (po == null || po.status != PoStatus.closed) {
        throw const PurchaseOrderNotClosedException();
      }

      final waiting =
          await (_db.select(_db.orders)..where(
                (t) =>
                    t.purchaseOrderId.equals(purchaseOrderId) &
                    t.status.equalsValue(OrderStatus.waiting),
              ))
              .get();

      final orderIdsToCookSet = orderIdsToCook.toSet();
      final cookedOrders = waiting
          .where((order) => orderIdsToCookSet.contains(order.id))
          .toList();
      final remainderOrders = waiting
          .where((order) => !orderIdsToCookSet.contains(order.id))
          .toList();

      final bomCache = <int, List<RecipeItem>>{};
      final ingredientCache = <int, Ingredient>{};
      final totalUsed = <int, double>{};
      final hppByOrderId = <int, int>{};

      for (final order in cookedOrders) {
        final bom = bomCache[order.recipeId] ??= await (_db.select(
          _db.recipeItems,
        )..where((t) => t.recipeId.equals(order.recipeId))).get();

        var orderHpp = 0.0;
        for (final item in bom) {
          final ingredient = ingredientCache[item.ingredientId] ??=
              await (_db.select(
                _db.ingredients,
              )..where((t) => t.id.equals(item.ingredientId))).getSingle();

          final qty = item.quantityPerBatch * order.quantity;
          totalUsed[item.ingredientId] = (totalUsed[item.ingredientId] ?? 0) + qty;
          orderHpp += qty * ingredient.currentCostPerUnit;
        }
        hppByOrderId[order.id] = orderHpp.round();
      }

      // Defensive re-check: stock may have moved since the UI last fetched
      // its preview (e.g. another purchase or session ran meanwhile).
      for (final entry in totalUsed.entries) {
        final ingredient = ingredientCache[entry.key]!;
        if (ingredient.currentStock < entry.value) {
          throw const StockChangedSinceSelectionException();
        }
      }

      // Attribute each excluded order to the ingredient(s) that were short
      // across the *whole* PO (not just the cooked subset), for the
      // bottleneck report in Bagian C.
      final ingredientIdsByRemainderOrder = <int, Set<int>>{};
      final totalNeededAcrossPo = Map<int, double>.from(totalUsed);
      for (final order in remainderOrders) {
        final bom = bomCache[order.recipeId] ??= await (_db.select(
          _db.recipeItems,
        )..where((t) => t.recipeId.equals(order.recipeId))).get();

        final ingredientIds = <int>{};
        for (final item in bom) {
          ingredientCache[item.ingredientId] ??= await (_db.select(
            _db.ingredients,
          )..where((t) => t.id.equals(item.ingredientId))).getSingle();
          ingredientIds.add(item.ingredientId);
          final qty = item.quantityPerBatch * order.quantity;
          totalNeededAcrossPo[item.ingredientId] =
              (totalNeededAcrossPo[item.ingredientId] ?? 0) + qty;
        }
        ingredientIdsByRemainderOrder[order.id] = ingredientIds;
      }
      final shortIngredientIds = totalNeededAcrossPo.entries
          .where((e) => e.value > ingredientCache[e.key]!.currentStock)
          .map((e) => e.key)
          .toSet();

      for (final entry in totalUsed.entries) {
        final ingredient = ingredientCache[entry.key]!;
        await (_db.update(
          _db.ingredients,
        )..where((t) => t.id.equals(entry.key))).write(
          IngredientsCompanion(
            currentStock: Value(ingredient.currentStock - entry.value),
          ),
        );
      }

      final sessionId = await _db
          .into(_db.productionSessions)
          .insert(
            ProductionSessionsCompanion.insert(
              purchaseOrderId: purchaseOrderId,
              confirmedAt: DateTime.now(),
            ),
          );

      for (final entry in totalUsed.entries) {
        await _db
            .into(_db.ingredientUsages)
            .insert(
              IngredientUsagesCompanion.insert(
                sessionId: sessionId,
                ingredientId: entry.key,
                quantityUsed: entry.value,
              ),
            );
      }

      for (final cost in sessionCosts) {
        await _db
            .into(_db.productionSessionCosts)
            .insert(
              ProductionSessionCostsCompanion.insert(
                sessionId: sessionId,
                name: cost.name,
                amountRupiah: cost.amountRupiah,
              ),
            );
      }

      for (final order in cookedOrders) {
        await (_db.update(
          _db.orders,
        )..where((t) => t.id.equals(order.id))).write(
          OrdersCompanion(
            status: const Value(OrderStatus.readyForPickup),
            hppSnapshotRupiah: Value(hppByOrderId[order.id]),
          ),
        );
      }

      for (final order in remainderOrders) {
        await (_db.update(
          _db.orders,
        )..where((t) => t.id.equals(order.id))).write(
          const OrdersCompanion(
            status: Value(OrderStatus.cancelled),
            cancellationReason: Value('Bahan baku tidak cukup'),
          ),
        );

        final causes = ingredientIdsByRemainderOrder[order.id]!.intersection(
          shortIngredientIds,
        );
        for (final ingredientId in causes) {
          await _db
              .into(_db.orderCancellationCauses)
              .insert(
                OrderCancellationCausesCompanion.insert(
                  orderId: order.id,
                  ingredientId: ingredientId,
                ),
              );
        }
      }

      await (_db.update(
        _db.purchaseOrders,
      )..where((t) => t.id.equals(purchaseOrderId))).write(
        PurchaseOrdersCompanion(
          status: const Value(PoStatus.cooked),
          cookedAt: Value(DateTime.now()),
        ),
      );
    });
  }

  Future<List<OrderDetail>> _fetchWaitingOrders(int purchaseOrderId) async {
    final query = _db.select(_db.orders).join([
      innerJoin(
        _db.products,
        _db.products.id.equalsExp(_db.orders.productId),
      ),
    ])
      ..where(
        _db.orders.purchaseOrderId.equals(purchaseOrderId) &
            _db.orders.status.equalsValue(OrderStatus.waiting),
      )
      ..orderBy([OrderingTerm(expression: _db.orders.orderedAt)]);

    final rows = await query.get();
    return rows
        .map(
          (row) => OrderDetail(
            order: row.readTable(_db.orders),
            productName: row.readTable(_db.products).name,
          ),
        )
        .toList();
  }
}
