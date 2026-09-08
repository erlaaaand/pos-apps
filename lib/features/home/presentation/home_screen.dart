import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../data/local/app_database.dart';
import '../../ingredients/application/ingredient_providers.dart';
import '../../products/application/product_providers.dart';
import '../../purchase_orders/application/purchase_order_providers.dart';

/// Landing dashboard. Bagian A and B from erp.md are fully wired up; Bagian
/// C (laporan) and D (backup) land here as shortcuts once they're built.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredientCount = ref.watch(ingredientListProvider).value?.length;
    final productCount = ref
        .watch(productsWithActiveRecipeProvider)
        .value
        ?.length;
    final openPoCount = ref
        .watch(purchaseOrderListProvider)
        .value
        ?.where((po) => po.status == PoStatus.open)
        .length;

    return Scaffold(
      appBar: AppBar(title: const Text('Business Management')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  label: 'PO Buka',
                  count: openPoCount,
                  icon: Icons.assignment_outlined,
                  onTap: () => context.go('/purchase-orders'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _SummaryCard(
                  label: 'Bahan Baku',
                  count: ingredientCount,
                  icon: Icons.inventory_2_outlined,
                  onTap: () => context.go('/ingredients'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _SummaryCard(
                  label: 'Produk',
                  count: productCount,
                  icon: Icons.restaurant_menu_outlined,
                  onTap: () => context.go('/products'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Card(
            child: ListTile(
              leading: const Icon(Icons.lock_clock_outlined),
              title: const Text('Tutup Pesanan Hari Ini'),
              subtitle: const Text('Ringkasan laba rugi & tutup hari'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/daily-closing'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.bar_chart_outlined),
              title: const Text('Laporan'),
              subtitle: const Text('Tren penjualan, performa menu, bottleneck bahan'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/analytics'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.backup_outlined),
              title: const Text('Backup & Restore'),
              subtitle: const Text('Salinan data, pulihkan dari file'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/backup'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.count,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final int? count;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: AppSpacing.sm),
              Text(
                count == null ? '—' : '$count',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
