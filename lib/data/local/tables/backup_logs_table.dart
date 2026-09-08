import 'package:drift/drift.dart';

/// Format backup (D): `.db` = salinan mentah SQLite (utama, untuk restore
/// penuh), `.sql` = dump perintah SQL (opsional, untuk migrasi/dibaca
/// manual). Stored as [intEnum] — append-only.
enum BackupFormat { db, sql }

/// Pemicu backup (D): manual via tombol, atau otomatis saat "Tutup Pesanan
/// Hari Ini" ditekan.
enum BackupTrigger { manual, autoOnDailyClose }

/// Riwayat backup yang pernah dibuat (D), untuk ditampilkan ke pemilik agar
/// tahu backup terakhir kapan/di mana.
@DataClassName('BackupLog')
class BackupLogs extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get filePath => text()();

  IntColumn get format => intEnum<BackupFormat>()();

  IntColumn get trigger => intEnum<BackupTrigger>()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
