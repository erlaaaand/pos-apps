import 'dart:io';
import 'dart:ui' as ui;

import 'package:dapur_kelaris/core/branding/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Membuat ikon peluncur Android dari lambang di [AppLogoPainter].
///
/// Dijalankan manual, bukan bagian dari suite pengujian:
///
/// ```
/// flutter test tool/generate_app_icons.dart
/// ```
///
/// Ikon digambar ulang dari vektor yang sama dengan yang dipakai di dalam
/// aplikasi, jadi lambang di app bar dan di home screen HP tidak akan pernah
/// berbeda. Tidak butuh ImageMagick/Inkscape — perenderan memakai mesin
/// Flutter sendiri.
void main() {
  const resDir = 'android/app/src/main/res';

  /// Ukuran ikon peluncur klasik per densitas (px).
  const legacySizes = <String, int>{
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
  };

  /// Kanvas foreground adaptive icon = 108dp per densitas (px).
  const adaptiveSizes = <String, int>{
    'mipmap-mdpi': 108,
    'mipmap-hdpi': 162,
    'mipmap-xhdpi': 216,
    'mipmap-xxhdpi': 324,
    'mipmap-xxxhdpi': 432,
  };

  /// Lambang mengisi ~69% wadah. Android hanya menjamin 66dp dari 108dp yang
  /// terlihat, jadi foreground dikecilkan agar aman dari pemotongan mask.
  const adaptiveGlyphScale = 0.85;

  Future<void> writePng(
    String path,
    int size, {
    required bool withContainer,
    double glyphScale = 1,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    AppLogoPainter(
      showContainer: withContainer,
      glyphScale: glyphScale,
    ).paint(canvas, Size(size.toDouble(), size.toDouble()));

    final image = await recorder.endRecording().toImage(size, size);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();

    final file = File(path);
    file.parent.createSync(recursive: true);
    file.writeAsBytesSync(data!.buffer.asUint8List());
  }

  testWidgets('generate Android launcher icons', (tester) async {
    await tester.runAsync(() async {
      for (final entry in legacySizes.entries) {
        await writePng(
          '$resDir/${entry.key}/ic_launcher.png',
          entry.value,
          withContainer: true,
        );
      }

      for (final entry in adaptiveSizes.entries) {
        await writePng(
          '$resDir/${entry.key}/ic_launcher_foreground.png',
          entry.value,
          withContainer: false,
          glyphScale: adaptiveGlyphScale,
        );
      }

      // Ikon 512×512 untuk Play Store / dokumentasi.
      await writePng(
        'assets/branding/app_icon_512.png',
        512,
        withContainer: true,
      );
    });

    // Sanity check: file benar-benar tertulis dan tidak kosong.
    for (final entry in legacySizes.entries) {
      final file = File('$resDir/${entry.key}/ic_launcher.png');
      expect(file.existsSync(), isTrue, reason: '${entry.key} tidak dibuat');
      expect(file.lengthSync(), greaterThan(0));
    }
  });
}
