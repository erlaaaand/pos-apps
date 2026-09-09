import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/database_provider.dart';
import '../data/settings_repository.dart';
import '../data/settings_repository_impl.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(ref.watch(appDatabaseProvider));
});

/// Mode tema yang sedang berlaku.
///
/// Nilai awalnya [ThemeMode.system] supaya aplikasi bisa menggambar frame
/// pertama tanpa menunggu pembacaan database — mengikuti setelan HP adalah
/// tebakan paling aman, dan pilihan tersimpan menyusul begitu terbaca.
final themeModeProvider = StreamProvider<ThemeMode>((ref) {
  return ref.watch(settingsRepositoryProvider).watchThemeMode();
});
