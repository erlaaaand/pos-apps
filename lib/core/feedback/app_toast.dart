import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Nada pesan umpan balik. Menentukan warna dan ikon, bukan isi pesannya.
enum AppToastTone { success, error, warning, info }

/// Pesan umpan balik singkat setelah sebuah aksi selesai.
///
/// Dipakai lewat helper statis ([AppToast.success] dan kawan-kawan) supaya
/// setiap layar memberi umpan balik dengan bentuk yang sama — pemilik warung
/// tidak perlu menebak apakah simpanannya berhasil.
///
/// Sengaja memakai `ScaffoldMessenger` bawaan, bukan overlay sendiri: dia
/// sudah menangani antrean pesan, aman saat layar ditutup di tengah proses,
/// dan otomatis naik di atas `FloatingActionButton`.
abstract final class AppToast {
  /// Aksi berhasil (simpan, hapus, impor).
  static void success(BuildContext context, String message) =>
      _show(context, message, AppToastTone.success);

  /// Aksi gagal. Durasi lebih panjang karena biasanya perlu dibaca.
  static void error(BuildContext context, String message) =>
      _show(context, message, AppToastTone.error);

  /// Berhasil, tapi ada yang perlu diperhatikan.
  static void warning(BuildContext context, String message) =>
      _show(context, message, AppToastTone.warning);

  /// Kabar netral tanpa konsekuensi.
  static void info(BuildContext context, String message) =>
      _show(context, message, AppToastTone.info);

  /// Menghapus pesan yang sedang tampil. Berguna sebelum berpindah layar.
  static void clear(BuildContext context) =>
      ScaffoldMessenger.maybeOf(context)?.clearSnackBars();

  static void _show(BuildContext context, String message, AppToastTone tone) {
    // `maybeOf` — bukan `of` — karena pemanggilnya sering berada di dalam
    // bottom sheet yang sudah mulai ditutup. Diam-diam tidak menampilkan
    // pesan jauh lebih baik daripada melempar error saat aksinya berhasil.
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    final (background, foreground, icon) = _style(tone);

    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: foreground, size: 20),
              const SizedBox(width: AppSpacing.compact),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: background,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(AppSpacing.md),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.compact,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          duration: tone == AppToastTone.error
              ? const Duration(seconds: 5)
              : const Duration(seconds: 3),
        ),
      );
  }

  static (Color background, Color foreground, IconData icon) _style(
    AppToastTone tone,
  ) {
    return switch (tone) {
      AppToastTone.success => (
        AppColors.success,
        Colors.white,
        Icons.check_circle_outline,
      ),
      AppToastTone.error => (
        AppColors.danger,
        Colors.white,
        Icons.error_outline,
      ),
      AppToastTone.warning => (
        AppColors.warning,
        Colors.white,
        Icons.warning_amber_rounded,
      ),
      AppToastTone.info => (AppColors.info, Colors.white, Icons.info_outline),
    };
  }
}
