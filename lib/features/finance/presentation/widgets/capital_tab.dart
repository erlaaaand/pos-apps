import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/money/rupiah_formatter.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../data/local/app_database.dart';
import '../../application/finance_providers.dart';
import 'capital_entry_sheet.dart';

class CapitalTab extends ConsumerWidget {
  const CapitalTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(capitalSummaryProvider);
    final entriesAsync = ref.watch(capitalEntriesProvider);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AsyncValueView(
            value: summaryAsync,
            onRetry: () => ref.invalidate(capitalSummaryProvider),
            data: (context, summary) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ringkasan Modal Kerja',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _MetricRow(
                        label: 'Total Modal Masuk',
                        value: RupiahFormatter.format(summary.modalMasukRupiah),
                        color: Colors.green,
                      ),
                      const Divider(height: AppSpacing.md),
                      _MetricRow(
                        label: 'Investasi Alat / Perlengkapan',
                        value: RupiahFormatter.format(
                          summary.investasiAlatRupiah,
                        ),
                        color: Colors.orange,
                      ),
                      const Divider(height: AppSpacing.md),
                      _MetricRow(
                        label: 'Modal Kerja Tersedia',
                        value: RupiahFormatter.format(
                          summary.modalKerjaTersediaRupiah,
                        ),
                        isBold: true,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Riwayat Entri Modal & Alat',
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              FilledButton.tonalIcon(
                onPressed: () => showCapitalEntrySheet(context),
                icon: const Icon(Icons.add),
                label: const Text('Tambah'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AsyncValueView(
            value: entriesAsync,
            onRetry: () => ref.invalidate(capitalEntriesProvider),
            data: (context, items) {
              if (items.isEmpty) {
                return const EmptyState(
                  message: 'Belum ada catatan modal atau investasi alat. Klik "Tambah" untuk mencatat modal awal.',
                  icon: Icons.account_balance_wallet_outlined,
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.xs),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isCapital = item.kind != CapitalEntryKind.equipment;
                  return Card(
                    margin: EdgeInsets.zero,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isCapital
                            ? Colors.green.withValues(alpha: 0.15)
                            : Colors.orange.withValues(alpha: 0.15),
                        child: Icon(
                          isCapital
                              ? Icons.arrow_downward
                              : Icons.build_circle_outlined,
                          color: isCapital ? Colors.green : Colors.orange,
                        ),
                      ),
                      title: Text(
                        isCapital
                            ? 'Modal Masuk / Modal Awal'
                            : 'Investasi Alat',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        item.note ??
                            (isCapital
                                ? 'Pencatatan modal'
                                : 'Pembelian alat/perlengkapan'),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            RupiahFormatter.format(item.amountRupiah),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isCapital ? Colors.green : Colors.orange,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Hapus Catatan Modal'),
                                  content: const Text(
                                    'Apakah Anda yakin ingin menghapus catatan modal ini?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx, false),
                                      child: const Text('Batal'),
                                    ),
                                    FilledButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await ref
                                    .read(financeRepositoryProvider)
                                    .deleteCapitalEntry(item.id);
                              }
                            },
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

class _MetricRow extends StatelessWidget {
  const _MetricRow({
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
