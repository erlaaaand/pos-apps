import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../data/local/app_database.dart';
import '../application/purchase_order_providers.dart';
import 'widgets/po_status_label.dart';

class PurchaseOrderListScreen extends ConsumerWidget {
  const PurchaseOrderListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchaseOrders = ref.watch(purchaseOrderListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('PO Harian')),
      body: AsyncValueView(
        value: purchaseOrders,
        onRetry: () => ref.invalidate(purchaseOrderListProvider),
        data: (context, items) {
          if (items.isEmpty) {
            return EmptyState(
              message:
                  'Belum ada PO hari ini. Buat PO untuk mulai menerima pesanan.',
              icon: Icons.assignment_outlined,
              action: FilledButton.icon(
                onPressed: () => context.push('/purchase-orders/new'),
                icon: const Icon(Icons.add),
                label: const Text('Buat PO'),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) => _PoTile(po: items[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/purchase-orders/new'),
        tooltip: 'Buat PO',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _PoTile extends StatelessWidget {
  const _PoTile({required this.po});

  final PurchaseOrderBatch po;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM yyyy, HH:mm', 'id_ID');
    return Card(
      child: ListTile(
        onTap: () => context.push('/purchase-orders/${po.id}'),
        title: Text(po.label),
        subtitle: Text(dateFormat.format(po.createdAt)),
        trailing: Chip(
          label: Text(po.status.label),
          backgroundColor: po.status.color(context).withValues(alpha: 0.15),
          labelStyle: TextStyle(color: po.status.color(context)),
          side: BorderSide.none,
        ),
      ),
    );
  }
}
