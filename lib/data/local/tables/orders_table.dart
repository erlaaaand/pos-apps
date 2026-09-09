import 'package:drift/drift.dart';

import 'products_table.dart';
import 'purchase_orders_table.dart';
import 'recipes_table.dart';

/// Status pesanan (B.2–B.5). `waiting` = masuk, menunggu PO ditutup &
/// diproduksi; `readyForPickup` = sudah dimasak (B.3); `completed` = sudah
/// diambil & dibayar (B.4); `cancelled` = dibatalkan (bahan kurang / manual,
/// lihat [Orders.cancellationReason]); `wasted` = sudah dimasak tapi tidak
/// diambil sampai tutup hari (B.5), dicatat sebagai kerugian material.
///
/// Stored as [intEnum] — append-only, never reorder/remove values.
enum OrderStatus { waiting, readyForPickup, completed, cancelled, wasted }

/// Pesanan masuk dari WhatsApp (B.2), ditautkan ke satu PO yang sedang Buka.
@DataClassName('CustomerOrder')
class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get purchaseOrderId => integer().references(PurchaseOrders, #id)();

  IntColumn get productId => integer().references(Products, #id)();

  /// The exact recipe version active when this order was placed — fixes the
  /// BOM used for realized-ingredient calculation regardless of later recipe
  /// changes.
  IntColumn get recipeId => integer().references(Recipes, #id)();

  IntColumn get quantity => integer()();

  TextColumn get buyerContact => text().nullable()();

  TextColumn get note => text().nullable()();

  /// Snapshot of the recipe's selling price at order time, in whole Rupiah —
  /// so a later recipe price change never retroactively edits this order.
  IntColumn get unitPriceRupiah => integer()();

  IntColumn get status =>
      intEnum<OrderStatus>().withDefault(const Constant(0))();

  TextColumn get cancellationReason => text().nullable()();

  /// HPP for this order, snapshotted at production-confirmation time (B.3),
  /// using ingredient costs as of that moment — never recomputed later, so
  /// past P&L reports stay stable when ingredient costs move.
  IntColumn get hppSnapshotRupiah => integer().nullable()();

  /// Needed for FIFO ordering when a PO must be partially cooked (B.3).
  DateTimeColumn get orderedAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get completedAt => dateTime().nullable()();
}
