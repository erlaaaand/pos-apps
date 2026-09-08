import 'package:drift/drift.dart';

import 'production_sessions_table.dart';

/// Biaya resource generik per sesi masak (mis. "Gas"), diinput manual sebagai
/// estimasi kasar. Generik (nama + jumlah) sesuai erp.md, bukan kolom
/// `biaya_gas` khusus, supaya bisa menampung resource lain di masa depan
/// tanpa migrasi skema.
@DataClassName('ProductionSessionCost')
class ProductionSessionCosts extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get sessionId => integer().references(ProductionSessions, #id)();

  TextColumn get name => text()();

  IntColumn get amountRupiah => integer()();
}
