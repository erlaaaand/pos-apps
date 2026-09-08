import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/money/rupiah_formatter.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../application/daily_closing_providers.dart';

class DailyClosingScreen extends ConsumerWidget {
  const DailyClosingScreen({super.key});

  Future<void> _addOperationalCost(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Biaya Operasional'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Biaya'),
              autofocus: true,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Jumlah (Rp)',
                prefixText: 'Rp ',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (result != true) return;
    final amount = int.tryParse(amountController.text);
    if (nameController.text.trim().isEmpty || amount == null || amount <= 0) {
      return;
    }
    try {
      await ref
          .read(dailyClosingRepositoryProvider)
          .addOperationalCost(
            name: nameController.text.trim(),
            amountRupiah: amount,
          );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(friendlyErrorMessage(error))));
    }
  }

  Future<void> _closeToday(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tutup Pesanan Hari Ini?'),
        content: const Text(
          'Pesanan yang masih Siap Diambil akan otomatis dicatat sebagai '
          'waste (kerugian material). PO/pesanan baru tidak bisa dibuat '
          'lagi sampai besok. Tindakan ini tidak bisa dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Tutup Sekarang'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!context.mounted) return;

    try {
      await ref.read(dailyClosingRepositoryProvider).closeToday();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hari ini sudah ditutup.')),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(friendlyErrorMessage(error))));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(todaySummaryProvider);
    final costsAsync = ref.watch(todayOperationalCostsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Tutup Hari Ini')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(todaySummaryProvider),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            AsyncValueView(
              value: summaryAsync,
              onRetry: () => ref.invalidate(todaySummaryProvider),
              data: (context, summary) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ringkasan Hari Ini',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _Row('Pendapatan', summary.revenueRupiah),
                      _Row('HPP', -summary.hppRupiah),
                      _Row('Biaya Operasional', -summary.operationalCostRupiah),
                      _Row(
                        'Waste (belum diambil)',
                        -summary.projectedWasteCostRupiah,
                      ),
                      const Divider(),
                      _Row('Laba Bersih', summary.netProfitRupiah, bold: true),
                      if (summary.ordersPendingPickupCount > 0) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          '${summary.ordersPendingPickupCount} pesanan masih '
                          'Siap Diambil — akan jadi waste kalau ditutup sekarang.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Biaya Operasional Hari Ini',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton.icon(
                  onPressed: () => _addOperationalCost(context, ref),
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah'),
                ),
              ],
            ),
            AsyncValueView(
              value: costsAsync,
              data: (context, costs) {
                if (costs.isEmpty) {
                  return const EmptyState(
                    message: 'Belum ada biaya operasional hari ini.',
                  );
                }
                return Column(
                  children: costs
                      .map(
                        (cost) => Card(
                          child: ListTile(
                            title: Text(cost.name),
                            trailing: Text(
                              RupiahFormatter.format(cost.amountRupiah),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: () => _closeToday(context, ref),
              icon: const Icon(Icons.lock_outline),
              label: const Text('Tutup Pesanan Hari Ini'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.amountRupiah, {this.bold = false});

  final String label;
  final int amountRupiah;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            RupiahFormatter.format(amountRupiah),
            style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null,
          ),
        ],
      ),
    );
  }
}
