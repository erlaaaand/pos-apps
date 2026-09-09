import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Satu batang: label kategori, nilainya, dan warnanya.
class BarDatum {
  const BarDatum({
    required this.label,
    required this.value,
    required this.color,
    this.secondaryText,
  });

  final String label;
  final double value;
  final Color color;

  /// Keterangan tambahan di kanan, misal jumlah porsi di samping rupiah.
  final String? secondaryText;
}

/// Batang horizontal berperingkat untuk membandingkan besaran antar kategori.
///
/// Dibuat dari widget biasa, bukan kanvas grafik: nama produk dan bahan di
/// aplikasi ini panjang-panjang, dan batang horizontal memberi label ruang
/// untuk dibaca utuh tanpa dimiringkan. Setiap batang juga diberi label nilai
/// langsung, yang sekaligus memenuhi syarat keterbacaan saat warna batang
/// kontrasnya tipis terhadap latar.
class AppBarChart extends StatelessWidget {
  const AppBarChart({
    required this.data,
    required this.formatValue,
    this.maxBars = 8,
    super.key,
  });

  final List<BarDatum> data;
  final String Function(double value) formatValue;

  /// Batas jumlah batang yang digambar. Sisanya tidak dibuang diam-diam —
  /// pemanggil menampilkan seluruh baris pada tabel di bawah grafik.
  final int maxBars;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visible = data.take(maxBars).toList();

    // Skala relatif terhadap batang terbesar. Kalau semuanya nol, tidak ada
    // yang bisa dibandingkan — semua batang digambar kosong, bukan penuh.
    final maxValue = visible.fold<double>(
      0,
      (max, item) => item.value > max ? item.value : max,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final item in visible) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.compact),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.label,
                        style: theme.textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      item.secondaryText == null
                          ? formatValue(item.value)
                          : '${formatValue(item.value)} · ${item.secondaryText}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs + 2),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: maxValue <= 0 ? 0 : item.value / maxValue,
                    minHeight: 8,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(item.color),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
