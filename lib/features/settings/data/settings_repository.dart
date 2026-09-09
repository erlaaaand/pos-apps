import 'package:flutter/material.dart';

/// Kunci setelan yang dipakai aplikasi.
///
/// Dikumpulkan sebagai konstanta supaya tidak ada layar yang mengetik ulang
/// string kuncinya dan diam-diam menulis ke baris yang salah.
abstract final class AppSettingKeys {
  static const String themeMode = 'theme_mode';
}

/// Akses ke preferensi tampilan yang tersimpan.
abstract interface class SettingsRepository {
  /// Mode tema tersimpan. `ThemeMode.system` kalau pengguna belum memilih.
  Stream<ThemeMode> watchThemeMode();

  /// Menyimpan pilihan mode tema pengguna.
  Future<void> setThemeMode(ThemeMode mode);
}
