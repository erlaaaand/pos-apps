import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Identitas aplikasi, diambil dari `lib/base_project/logo.html`.
///
/// Nama, tagline, dan warna resmi dikumpulkan di satu tempat supaya tidak ada
/// layar yang menuliskan ulang string brand sendiri-sendiri.
abstract final class AppBrand {
  /// Nama yang tampil ke pengguna (launcher, app bar, judul task).
  static const String name = 'Dapur Kelaris';

  /// Bentuk kapital untuk baris brand kecil di header.
  static const String nameUpper = 'DAPUR KELARIS';

  /// Kategori produk pada lockup utama.
  static const String tagline = 'Sistem Operasional Kuliner';

  /// Ruang lingkup fungsional dari lockup brand.
  static const String scope =
      'Kendali Stok • Kalkulasi HPP & Resep • Arus Kas Bisnis';

  /// Warna wadah ikon (squircle).
  static const Color mark = AppColors.primary;

  /// Warna glyph di dalam wadah.
  static const Color glyph = AppColors.background;

  /// Radius optis ikon = 24% sisi, sesuai spesifikasi produksi di logo.html.
  static const double iconRadiusRatio = 52 / 216;
}

/// Lambang Dapur Kelaris: wadah squircle dengan monogram "D" geometris —
/// pilar vertikal, dua kompartemen rak, dan titik fokal BEP di tengah.
///
/// Digambar sebagai vektor, bukan aset gambar, supaya tajam di segala ukuran
/// dan bisa dipakai ulang oleh generator ikon peluncur.
class AppLogo extends StatelessWidget {
  const AppLogo({
    required this.size,
    this.containerColor = AppBrand.mark,
    this.glyphColor = AppBrand.glyph,
    this.showContainer = true,
    super.key,
  });

  final double size;
  final Color containerColor;
  final Color glyphColor;

  /// Saat false, hanya glyph yang digambar (untuk foreground adaptive icon
  /// atau penempatan di atas latar berwarna).
  final bool showContainer;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppBrand.name,
      child: SizedBox.square(
        dimension: size,
        child: CustomPaint(
          painter: AppLogoPainter(
            containerColor: containerColor,
            glyphColor: glyphColor,
            showContainer: showContainer,
          ),
        ),
      ),
    );
  }
}

/// Menggambar lambang persis seperti geometri di logo.html.
///
/// Seluruh koordinat ditulis dalam ruang desain 216×216 milik master app icon,
/// lalu diskalakan — jadi proporsinya identik di ukuran apa pun.
class AppLogoPainter extends CustomPainter {
  const AppLogoPainter({
    this.containerColor = AppBrand.mark,
    this.glyphColor = AppBrand.glyph,
    this.showContainer = true,
    this.glyphScale = 1,
  });

  final Color containerColor;
  final Color glyphColor;
  final bool showContainer;

  /// Pengali tambahan untuk glyph, dipakai adaptive icon agar lambang masuk
  /// ke dalam safe zone Android.
  final double glyphScale;

  /// Sisi ruang desain master icon.
  static const double _canvas = 216;

  /// Offset glyph di dalam wadah (translate(33, 33) pada SVG).
  static const double _glyphOffset = 33;

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / _canvas;

    if (showContainer) {
      final radius = size.width * AppBrand.iconRadiusRatio;
      canvas.drawRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
        Paint()..color = containerColor,
      );
    }

    canvas.save();
    if (glyphScale != 1) {
      // Perkecil di sekitar titik tengah supaya lambang tetap di poros.
      canvas.translate(size.width / 2, size.height / 2);
      canvas.scale(glyphScale);
      canvas.translate(-size.width / 2, -size.height / 2);
    }
    canvas.translate(_glyphOffset * unit, _glyphOffset * unit);
    canvas.scale(unit);

    final glyphPaint = Paint()..color = glyphColor;

    // Pilar vertikal — kontrol & fondasi operasional.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(36, 34, 18, 82),
        const Radius.circular(9),
      ),
      glyphPaint,
    );

    // Kompartemen atas — penyimpanan bahan baku.
    final top = Path()
      ..moveTo(64, 34)
      ..lineTo(92, 34)
      ..cubicTo(108.5, 34, 116, 42.5, 116, 57)
      ..cubicTo(116, 64.5, 111.5, 70, 102, 71.5)
      ..lineTo(64, 71.5)
      ..close();
    canvas.drawPath(top, glyphPaint);

    // Kompartemen bawah — produksi & keluaran.
    final bottom = Path()
      ..moveTo(64, 78.5)
      ..lineTo(102, 78.5)
      ..cubicTo(111.5, 80, 116, 85.5, 116, 93)
      ..cubicTo(116, 107.5, 108.5, 116, 92, 116)
      ..lineTo(64, 116)
      ..close();
    canvas.drawPath(bottom, glyphPaint);

    // Titik fokal (BEP/HPP) — dilubangi dengan warna wadah.
    canvas.drawCircle(
      const Offset(85, 75),
      4.5,
      Paint()..color = showContainer ? containerColor : AppBrand.mark,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(AppLogoPainter oldDelegate) {
    return oldDelegate.containerColor != containerColor ||
        oldDelegate.glyphColor != glyphColor ||
        oldDelegate.showContainer != showContainer ||
        oldDelegate.glyphScale != glyphScale;
  }
}
