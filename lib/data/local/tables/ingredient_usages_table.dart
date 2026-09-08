import 'package:drift/drift.dart';

import 'ingredients_table.dart';
import 'production_sessions_table.dart';

/// Realisasi pemakaian bahan per sesi masak (B.3) — total aktual yang
/// terpotong dari stok, dari pesanan yang benar-benar jadi dimasak. Ini bisa
/// lebih kecil dari kebutuhan rencana PO kalau sesi tersebut dimasak
/// sebagian (bahan kurang).
@DataClassName('IngredientUsage')
class IngredientUsages extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get sessionId => integer().references(ProductionSessions, #id)();

  IntColumn get ingredientId => integer().references(Ingredients, #id)();

  /// Realized quantity consumed, in the ingredient's unit.
  RealColumn get quantityUsed => real()();
}
