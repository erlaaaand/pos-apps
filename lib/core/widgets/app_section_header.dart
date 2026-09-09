import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Judul seksi bergaya referensi: ikon kecil berwarna primary, label huruf
/// kapital ber-tracking lebar, dan badge opsional di kanan.
///
/// Dipakai untuk memecah halaman panjang tanpa perlu membungkus tiap seksi
/// dalam kartu (upgrade_ui.md §17).
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    required this.title,
    this.icon,
    this.trailingLabel,
    this.trailingColor,
    super.key,
  });

  final String title;
  final IconData? icon;

  /// Badge kecil di ujung kanan, mis. "Real-time".
  final String? trailingLabel;
  final Color? trailingColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = trailingColor ?? AppColors.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 17, color: AppColors.primary),
            const SizedBox(width: AppSpacing.xs + 2),
          ],
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          if (trailingLabel != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.10),
                borderRadius: AppRadius.pillRadius,
                border: Border.all(color: accent.withValues(alpha: 0.25)),
              ),
              child: Text(
                trailingLabel!,
                style: theme.textTheme.labelSmall?.copyWith(color: accent),
              ),
            ),
        ],
      ),
    );
  }
}
