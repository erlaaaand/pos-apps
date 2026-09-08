import 'package:drift/drift.dart';

import 'ingredients_table.dart';
import 'orders_table.dart';

/// Which ingredient(s) were short when an order got auto-cancelled for
/// "bahan baku tidak cukup" during production (B.3) — feeds the bottleneck
/// report in Bagian C ("bahan apa yang paling sering bikin pesanan
/// dibatalkan"). Not populated for manual pre-production cancellations
/// (those have an arbitrary free-text reason, not tied to a specific
/// ingredient).
@DataClassName('OrderCancellationCause')
class OrderCancellationCauses extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get orderId => integer().references(Orders, #id)();

  IntColumn get ingredientId => integer().references(Ingredients, #id)();
}
