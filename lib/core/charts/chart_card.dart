import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Satu deret pada grafik, dipakai untuk menggambar legenda.
class ChartSeriesLabel {
  const ChartSeriesLabel({required this.name, required this.color});

  final String name;
  final Color color;
}

/// Bingkai standar sebuah grafik: judul, keterangan singkat, legenda, isi.
///
/// Legenda selalu muncul begitu ada dua deret atau lebih — identitas deret
/// tidak boleh hanya bergantung pada warna. Untuk deret tunggal legenda
/// dihilangkan, karena judulnya sudah menyebut deret itu.
class ChartCard extends StatelessWidget {
  const ChartCard({
    required this.title,
    required this.child,
    this.subtitle,
    this.series = const [],
    this.height,
    super.key,
  });

  final String title;
  final String? subtitle;
  final List<ChartSeriesLabel> series;

  /// Tinggi tetap area grafik. Biarkan null untuk grafik yang menentukan
  /// tingginya sendiri, seperti deretan batang horizontal.
  final double? height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.compact),
            if (height == null)
              child
            else
              SizedBox(height: height, child: child),
            if (series.length >= 2) ...[
              const SizedBox(height: AppSpacing.compact),
              ChartLegend(series: series),
            ],
          ],
        ),
      ),
    );
  }
}

/// Legenda: satu kotak warna kecil + nama deret dengan warna teks biasa.
///
/// Nama deret sengaja tidak diwarnai seperti garisnya — teks berwarna sulit
/// dibaca pada latar terang, dan kotak di sebelahnya sudah cukup membawa
/// identitas warnanya.
class ChartLegend extends StatelessWidget {
  const ChartLegend({required this.series, super.key});

  final List<ChartSeriesLabel> series;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: AppSpacing.compact,
      runSpacing: AppSpacing.sm,
      children: [
        for (final item in series)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(AppRadius.sm / 3),
                ),
              ),
              const SizedBox(width: AppSpacing.xs + 2),
              Text(
                item.name,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
