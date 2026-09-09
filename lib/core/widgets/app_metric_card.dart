import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'app_pressable.dart';

/// Kartu metrik kompak: ubin ikon di atas, angka besar, lalu label kecil.
///
/// Referensi memakainya bertiga dalam satu baris di Beranda. Angkanya sengaja
/// paling menonjol — informasi numerik yang harus bisa dipindai sekilas
/// (upgrade_ui.md §18).
class AppMetricCard extends StatelessWidget {
  const AppMetricCard({
    required this.icon,
    required this.value,
    required this.label,
    this.tint,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color? tint;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = tint ?? AppColors.primary;

    return AppPressable(
      onTap: onTap,
      borderRadius: AppRadius.lgRadius,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
          borderRadius: AppRadius.lgRadius,
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.10),
                borderRadius: AppRadius.cardRadius,
                border: Border.all(color: accent.withValues(alpha: 0.22)),
              ),
              child: Icon(icon, size: 18, color: accent),
            ),
            const SizedBox(height: AppSpacing.compact),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
