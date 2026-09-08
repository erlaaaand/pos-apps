import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../data/local/app_database.dart';
import '../../orders/application/order_providers.dart';
import '../../orders/domain/order_detail.dart';
import '../../orders/presentation/widgets/order_status_label.dart';
import '../application/purchase_order_providers.dart';
import 'widgets/po_status_label.dart';

class PurchaseOrderDetailScreen extends ConsumerWidget {
  const PurchaseOrderDetailScreen({required this.purchaseOrderId, super.key});

  final int purchaseOrderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poAsync = ref.watch(purchaseOrderByIdProvider(purchaseOrderId));

    return Scaffold(
      appBar: AppBar(title: const Text('Detail PO')),
      body: AsyncValueView(
        value: poAsync,
        data: (context, po) {
          if (po == null) {
            return const EmptyState(message: 'PO tidak ditemukan.');
          }
          return _PoDetailBody(po: po);
        },
      ),
      floatingActionButton: poAsync.maybeWhen(
        data: (po) => po == null || po.status != PoStatus.open
            ? null
            : FloatingActionButton.extended(
                onPressed: () => context.push(
                  '/purchase-orders/${po.id}/orders/new',
                ),
                icon: const Icon(Icons.add),
                label: const Text('Tambah Pesanan'),
              ),
        orElse: () => null,
      ),
    );
  }
}

class _PoDetailBody extends ConsumerWidget {
  const _PoDetailBody({required this.po});

  final PurchaseOrderBatch po;

  Future<void> _handleStatusAction(BuildContext context, WidgetRef ref) async {
    final repository = ref.read(purchaseOrderRepositoryProvider);
    try {
      if (po.status == PoStatus.draft) {
        await repository.open(po.id);
      } else if (po.status == PoStatus.open) {
        await repository.close(po.id);
      }
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(friendlyErrorMessage(error))));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotaAsync = ref.watch(poQuotaStatusProvider(po.id));
    final ordersAsync = ref.watch(ordersByPurchaseOrderProvider(po.id));

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(po.label, style: Theme.of(context).textTheme.titleLarge),
                    Chip(
                      label: Text(po.status.label),
                      backgroundColor: po.status
                          .color(context)
                          .withValues(alpha: 0.15),
                      labelStyle: TextStyle(color: po.status.color(context)),
                      side: BorderSide.none,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                if (po.status == PoStatus.draft)
                  FilledButton.icon(
                    onPressed: () => _handleStatusAction(context, ref),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Buka PO'),
                  )
                else if (po.status == PoStatus.open)
                  FilledButton.icon(
                    onPressed: () => _handleStatusAction(context, ref),
                    icon: const Icon(Icons.stop),
                    label: const Text('Tutup PO'),
                  )
                else if (po.status == PoStatus.closed)
                  FilledButton.icon(
                    onPressed: () => context.push(
                      '/purchase-orders/${po.id}/production',
                    ),
                    icon: const Icon(Icons.soup_kitchen_outlined),
                    label: const Text('Proses Produksi'),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Kuota Produk', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        AsyncValueView(
          value: quotaAsync,
          data: (context, quotas) => Column(
            children: quotas
                .map(
                  (quota) => Card(
                    child: ListTile(
                      title: Text(quota.productName),
                      trailing: Text(
                        '${quota.filledQuantity}/${quota.quotaQuantity} terisi'
                        '${quota.isFull ? ' · penuh' : ''}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: quota.isFull
                              ? Theme.of(context).colorScheme.error
                              : null,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Pesanan', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        AsyncValueView(
          value: ordersAsync,
          data: (context, orders) {
            if (orders.isEmpty) {
              return const EmptyState(message: 'Belum ada pesanan di PO ini.');
            }
            return Column(
              children: orders
                  .map((detail) => _OrderTile(detail: detail))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _OrderTile extends ConsumerWidget {
  const _OrderTile({required this.detail});

  final OrderDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = detail.order;

    Future<void> handleComplete() async {
      try {
        await ref.read(orderRepositoryProvider).complete(order.id);
      } catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(friendlyErrorMessage(error))));
      }
    }

    Future<void> handleCancel() async {
      final reason = await showDialog<String>(
        context: context,
        builder: (context) => _CancelReasonDialog(),
      );
      if (reason == null) return;
      try {
        await ref
            .read(orderRepositoryProvider)
            .cancel(order.id, reason: reason);
      } catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(friendlyErrorMessage(error))));
      }
    }

    return Card(
      child: ListTile(
        title: Text('${detail.productName} × ${order.quantity}'),
        subtitle: Text(
          [
            order.buyerContact,
            order.note,
            if (order.status == OrderStatus.cancelled)
              order.cancellationReason,
          ].whereType<String>().join(' · '),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(order.status.label),
              backgroundColor: order.status
                  .color(context)
                  .withValues(alpha: 0.15),
              labelStyle: TextStyle(color: order.status.color(context)),
              side: BorderSide.none,
            ),
            if (order.status == OrderStatus.waiting)
              IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Batalkan',
                onPressed: handleCancel,
              ),
            if (order.status == OrderStatus.readyForPickup)
              IconButton(
                icon: const Icon(Icons.check_circle_outline),
                tooltip: 'Selesai & Bayar',
                onPressed: handleComplete,
              ),
          ],
        ),
      ),
    );
  }
}

class _CancelReasonDialog extends StatefulWidget {
  @override
  State<_CancelReasonDialog> createState() => _CancelReasonDialogState();
}

class _CancelReasonDialogState extends State<_CancelReasonDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Batalkan Pesanan'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(labelText: 'Alasan'),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(
            _controller.text.trim().isEmpty ? 'Dibatalkan manual' : _controller.text.trim(),
          ),
          child: const Text('Batalkan'),
        ),
      ],
    );
  }
}
