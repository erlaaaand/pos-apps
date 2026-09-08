import 'package:drift/drift.dart';

/// Biaya operasional harian generik (B.5) — `(nama_biaya, jumlah, tanggal)`,
/// mis. minyak motor, tenaga kerja. Generik sesuai keputusan skema di
/// erp.md, bukan kolom tetap per jenis biaya.
@DataClassName('DailyOperationalCost')
class DailyOperationalCosts extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get amountRupiah => integer()();

  DateTimeColumn get date => dateTime()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
