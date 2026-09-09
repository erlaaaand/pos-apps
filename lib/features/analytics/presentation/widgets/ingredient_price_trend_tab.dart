import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/charts/app_line_chart.dart';
import '../../../../core/charts/chart_card.dart';
import '../../../../core/charts/chart_palette.dart';
import '../../../../core/export/report_table.dart';
import '../../../../core/money/rupiah_formatter.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../application/analytics_providers.dart';
import '../../domain/ingredient_price_point.dart';
import 'export_buttons_row.dart';

class IngredientPriceTrendTab extends ConsumerWidget {
  const IngredientPriceTrendTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendAsync = ref.watch(ingredientPriceTrendProvider);
    final dateFormat = DateFormat('d MMM yyyy', 'id_ID');

    return AsyncValueView(
      value: trendAsync,
      onRetry: () => ref.invalidate(ingredientPriceTrendProvider),
      data: (context, rows) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExportButtonsRow(
                fileNameWithoutExtension: 'tren-harga-beli-bahan-baku',
                tableBuilder: () => ReportTable(
                  headers: const [
                    'Bahan Baku',
                    'Tanggal',
                    'Harga/Satuan (Rp)',
                    'Toko',
                  ],
                  rows: rows
                      .map(
                        (row) => [
                          row.ingredientName,
                          dateFormat.format(row.purchasedAt),
                          row.pricePerUnit.round(),
                          row.storeName ?? '',
                        ],
                      )
                      .toList(),
                ),
              ),
              if (rows.isEmpty)
                const Expanded(
                  child: EmptyState(message: 'Belum ada riwayat pembelian.'),
                )
              else
                Expanded(
                  child: ListView(
                    children: [
                      _PriceTrendChart(rows: rows),
                      const SizedBox(height: AppSpacing.md),
                      for (final row in rows)
                        Card(
                          child: ListTile(
                            title: Text(row.ingredientName),
                            subtitle: Text(
                              '${dateFormat.format(row.purchasedAt)}'
                              '${row.storeName != null ? ' · ${row.storeName}' : ''}',
                            ),
                            trailing: Text(
                              RupiahFormatter.format(row.pricePerUnit.round()),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Harga beli per satuan sepanjang waktu, satu garis per bahan.
///
/// Hanya delapan bahan dengan pembelian terbanyak yang digambar: melewati
/// jumlah rona yang tersedia berarti ada dua bahan berwarna sama, dan itu
/// lebih menyesatkan daripada tidak menggambarkannya. Seluruh baris tetap ada
/// di daftar dan hasil ekspor di bawah grafik.
class _PriceTrendChart extends StatelessWidget {
  const _PriceTrendChart({required this.rows});

  final List<IngredientPricePoint> rows;

  @override
  Widget build(BuildContext context) {
    final countByIngredient = <String, int>{};
    for (final row in rows) {
      countByIngredient[row.ingredientName] =
          (countByIngredient[row.ingredientName] ?? 0) + 1;
    }

    // Pilih bahan dengan titik terbanyak (tren paling bermakna), lalu urutkan
    // abjad supaya warnanya tetap melekat pada bahan yang sama.
    final ranked = countByIngredient.keys.toList()
      ..sort((a, b) => countByIngredient[b]!.compareTo(countByIngredient[a]!));
    final shown = ranked.take(ChartPalette.slotCount).toList()..sort();

    final dates =
        rows
            .where((r) => shown.contains(r.ingredientName))
            .map(
              (r) => DateTime(
                r.purchasedAt.year,
                r.purchasedAt.month,
                r.purchasedAt.day,
              ),
            )
            .toSet()
            .toList()
          ..sort();

    if (dates.length < 2) {
      return const ChartCard(
        title: 'Tren Harga Beli per Satuan',
        subtitle:
            'Grafik muncul setelah ada pembelian di minimal dua tanggal '
            'berbeda.',
        child: SizedBox.shrink(),
      );
    }

    final dateIndex = {for (var i = 0; i < dates.length; i++) dates[i]: i};
    final colors = ChartPalette.assign(context, shown);

    final series = <LineSeries>[];
    for (final name in shown) {
      final spots = <FlSpot>[];
      for (final date in dates) {
        final sameDay = rows.where(
          (r) =>
              r.ingredientName == name &&
              DateTime(
                    r.purchasedAt.year,
                    r.purchasedAt.month,
                    r.purchasedAt.day,
                  ) ==
                  date,
        );
        // Tanggal tanpa pembelian bahan ini dilewati, bukan dijadikan nol:
        // tidak membeli bukan berarti harganya turun jadi Rp0.
        if (sameDay.isEmpty) continue;
        final average =
            sameDay.fold<double>(0, (sum, r) => sum + r.pricePerUnit) /
            sameDay.length;
        spots.add(FlSpot(dateIndex[date]!.toDouble(), average));
      }
      if (spots.length < 2) continue;
      series.add(
        LineSeries(
          name: name,
          color: colors[name] ?? ChartPalette.otherOf(context),
          spots: spots,
        ),
      );
    }

    if (series.isEmpty) {
      return const ChartCard(
        title: 'Tren Harga Beli per Satuan',
        subtitle:
            'Belum ada bahan yang dibeli lebih dari sekali, jadi belum ada '
            'tren yang bisa digambar.',
        child: SizedBox.shrink(),
      );
    }

    final dateFormat = DateFormat('d MMM', 'id_ID');
    return ChartCard(
      title: 'Tren Harga Beli per Satuan',
      subtitle: 'Naik-turun harga modal tiap bahan.',
      series: [
        for (final item in series)
          ChartSeriesLabel(name: item.name, color: item.color),
      ],
      child: AppLineChart(
        series: series,
        xLabels: [for (final date in dates) dateFormat.format(date)],
        formatY: (value) => _compactRupiah(value),
        formatTooltipY: (value) => RupiahFormatter.format(value.round()),
      ),
    );
  }

  /// Sumbu Y dipendekkan (12rb / 1,2jt) supaya label tidak menghabiskan
  /// lebar grafik; nilai utuhnya tetap muncul di tooltip.
  static String _compactRupiah(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}jt';
    }
    if (value >= 1000) return '${(value / 1000).round()}rb';
    return value.round().toString();
  }
}
