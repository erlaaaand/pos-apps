import 'package:drift/drift.dart';

/// Snapshot laba-rugi harian (B.5), dibuat sekali saat "Tutup Pesanan Hari
/// Ini" ditekan. Semua total di-snapshot (bukan dihitung ulang saat dibaca)
/// supaya laporan hari lama tidak berubah kalau data belakangan berubah.
@DataClassName('DailyClosing')
class DailyClosings extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get date => dateTime()();

  DateTimeColumn get closedAt => dateTime().withDefault(currentDateAndTime)();

  IntColumn get totalRevenueRupiah => integer()();

  IntColumn get totalHppRupiah => integer()();

  IntColumn get totalOperationalCostRupiah => integer()();

  IntColumn get totalWasteCostRupiah => integer()();

  IntColumn get netProfitRupiah => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {date},
  ];
}
