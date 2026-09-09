import 'package:drift/drift.dart';

/// Jenis catatan modal (new_flow.md E.1).
///
/// Disimpan sebagai indeks integer ([intEnum]) — hanya boleh ditambah di
/// akhir, jangan diurut ulang atau dihapus.
enum CapitalEntryKind {
  /// Modal awal saat usaha dimulai.
  initial,

  /// Suntikan modal tambahan setelah usaha berjalan.
  injection,

  /// Pembelian alat/perlengkapan yang diambil dari modal — mengurangi
  /// Modal Kerja Tersedia.
  equipment,
}

/// Catatan modal & investasi alat (E.1).
///
/// Modal Kerja Tersedia = Σ(initial + injection) − Σ(equipment). Dibuat
/// sebagai daftar entri, bukan satu baris "modal awal" yang di-update,
/// supaya riwayat suntikan modal tetap bisa ditelusuri — sejalan dengan
/// prinsip erp.md #6 (setiap entitas bisa ditelusuri).
@DataClassName('CapitalEntry')
class CapitalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get kind => intEnum<CapitalEntryKind>()();

  IntColumn get amountRupiah => integer()();

  TextColumn get note => text().nullable()();

  DateTimeColumn get recordedAt => dateTime()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
