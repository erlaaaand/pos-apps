import 'package:drift/drift.dart';

import 'purchase_orders_table.dart';

/// Satu sesi masak = satu PO yang sudah Tutup dan dikonfirmasi "Selesai
/// Masak" (B.3). Resource cost (gas, dll) dicatat generik lewat
/// [ProductionSessionCosts], bukan kolom khusus, sesuai keputusan skema di
/// erp.md ("Ruang Lingkup").
@DataClassName('ProductionSession')
class ProductionSessions extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get purchaseOrderId =>
      integer().references(PurchaseOrders, #id)();

  DateTimeColumn get confirmedAt => dateTime()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {purchaseOrderId},
  ];
}
