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
import '../../domain/weekly_product_sales.dart';
import 'export_buttons_row.dart';

class WeeklySalesTab extends ConsumerWidget {
  const WeeklySalesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendAsync = ref.watch(weeklySalesTrendProvider);
    final dateFormat = DateFormat('d MMM', 'id_ID');

    return AsyncValueView(
      value: trendAsync,
      onRetry: () => ref.invalidate(weeklySalesTrendProvider),
      data: (context, rows) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExportButtonsRow(
                fileNameWithoutExtension: 'tren-penjualan-mingguan',
                tableBuilder: () => _toTable(rows, dateFormat),
              ),
              if (rows.isEmpty)
                const Expanded(
                  child: EmptyState(message: 'Belum ada penjualan selesai.'),
                )
              else
                Expanded(
                  child: ListView(
                    children: [
                      _SalesChart(rows: rows, dateFormat: dateFormat),
                      const SizedBox(height: AppSpacing.md),
                      for (final row in rows)
                        Card(
                          child: ListTile(
                            title: Text(row.productName),
                            subtitle: Text(
                              'Minggu ${dateFormat.format(row.weekStart)} · '
                              '${row.quantitySold} terjual',
                            ),
                            trailing: Text(
                              RupiahFormatter.format(row.revenueRupiah),
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

  ReportTable _toTable(List<WeeklyProductSales> rows, DateFormat dateFormat) {
    return ReportTable(
      headers: const [
        'Minggu Mulai',
        'Produk',
        'Qty Terjual',
        'Pendapatan (Rp)',
      ],
      rows: rows
          .map(
            (row) => [
              dateFormat.format(row.weekStart),
              row.productName,
              row.quantitySold,
              row.revenueRupiah,
            ],
          )
          .toList(),
    );
  }
}

/// Porsi terjual per minggu, satu garis per produk.
///
/// Yang digambar porsi, bukan rupiah: keduanya tidak boleh berbagi satu sumbu,
/// dan porsi adalah angka yang dipakai pemilik untuk memutuskan berapa banyak
/// harus memasak. Nilai rupiahnya tetap tersedia di daftar dan hasil ekspor
/// di bawah grafik.
class _SalesChart extends StatelessWidget {
  const _SalesChart({required this.rows, required this.dateFormat});

  final List<WeeklyProductSales> rows;
  final DateFormat dateFormat;

  @override
  Widget build(BuildContext context) {
    // Sumbu X: seluruh minggu yang punya data, urut waktu.
    final weeks = rows.map((r) => r.weekStart).toSet().toList()..sort();
    final weekIndex = {for (var i = 0; i < weeks.length; i++) weeks[i]: i};

    // Produk diurutkan abjad supaya warnanya melekat pada produk, bukan pada
    // peringkat penjualan yang berubah tiap minggu.
    final productNames = rows.map((r) => r.productName).toSet().toList()
      ..sort();
    final colors = ChartPalette.assign(context, productNames);

    final series = <LineSeries>[];
    for (final name in productNames) {
      final spots = <FlSpot>[];
      for (final week in weeks) {
        final match = rows.where(
          (r) => r.productName == name && r.weekStart == week,
        );
        // Minggu tanpa penjualan produk ini bernilai nol, bukan dilewati —
        // garis yang putus terbaca seolah datanya hilang.
        final quantity = match.isEmpty ? 0 : match.first.quantitySold;
        spots.add(FlSpot(weekIndex[week]!.toDouble(), quantity.toDouble()));
      }
      series.add(
        LineSeries(
          name: name,
          color: colors[name] ?? ChartPalette.otherOf(context),
          spots: spots,
        ),
      );
    }

    if (weeks.length < 2) {
      return ChartCard(
        title: 'Porsi Terjual per Minggu',
        subtitle:
            'Grafik tren muncul setelah ada penjualan di minimal dua minggu '
            'berbeda. Sekarang baru ada satu minggu tercatat.',
        child: const SizedBox.shrink(),
      );
    }

    return ChartCard(
      title: 'Porsi Terjual per Minggu',
      subtitle: 'Jumlah porsi selesai tiap minggu, per produk.',
      series: [
        for (final item in series)
          ChartSeriesLabel(name: item.name, color: item.color),
      ],
      child: AppLineChart(
        series: series,
        xLabels: [for (final week in weeks) dateFormat.format(week)],
        formatY: (value) => value.round().toString(),
        formatTooltipY: (value) => '${value.round()} porsi',
      ),
    );
  }
}
