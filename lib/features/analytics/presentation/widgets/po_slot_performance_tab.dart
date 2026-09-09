import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/charts/app_bar_chart.dart';
import '../../../../core/charts/chart_card.dart';
import '../../../../core/charts/chart_palette.dart';
import '../../../../core/export/report_table.dart';
import '../../../../core/money/rupiah_formatter.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../application/analytics_providers.dart';
import 'export_buttons_row.dart';

class PoSlotPerformanceTab extends ConsumerWidget {
  const PoSlotPerformanceTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final performanceAsync = ref.watch(poSlotPerformanceProvider);

    return AsyncValueView(
      value: performanceAsync,
      onRetry: () => ref.invalidate(poSlotPerformanceProvider),
      data: (context, rows) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExportButtonsRow(
                fileNameWithoutExtension: 'performa-slot-po',
                tableBuilder: () => ReportTable(
                  headers: const [
                    'Slot PO',
                    'Produk',
                    'Qty Terjual',
                    'Pendapatan (Rp)',
                  ],
                  rows: rows
                      .map(
                        (row) => [
                          row.slotLabel,
                          row.productName,
                          row.quantitySold,
                          row.revenueRupiah,
                        ],
                      )
                      .toList(),
                ),
              ),
              if (rows.isEmpty)
                const Expanded(
                  child: EmptyState(message: 'Belum ada penjualan selesai.'),
                )
              else
                Expanded(
                  child: ListView(
                    children: [
                      Builder(
                        builder: (context) {
                          // Warna menandai slot PO-nya (pagi/sore), jadi satu
                          // slot tetap berwarna sama di semua produk.
                          final slots =
                              rows.map((r) => r.slotLabel).toSet().toList()
                                ..sort();
                          final colors = ChartPalette.assign(context, slots);
                          final ranked = [...rows]
                            ..sort(
                              (a, b) =>
                                  b.revenueRupiah.compareTo(a.revenueRupiah),
                            );

                          return ChartCard(
                            title: 'Pendapatan per Slot PO',
                            subtitle: 'Slot dan produk mana yang paling menghasilkan.',
                            series: [
                              for (final slot in slots)
                                ChartSeriesLabel(
                                  name: slot,
                                  color:
                                      colors[slot] ??
                                      ChartPalette.otherOf(context),
                                ),
                            ],
                            child: AppBarChart(
                              data: [
                                for (final row in ranked)
                                  BarDatum(
                                    label:
                                        '${row.slotLabel} · ${row.productName}',
                                    value: row.revenueRupiah.toDouble(),
                                    color:
                                        colors[row.slotLabel] ??
                                        ChartPalette.otherOf(context),
                                    secondaryText: '${row.quantitySold} porsi',
                                  ),
                              ],
                              formatValue: (value) =>
                                  RupiahFormatter.format(value.round()),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      for (final row in rows)
                        Card(
                          child: ListTile(
                            title: Text(
                              '${row.slotLabel} · ${row.productName}',
                            ),
                            subtitle: Text('${row.quantitySold} terjual'),
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
}
