import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../data/local/app_database.dart';
import '../application/purchase_order_providers.dart';
import '../domain/po_quota_status.dart';
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
              message: 'Belum ada PO hari ini. Buat PO untuk mulai menerima pesanan.',
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
        heroTag: 'fab_po_list',
        onPressed: () => context.push('/purchase-orders/new'),
        tooltip: 'Buat PO',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _PoTile extends ConsumerWidget {
  const _PoTile({required this.po});

  final PurchaseOrderBatch po;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('d MMM yyyy, HH:mm', 'id_ID');
    final quotas = ref.watch(poQuotaStatusProvider(po.id)).value;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final statusColor = po.status.color(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/purchase-orders/${po.id}'),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 2,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon badge
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: AppRadius.cardRadius,
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  color: statusColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Label + date + quota bar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      po.label,
                      style: tt.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateFormat.format(po.createdAt),
                      style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    if (quotas != null && quotas.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      _QuotaBar(quotas: quotas),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Status chip
              StatusChip(label: po.status.label, color: statusColor),
            ],
          ),
        ),
      ),
    );
  }
}

/// Aggregate fill across every product quota in one PO, so the list shows how
/// full a batch is without opening it. Derived in the UI from the existing
/// [poQuotaStatusProvider] — no new data is stored for this.
class _QuotaBar extends StatelessWidget {
  const _QuotaBar({required this.quotas});

  final List<PoQuotaStatus> quotas;

  @override
  Widget build(BuildContext context) {
    var filled = 0;
    var quota = 0;
    for (final status in quotas) {
      filled += status.filledQuantity;
      quota += status.quotaQuantity;
    }
    if (quota <= 0) return const SizedBox.shrink();

    // Orders are deliberately not blocked at quota (erp.md B.2), so the ratio
    // can exceed 1 — clamp it so the bar stays readable when that happens.
    final ratio = (filled / quota).clamp(0.0, 1.0);
    final isFull = filled >= quota;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$filled/$quota terisi${isFull ? ' · penuh' : ''}',
          style: Theme.of(context).textTheme.labelSmall
              ?.copyWith(color: isFull ? AppColors.warning : null),
        ),
        const SizedBox(height: AppSpacing.xs),
        LinearProgressIndicator(
          value: ratio,
          minHeight: 4,
          borderRadius: AppRadius.smRadius,
          color: isFull ? AppColors.warning : AppColors.success,
        ),
      ],
    );
  }
}
