import 'package:flutter/material.dart';

/// Semantic color tokens, diambil dari `lib/reference_theme/design.html`
/// (konfigurasi Tailwind di bagian head + nilai yang dipakai di markup).
///
/// Identitas visualnya hangat: oranye/cokelat di atas latar krem. Layar tidak
/// boleh memakai `Color(0x...)` mentah — selalu lewat token di sini supaya
/// satu perubahan palet berlaku ke seluruh aplikasi.
abstract final class AppColors {
  // --- Brand ---

  /// Oranye utama WarungKu — tombol utama, ikon aktif, angka penting.
  static const Color primary = Color(0xFFE87800);

  /// Varian gelap untuk teks di atas latar terang dan state ditekan.
  static const Color primaryDark = Color(0xFF944A00);

  /// Latar sangat lembut untuk badge/ikon chip bernuansa primary.
  static const Color primaryLight = Color(0xFFFFF3E6);

  /// Container primary (mis. latar chip terpilih).
  static const Color primaryContainer = Color(0xFFFFDCC5);

  /// Cokelat pendamping — dipakai untuk aksen sekunder, bukan aksi utama.
  static const Color secondary = Color(0xFF8B501E);

  static const Color secondaryContainer = Color(0xFFFEB075);

  // --- Latar & permukaan ---

  /// Latar halaman.
  static const Color background = Color(0xFFFAF7F3);

  /// Permukaan umum (app bar, sheet).
  static const Color surface = Color(0xFFFCF9F5);

  /// Permukaan kartu — putih bersih supaya kartu terangkat dari latar krem
  /// tanpa perlu bayangan tebal.
  static const Color surfaceCard = Color(0xFFFFFFFF);

  /// Permukaan redup untuk baris/isian yang tidak perlu menonjol.
  static const Color surfaceSubtle = Color(0xFFF6F2EB);

  static const Color surfaceContainer = Color(0xFFF0EDE9);

  static const Color surfaceContainerHigh = Color(0xFFE5E2DE);

  /// Garis tepi kartu — hangat dan tipis, pengganti bayangan.
  static const Color cardBorder = Color(0xFFEFEAE3);

  static const Color outline = Color(0xFF8A7263);

  static const Color outlineVariant = Color(0xFFE8DED7);

  // --- Teks ---

  static const Color textPrimary = Color(0xFF1E1A17);

  static const Color textSecondary = Color(0xFF63584E);

  static const Color textTertiary = Color(0xFF655D58);

  static const Color onPrimary = Color(0xFFFFFFFF);

  // --- Gradien header ---

  /// Header Beranda memakai gradasi amber yang meluruh ke warna latar.
  static const Color headerGradientTop = Color(0xFFD96B00);
  static const Color headerGradientMid = Color(0xFFE87800);
  static const Color headerGradientBottom = background;

  // --- Status semantik ---
  //
  // Warna status sengaja dijaga agar tetap terbaca di atas latar hangat dan
  // tidak bertabrakan dengan oranye primary (lihat upgrade_ui.md §19: status
  // tidak boleh hanya dibedakan lewat warna, selalu dipasangkan ikon/label).

  /// Sehat / aktif / tersedia.
  static const Color success = Color(0xFF00875A);

  static const Color successContainer = Color(0xFFD7F2E6);

  /// Menipis / perlu ditinjau. Sengaja lebih pekat dari [primary] supaya
  /// peringatan tidak terbaca sebagai aksen brand biasa.
  static const Color warning = Color(0xFFB45309);

  static const Color warningContainer = Color(0xFFFDEBD2);

  /// Habis / gagal / kritis.
  static const Color danger = Color(0xFFBA1A1A);

  static const Color dangerContainer = Color(0xFFFFDAD6);

  /// Informasi netral yang tetap berada di dalam identitas hangat — referensi
  /// tidak memakai biru sama sekali, jadi token ini memakai cokelat sekunder
  /// alih-alih memasukkan warna asing ke palet.
  static const Color info = Color(0xFF8B501E);

  static const Color infoContainer = Color(0xFFF5E6D8);

  /// Belum ada aksi — draft PO, pesanan menunggu.
  static const Color neutral = Color(0xFF655D58);

  static const Color neutralContainer = Color(0xFFEAE8E4);

  // --- Kompatibilitas ---

  /// Dipakai `AppTheme` untuk latar scaffold terang/gelap.
  static const Color surfaceLight = background;
  static const Color surfaceDark = Color(0xFF1A1714);
}
