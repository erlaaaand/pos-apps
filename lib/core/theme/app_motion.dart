import 'package:flutter/animation.dart';

/// Sistem gerak terpusat (upgrade_ui.md §14).
///
/// Animasi di aplikasi ini harus cepat, halus, dan bisa ditebak — bukan
/// pertunjukan. Durasi dipilih agar transisi tetap terasa responsif di HP
/// kelas menengah.
abstract final class AppMotion {
  /// Interaksi mikro: tekan tombol, ripple, perubahan warna chip.
  static const Duration fast = Duration(milliseconds: 140);

  /// Perubahan state komponen: chip terpilih, accordion, loading tombol.
  static const Duration normal = Duration(milliseconds: 220);

  /// Transisi navigasi dan modal.
  static const Duration slow = Duration(milliseconds: 300);

  /// Kurva masuk standar — cepat di awal, melambat di akhir.
  static const Curve standard = Curves.easeOutCubic;

  /// Kurva untuk perubahan yang bisa dibalik (buka/tutup).
  static const Curve reversible = Curves.easeInOut;

  /// Kurva keluar — dipakai saat elemen menghilang.
  static const Curve exit = Curves.easeInCubic;
}
