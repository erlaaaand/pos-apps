import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Badge status kompak: latar bernuansa warna statusnya, label tebal kecil,
/// dan ikon opsional.
///
/// Warna datang dari pemetaan domain pemanggil (`PoStatus.color`,
/// `OrderStatus.color`) — widget ini hanya merender, supaya badge terlihat
/// sama di seluruh aplikasi. Sengaja bukan [Chip] bawaan: referensi memakai
/// badge kecil, bukan pill besar (upgrade_ui.md §20).
class StatusChip extends StatelessWidget {
  const StatusChip({
    required this.label,
    required this.color,
    this.icon,
    super.key,
  });

  final String label;
  final Color color;

  /// Ikon opsional — dipakai saat status penting dan tidak boleh dibedakan
  /// hanya lewat warna (upgrade_ui.md §19).
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.pillRadius,
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
