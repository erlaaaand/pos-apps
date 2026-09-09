/// Semantic spacing scale (logical pixels), mengikuti ritme
/// `lib/reference_theme/design.html`: 4 / 8 / 12 / 16 / 20 / 24 / 32 / 40.
///
/// Prefer token daripada angka mentah supaya jarak antar layar konsisten.
abstract final class AppSpacing {
  /// Jarak rapat antar elemen yang saling menempel (label ke nilainya).
  static const double xs = 4;

  /// Jarak antar elemen di dalam satu baris/kartu.
  static const double sm = 8;

  /// Padding dalam kartu kompak dan jarak antar kartu di grid.
  static const double compact = 12;

  /// Padding tepi layar dan padding kartu standar.
  static const double md = 16;

  /// Jarak antar seksi di dalam satu halaman.
  static const double section = 20;

  /// Jarak besar antar blok konten.
  static const double lg = 24;

  static const double xl = 32;

  static const double xxl = 40;
}
