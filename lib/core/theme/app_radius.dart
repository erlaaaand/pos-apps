import 'package:flutter/widgets.dart';

/// Semantic corner-radius scale, mengikuti referensi: 8 / 12 / 16 / 20 / 24
/// dan pill. Jangan memakai radius acak di luar skala ini.
abstract final class AppRadius {
  /// Isian form, chip kecil, ikon kotak.
  static const double sm = 8;

  /// Kartu kompak dan tombol.
  static const double card = 12;

  /// Alias eksplisit untuk [card] — dipakai saat konteksnya bukan kartu.
  static const double md = 12;

  /// Kartu utama dan sheet.
  static const double lg = 16;

  /// Kartu hero dan kontainer besar.
  static const double xl = 20;

  /// Sudut atas bottom sheet.
  static const double xxl = 24;

  /// Bentuk pill penuh (badge, chip terpilih, indikator nav aktif).
  static const double pill = 999;

  static const BorderRadius smRadius = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius cardRadius = BorderRadius.all(
    Radius.circular(card),
  );
  static const BorderRadius lgRadius = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlRadius = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius pillRadius = BorderRadius.all(
    Radius.circular(pill),
  );

  /// Sudut atas untuk modal bottom sheet.
  static const BorderRadius sheetRadius = BorderRadius.vertical(
    top: Radius.circular(xxl),
  );
}
