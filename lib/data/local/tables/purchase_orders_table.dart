import 'package:drift/drift.dart';

/// Status siklus PO (B.1): Draft → Buka → Tutup → Selesai Masak.
///
/// This enum is stored as its integer index ([intEnum]) — never reorder or
/// remove a value, only append, or existing rows will silently point at the
/// wrong status.
enum PoStatus { draft, open, closed, cooked }

/// PO batch (B.1). erp.md explicitly allows the number/label of daily slots
/// to vary ("bisa ditambah/dikurangi kalau kebutuhan hari itu beda"), so
/// [label] is free text rather than a fixed Pagi/Siang/Sore/Malam enum.
@DataClassName('PurchaseOrderBatch')
class PurchaseOrders extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get label => text()();

  IntColumn get status =>
      intEnum<PoStatus>().withDefault(const Constant(0))();

  DateTimeColumn get openedAt => dateTime().nullable()();

  DateTimeColumn get closedAt => dateTime().nullable()();

  DateTimeColumn get cookedAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
