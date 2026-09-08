import 'dart:io';

import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../../data/local/app_database.dart';
import '../domain/backup_exceptions.dart';
import 'backup_repository.dart';

class BackupRepositoryImpl implements BackupRepository {
  BackupRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<BackupLog>> watchHistory() {
    return (_db.select(_db.backupLogs)..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  @override
  Future<BackupLog> backupAsDb({required BackupTrigger trigger}) async {
    final destPath = await _newBackupPath('db');
    try {
      await _db.customStatement('VACUUM INTO ?', [destPath]);
    } catch (error) {
      throw BackupFailedException(error.toString());
    }
    return _logBackup(
      filePath: destPath,
      format: BackupFormat.db,
      trigger: trigger,
    );
  }

  @override
  Future<BackupLog> backupAsSql({required BackupTrigger trigger}) async {
    final destPath = await _newBackupPath('sql');
    try {
      final dump = await _dumpAsSql();
      await File(destPath).writeAsString(dump);
    } catch (error) {
      throw BackupFailedException(error.toString());
    }
    return _logBackup(
      filePath: destPath,
      format: BackupFormat.sql,
      trigger: trigger,
    );
  }

  Future<String> _dumpAsSql() async {
    final buffer = StringBuffer();
    final tables = await _db
        .customSelect(
          "SELECT name, sql FROM sqlite_master "
          "WHERE type = 'table' AND name NOT LIKE 'sqlite_%'",
        )
        .get();

    for (final table in tables) {
      final createStatement = table.data['sql'] as String?;
      if (createStatement != null) buffer.writeln('$createStatement;');
    }

    for (final table in tables) {
      final tableName = table.data['name'] as String;
      final rows = await _db.customSelect('SELECT * FROM "$tableName"').get();
      for (final row in rows) {
        final columns = row.data.keys.join(', ');
        final values = row.data.values.map(_sqlLiteral).join(', ');
        buffer.writeln(
          'INSERT INTO "$tableName" ($columns) VALUES ($values);',
        );
      }
    }
    return buffer.toString();
  }

  String _sqlLiteral(Object? value) {
    return switch (value) {
      null => 'NULL',
      num value => value.toString(),
      bool value => value ? '1' : '0',
      _ => "'${value.toString().replaceAll("'", "''")}'",
    };
  }

  @override
  Future<void> shareBackup(BackupLog log) async {
    await SharePlus.instance.share(ShareParams(files: [XFile(log.filePath)]));
  }

  @override
  Future<void> restoreFromFile(String filePath) async {
    final sourceFile = File(filePath);
    if (!await sourceFile.exists()) {
      throw const InvalidBackupFileException();
    }
    final extension = p.extension(filePath).toLowerCase();
    if (extension != '.db' && extension != '.sqlite' && extension != '.sql') {
      throw const InvalidBackupFileException();
    }

    await _db.close();
    final targetFile = await resolveDatabaseFile();

    try {
      if (extension == '.sql') {
        await _restoreFromSqlDump(sourceFile, targetFile);
      } else {
        await _restoreFromDbCopy(sourceFile, targetFile);
      }
    } catch (error) {
      throw RestoreFailedException(error.toString());
    }
  }

  Future<void> _restoreFromDbCopy(File sourceFile, File targetFile) async {
    await sourceFile.copy(targetFile.path);
    // Stale -wal/-shm sidecars from the OLD database would otherwise be
    // replayed on top of the freshly-restored main file.
    for (final suffix in ['-wal', '-shm']) {
      final sidecar = File('${targetFile.path}$suffix');
      if (await sidecar.exists()) await sidecar.delete();
    }
  }

  Future<void> _restoreFromSqlDump(File sourceFile, File targetFile) async {
    if (await targetFile.exists()) await targetFile.delete();
    for (final suffix in ['-wal', '-shm']) {
      final sidecar = File('${targetFile.path}$suffix');
      if (await sidecar.exists()) await sidecar.delete();
    }

    final rawDb = sqlite3.open(targetFile.path);
    try {
      rawDb.execute(await sourceFile.readAsString());
    } finally {
      rawDb.close();
    }
  }

  Future<String> _newBackupPath(String extension) async {
    final directory = await _backupDirectory();
    final stamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    return p.join(directory.path, 'backup_$stamp.$extension');
  }

  Future<Directory> _backupDirectory() async {
    final documents = await getApplicationDocumentsDirectory();
    final directory = Directory(p.join(documents.path, 'backups'));
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  Future<BackupLog> _logBackup({
    required String filePath,
    required BackupFormat format,
    required BackupTrigger trigger,
  }) async {
    final id = await _db
        .into(_db.backupLogs)
        .insert(
          BackupLogsCompanion.insert(
            filePath: filePath,
            format: format,
            trigger: trigger,
          ),
        );
    return (_db.select(
      _db.backupLogs,
    )..where((t) => t.id.equals(id))).getSingle();
  }
}
