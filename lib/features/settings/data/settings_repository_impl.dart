import 'package:flutter/material.dart';

import '../../../data/local/app_database.dart';
import 'settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<ThemeMode> watchThemeMode() {
    return (_db.select(_db.appSettings)
          ..where((t) => t.key.equals(AppSettingKeys.themeMode)))
        .watchSingleOrNull()
        .map((row) => _decodeThemeMode(row?.value));
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    await _db
        .into(_db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            key: AppSettingKeys.themeMode,
            value: mode.name,
          ),
        );
  }

  /// Nilai yang tidak dikenali diperlakukan sebagai "ikut setelan HP".
  ///
  /// Ini melindungi dari baris rusak hasil pemulihan cadangan lama: pilihan
  /// tema yang tidak terbaca tidak boleh membuat aplikasi gagal dibuka.
  static ThemeMode _decodeThemeMode(String? raw) {
    return switch (raw) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}
