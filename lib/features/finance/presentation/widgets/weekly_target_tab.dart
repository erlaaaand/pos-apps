import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/money/rupiah_formatter.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../application/finance_providers.dart';

class WeeklyTargetTab extends ConsumerWidget {
  const WeeklyTargetTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final multiplier = ref.watch(targetGrowthMultiplierProvider);
    final recapAsync = ref.watch(weeklyTargetRecapProvider);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pengaturan Ambisi Target',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Target dihitung dari rata-rata penjualan 4 minggu terakhir dikali faktor pertumbuhan. Geser slider di bawah untuk menyesuaikan target.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Text(
                        'Target: +${((multiplier - 1.0) * 100).round()}% dari rata-rata',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      ChoiceChip(
                        label: const Text('Flat (0%)'),
                        selected: multiplier == 1.0,
                        onSelected: (_) => ref
                            .read(targetGrowthMultiplierProvider.notifier)
                            .select(1.0),
                      ),
                      const SizedBox(width: 4),
                      ChoiceChip(
                        label: const Text('+10%'),
                        selected: multiplier == 1.1,
                        onSelected: (_) => ref
                            .read(targetGrowthMultiplierProvider.notifier)
                            .select(1.1),
                      ),
                      const SizedBox(width: 4),
                      ChoiceChip(
                        label: const Text('+20%'),
                        selected: multiplier == 1.2,
                        onSelected: (_) => ref
                            .read(targetGrowthMultiplierProvider.notifier)
                            .select(1.2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Rekap Penjualan Aktual vs Target',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          AsyncValueView(
            value: recapAsync,
            onRetry: () => ref.invalidate(weeklyTargetRecapProvider),
            data: (context, items) {
              if (items.isEmpty) {
                return const EmptyState(
                  message:
                      'Belum ada data penjualan produk untuk rekap target.',
                  icon: Icons.track_changes_outlined,
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final achievement = item.achievementPercent;
                  final isAchieved = achievement != null && achievement >= 100;

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                item.productName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const Spacer(),
                              if (achievement != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm,
                                    vertical: AppSpacing.xs,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        (isAchieved
                                                ? Colors.green
                                                : Colors.orange)
                                            .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${achievement.toStringAsFixed(0)}% Target',
                                    style: TextStyle(
                                      color: isAchieved
                                          ? Colors.green
                                          : Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          LinearProgressIndicator(
                            value: (achievement ?? 0) / 100,
                            color: isAchieved ? Colors.green : Colors.orange,
                            backgroundColor: Colors.grey.shade200,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Aktual: ${item.actualPortions} porsi',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Target: ${item.targetPortions.toStringAsFixed(1)} porsi',
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Estimasi Kontribusi Laba Aktual',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                RupiahFormatter.format(
                                  item.actualContributionRupiah,
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
