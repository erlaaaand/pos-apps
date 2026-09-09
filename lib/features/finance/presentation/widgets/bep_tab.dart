import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/money/rupiah_formatter.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../application/finance_providers.dart';
import '../../domain/finance_models.dart';

class BepTab extends ConsumerWidget {
  const BepTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bepAsync = ref.watch(bepAnalysisProvider);

    return Scaffold(
      body: AsyncValueView(
        value: bepAsync,
        onRetry: () => ref.invalidate(bepAnalysisProvider),
        data: (context, bep) {
          final category = bep.category;
          Color statusColor;
          String categoryLabel;

          switch (category) {
            case MarginOfSafetyCategory.sehat:
              statusColor = Colors.green;
              categoryLabel = 'SEHAT (MoS ≥ 30%)';
            case MarginOfSafetyCategory.amanTipis:
              statusColor = Colors.orange;
              categoryLabel = 'AMAN TIPIS (MoS 15% - 29%)';
            case MarginOfSafetyCategory.rawan:
              statusColor = Colors.red;
              categoryLabel = 'RAWAN (MoS < 15%)';
            case null:
              statusColor = Colors.grey;
              categoryLabel = 'Data Belum Cukup';
          }

          final bepPortions = bep.bepPortionsPerWeek;
          final bepRupiah = bep.bepRupiahPerWeek;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.analytics_outlined, color: statusColor),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'Status Margin of Safety (MoS)',
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
                              categoryLabel,
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
                      _RowMetric(
                        label: 'Titik Impas (BEP) / Minggu',
                        value: bepPortions != null
                            ? '${bepPortions.toStringAsFixed(1)} porsi (${RupiahFormatter.format(bepRupiah ?? 0)})'
                            : 'Margin kontribusi belum positif',
                      ),
                      _RowMetric(
                        label: 'Penjualan Aktual / Minggu',
                        value:
                            '${bep.actualPortionsPerWeek.toStringAsFixed(1)} porsi (${RupiahFormatter.format(bep.actualRevenuePerWeekRupiah.round())})',
                      ),
                      _RowMetric(
                        label: 'Margin of Safety (MoS)',
                        value: bep.mosPercent != null
                            ? '${bep.mosPercent!.toStringAsFixed(1)}% (${bep.mosPortions?.toStringAsFixed(1)} porsi)'
                            : '—',
                        color: statusColor,
                        isBold: true,
                      ),
                      _RowMetric(
                        label: 'Biaya Tetap Mingguan (Operasional)',
                        value: RupiahFormatter.format(
                          bep.fixedCostPerWeekRupiah,
                        ),
                      ),
                      _RowMetric(
                        label: 'Proyeksi Laba Bersih Bulanan',
                        value: RupiahFormatter.format(
                          bep.projectedMonthlyProfitRupiah,
                        ),
                        isBold: true,
                        color: Colors.green,
                      ),
                      if (bep.weeksObserved < 4) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          '* Analisis ini dihitung berdasarkan ${bep.weeksObserved} minggu data. Hasil akan semakin akurat seiring bertambahnya transaksi.',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.orange),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Kontribusi Margin per Produk (Sales Mix)',
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (bep.contributions.isEmpty)
                const EmptyState(
                  message: 'Belum ada transaksi penjualan produk yang selesai.',
                  icon: Icons.fastfood_outlined,
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bep.contributions.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.xs),
                  itemBuilder: (context, index) {
                    final item = bep.contributions[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          item.productName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Terjual: ${item.unitsSold} porsi | Harga: ${RupiahFormatter.format(item.avgPriceRupiah.round())} | HPP: ${RupiahFormatter.format(item.avgHppRupiah.round())}',
                        ),
                        trailing: Text(
                          '+${RupiahFormatter.format(item.marginRupiah.round())} /porsi',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

class _RowMetric extends StatelessWidget {
  const _RowMetric({
    required this.label,
    required this.value,
    this.isBold = false,
    this.color,
  });

  final String label;
  final String value;
  final bool isBold;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
