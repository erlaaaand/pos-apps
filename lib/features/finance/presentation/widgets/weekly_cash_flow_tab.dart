import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/charts/app_line_chart.dart';
import '../../../../core/charts/chart_card.dart';
import '../../../../core/charts/chart_palette.dart';
import '../../../../core/money/rupiah_formatter.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../application/finance_providers.dart';
import '../../domain/finance_models.dart';

class WeeklyCashFlowTab extends ConsumerWidget {
  const WeeklyCashFlowTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthAsync = ref.watch(workingCapitalHealthProvider);
    final cashFlowAsync = ref.watch(weeklyCashFlowProvider);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AsyncValueView(
            value: healthAsync,
            onRetry: () => ref.invalidate(workingCapitalHealthProvider),
            data: (context, health) {
              final status = health.status;
              Color statusColor;
              String statusLabel;
              IconData statusIcon;

              switch (status) {
                case WorkingCapitalStatus.aman:
                  statusColor = Colors.green;
                  statusLabel = 'Aman (Ketahanan > 1 Minggu)';
                  statusIcon = Icons.check_circle_outline;
                case WorkingCapitalStatus.waspada:
                  statusColor = Colors.orange;
                  statusLabel = 'Waspada (Ketahanan 0.5 - 1 Minggu)';
                  statusIcon = Icons.warning_amber_outlined;
                case WorkingCapitalStatus.kritis:
                  statusColor = Colors.red;
                  statusLabel = 'Kritis (Ketahanan < 0.5 Minggu)';
                  statusIcon = Icons.error_outline;
                case null:
                  statusColor = Colors.grey;
                  statusLabel = 'Belum Ada Data Pengeluaran';
                  statusIcon = Icons.help_outline;
              }

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(statusIcon, color: statusColor),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'Kesehatan Modal Kerja',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              statusLabel,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kebutuhan Kas / Minggu',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  RupiahFormatter.format(
                                    health.kebutuhanKasPerMingguRupiah,
                                  ),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kas Akhir Terbaru',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  RupiahFormatter.format(health.kasAkhirRupiah),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (health.rasio != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Rasio Ketahanan: ${health.rasio!.toStringAsFixed(1)} minggu operasional',
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Laporan Arus Kas Mingguan',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          AsyncValueView(
            value: cashFlowAsync,
            onRetry: () => ref.invalidate(weeklyCashFlowProvider),
            data: (context, items) {
              if (items.isEmpty) {
                return const EmptyState(
                  message: 'Belum ada transaksi arus kas. Arus kas dihitung otomatis dari belanja bahan & pesanan.',
                  icon: Icons.waterfall_chart_outlined,
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _CashFlowChart(items: items),
                  const SizedBox(height: AppSpacing.md),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final formattedDate =
                          'Minggu ${item.weekStart.day}/${item.weekStart.month}/${item.weekStart.year}';
                      return Card(
                        child: ExpansionTile(
                          title: Text(
                            formattedDate,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Kas Akhir: ${RupiahFormatter.format(item.kasAkhirRupiah)} | Laba: ${RupiahFormatter.format(item.labaRugiRupiah)}',
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Column(
                                children: [
                                  _CashRow(
                                    label: 'Kas Awal Minggu',
                                    amount: item.kasAwalRupiah,
                                  ),
                                  _CashRow(
                                    label: 'Kas Masuk (Penjualan)',
                                    amount: item.kasMasukRupiah,
                                    isPositive: true,
                                  ),
                                  _CashRow(
                                    label: 'Kas Keluar (Belanja & Operasional)',
                                    amount: item.kasKeluarRupiah,
                                    isNegative: true,
                                  ),
                                  const Divider(),
                                  _CashRow(
                                    label: 'Laba / Rugi Bersih',
                                    amount: item.labaRugiRupiah,
                                    isBold: true,
                                  ),
                                  _CashRow(
                                    label: 'Akumulasi Laba (Modal Terkumpul)',
                                    amount: item.modalTerkumpulRupiah,
                                    isBold: true,
                                  ),
                                  _CashRow(
                                    label: 'Kas Akhir Minggu',
                                    amount: item.kasAkhirRupiah,
                                    isBold: true,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CashRow extends StatelessWidget {
  const _CashRow({
    required this.label,
    required this.amount,
    this.isPositive = false,
    this.isNegative = false,
    this.isBold = false,
    this.color,
  });

  final String label;
  final int amount;
  final bool isPositive;
  final bool isNegative;
  final bool isBold;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    Color displayColor = color ?? Theme.of(context).textTheme.bodyLarge!.color!;
    if (isPositive) displayColor = Colors.green;
    if (isNegative) displayColor = Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            RupiahFormatter.format(amount),
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: displayColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Kas masuk vs kas keluar tiap minggu.
///
/// Keduanya satuan rupiah, jadi sah berbagi satu sumbu — dan justru itu
/// intinya: jarak antara kedua garis adalah untung atau ruginya minggu itu.
class _CashFlowChart extends StatelessWidget {
  const _CashFlowChart({required this.items});

  final List<WeeklyCashFlow> items;

  @override
  Widget build(BuildContext context) {
    final sorted = [...items]
      ..sort((a, b) => a.weekStart.compareTo(b.weekStart));

    if (sorted.length < 2) {
      return const ChartCard(
        title: 'Kas Masuk vs Kas Keluar',
        subtitle: 'Grafik muncul setelah ada minimal dua minggu tercatat.',
        child: SizedBox.shrink(),
      );
    }

    final masuk = ChartPalette.slot(context, 5); // hijau
    final keluar = ChartPalette.slot(context, 7); // merah

    return ChartCard(
      title: 'Kas Masuk vs Kas Keluar',
      subtitle: 'Jarak antara kedua garis adalah untung/rugi minggu itu.',
      series: [
        ChartSeriesLabel(name: 'Kas Masuk', color: masuk),
        ChartSeriesLabel(name: 'Kas Keluar', color: keluar),
      ],
      child: AppLineChart(
        series: [
          LineSeries(
            name: 'Kas Masuk',
            color: masuk,
            spots: [
              for (var i = 0; i < sorted.length; i++)
                FlSpot(i.toDouble(), sorted[i].kasMasukRupiah.toDouble()),
            ],
          ),
          LineSeries(
            name: 'Kas Keluar',
            color: keluar,
            spots: [
              for (var i = 0; i < sorted.length; i++)
                FlSpot(i.toDouble(), sorted[i].kasKeluarRupiah.toDouble()),
            ],
          ),
        ],
        xLabels: [
          for (final item in sorted)
            '${item.weekStart.day}/${item.weekStart.month}',
        ],
        formatY: _compactRupiah,
        formatTooltipY: (value) => RupiahFormatter.format(value.round()),
      ),
    );
  }

  static String _compactRupiah(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}jt';
    if (value >= 1000) return '${(value / 1000).round()}rb';
    return value.round().toString();
  }
}
