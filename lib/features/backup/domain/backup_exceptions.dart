import '../../../core/error/app_exception.dart';

class InvalidBackupFileException implements AppException {
  const InvalidBackupFileException();

  @override
  String get message =>
      'File tidak valid. Pilih file backup dengan ekstensi .db atau .sql.';

  @override
  String toString() => message;
}

class BackupFailedException implements AppException {
  const BackupFailedException(this.detail);

  final String detail;

  @override
  String get message => 'Backup gagal: $detail';

  @override
  String toString() => message;
}

class RestoreFailedException implements AppException {
  const RestoreFailedException(this.detail);

  final String detail;

  @override
  String get message => 'Restore gagal: $detail';

  @override
  String toString() => message;
}
