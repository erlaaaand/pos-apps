import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

/// Single shared [AppDatabase] instance for the app's lifetime. Every
/// feature repository depends on this instead of constructing its own
/// connection.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});
