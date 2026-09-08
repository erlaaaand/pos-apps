import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/app_database.dart';
import '../../../data/local/database_provider.dart';
import '../data/backup_repository.dart';
import '../data/backup_repository_impl.dart';

final backupRepositoryProvider = Provider<BackupRepository>((ref) {
  return BackupRepositoryImpl(ref.watch(appDatabaseProvider));
});

final backupHistoryProvider = StreamProvider<List<BackupLog>>((ref) {
  return ref.watch(backupRepositoryProvider).watchHistory();
});
