import 'package:drift/drift.dart';

import 'products_table.dart';
import 'purchase_orders_table.dart';

/// Kuota per produk dalam satu PO (B.1), mis. "Es Teler 15 porsi".
@DataClassName('PoProductQuota')
class PoProductQuotas extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get purchaseOrderId =>
      integer().references(PurchaseOrders, #id)();

  IntColumn get productId => integer().references(Products, #id)();

  IntColumn get quotaQuantity => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {purchaseOrderId, productId},
  ];
}
