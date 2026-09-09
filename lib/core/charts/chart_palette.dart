import 'package:flutter/material.dart';

/// Palet warna untuk grafik laporan.
///
/// Delapan rona ini bukan pilihan selera: urutannya sudah lolos uji
/// keterbacaan untuk buta warna (deuteranopia/protanopia/tritanopia) dan uji
/// kontras pada kedua permukaan aplikasi — terang `#FAF7F3` dan gelap
/// `#1A1714`. Mengubah urutan atau menyisipkan warna baru membatalkan hasil
/// uji itu, jadi jangan menambah rona; deret ke-9 dan seterusnya digabung
/// menjadi "Lainnya" lewat [assign].
///
/// Kolom gelap adalah delapan rona yang sama yang dilangkahkan ulang untuk
/// latar gelap, bukan palet lain — supaya identitas warna tiap produk tetap
/// terasa sama saat pengguna berganti mode.
abstract final class ChartPalette {
  /// Slot kategorikal untuk mode terang.
  static const List<Color> light = [
    Color(0xFF2A78D6), // 1 biru
    Color(0xFFEB6834), // 2 oranye
    Color(0xFF1BAF7A), // 3 toska
    Color(0xFFEDA100), // 4 kuning
    Color(0xFFE87BA4), // 5 magenta
    Color(0xFF008300), // 6 hijau
    Color(0xFF4A3AA7), // 7 ungu
    Color(0xFFE34948), // 8 merah
  ];

  /// Slot kategorikal untuk mode gelap.
  static const List<Color> dark = [
    Color(0xFF3987E5),
    Color(0xFFD95926),
    Color(0xFF199E70),
    Color(0xFFC98500),
    Color(0xFFD55181),
    Color(0xFF008300),
    Color(0xFF9085E9),
    Color(0xFFE66767),
  ];

  /// Warna netral untuk kelompok gabungan "Lainnya".
  static const Color otherLight = Color(0xFF6B6560);
  static const Color otherDark = Color(0xFF9A938C);

  static List<Color> of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;

  static Color otherOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? otherDark : otherLight;

  /// Warna slot ke-[index]. Indeks di luar delapan slot memakai warna
  /// "Lainnya" — sengaja tidak berputar kembali ke slot 1, karena dua deret
  /// berwarna sama pada satu grafik lebih menyesatkan daripada satu warna abu.
  static Color slot(BuildContext context, int index) {
    final palette = of(context);
    if (index < 0 || index >= palette.length) return otherOf(context);
    return palette[index];
  }

  /// Jumlah rona kategorikal yang tersedia sebelum digabung jadi "Lainnya".
  static const int slotCount = 8;

  /// Memberi warna tetap per nama entitas.
  ///
  /// Warna mengikuti entitasnya, bukan peringkatnya: menyaring daftar tidak
  /// boleh mengecat ulang produk yang tersisa. Karena itu urutan kunci yang
  /// diberikan harus stabil (biasanya urut abjad), bukan urut nilai.
  static Map<String, Color> assign(BuildContext context, List<String> keys) {
    final result = <String, Color>{};
    for (var i = 0; i < keys.length; i++) {
      result[keys[i]] = slot(context, i);
    }
    return result;
  }
}
