import '../../../data/local/app_database.dart';

/// Abstraction over Bagian D: backup (.db raw copy / .sql dump) and restore.
abstract interface class BackupRepository {
  Stream<List<BackupLog>> watchHistory();

  /// Raw SQLite copy via `VACUUM INTO` — the primary format, safe to
  /// restore directly with no parsing.
  Future<BackupLog> backupAsDb({required BackupTrigger trigger});

  /// Optional schema+data SQL dump, for manual reading or migrating to
  /// another database system later.
  Future<BackupLog> backupAsSql({required BackupTrigger trigger});

  Future<void> shareBackup(BackupLog log);

  /// Restores from [filePath] (`.db`/`.sqlite` or `.sql`), OVERWRITING all
  /// current data. The caller must already have confirmed this with the
  /// user — this method does not ask again. Closes the current database
  /// connection as part of restoring; the caller is responsible for
  /// invalidating/recreating it afterward (and should tell the user to
  /// restart the app, since not every open screen is guaranteed to notice
  /// the swap).
  Future<void> restoreFromFile(String filePath);
}
