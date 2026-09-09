import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/charts/app_bar_chart.dart';
import '../../../../core/charts/chart_card.dart';
import '../../../../core/charts/chart_palette.dart';
import '../../../../core/export/report_table.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../application/analytics_providers.dart';
import 'export_buttons_row.dart';

class BottleneckTab extends ConsumerWidget {
  const BottleneckTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottlenecksAsync = ref.watch(cancellationBottlenecksProvider);

    return AsyncValueView(
      value: bottlenecksAsync,
      onRetry: () => ref.invalidate(cancellationBottlenecksProvider),
      data: (context, rows) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExportButtonsRow(
                fileNameWithoutExtension: 'bottleneck-bahan-baku',
                tableBuilder: () => ReportTable(
                  headers: const ['Bahan Baku', 'Jumlah Pesanan Dibatalkan'],
                  rows: rows
                      .map((row) => [row.ingredientName, row.cancellationCount])
                      .toList(),
                ),
              ),
              if (rows.isEmpty)
                const Expanded(
                  child: EmptyState(
                    message:
                        'Belum ada pesanan yang dibatalkan karena bahan '
                        'baku tidak cukup.',
                  ),
                )
              else
                Expanded(
                  child: ListView(
                    children: [
                      ChartCard(
                        title: 'Bahan Penyebab Pembatalan',
                        subtitle:
                            'Berapa kali tiap bahan membuat pesanan batal '
                            'karena stoknya kurang.',
                        child: AppBarChart(
                          data: [
                            for (final row in rows)
                              BarDatum(
                                label: row.ingredientName,
                                value: row.cancellationCount.toDouble(),
                                // Satu deret bermakna tunggal ("seberapa
                                // sering"), jadi semuanya memakai satu rona —
                                // warna berbeda per batang akan menyiratkan
                                // kategori yang sebenarnya tidak ada.
                                color: ChartPalette.slot(context, 7),
                              ),
                          ],
                          formatValue: (value) => '${value.round()}×',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      for (final row in rows)
                        Card(
                          child: ListTile(
                            title: Text(row.ingredientName),
                            trailing: Text('${row.cancellationCount}×'),
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
