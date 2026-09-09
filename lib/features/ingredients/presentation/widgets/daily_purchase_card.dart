import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/date/date_only.dart';
import '../../../../core/money/rupiah_formatter.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../../data/local/app_database.dart';
import '../../domain/daily_purchase_group.dart';
import '../../domain/ingredient_unit_label.dart';
import 'purchase_detail_sheet.dart';

/// Card ringkasan harian untuk pembelian bahan baku pada hari-hari sebelumnya.
///
/// Mengemas seluruh transaksi dalam 1 hari kalender ke dalam 1 card accordion
/// (Material ExpansionTile) sehingga riwayat masa lalu tetap ringkas, terorganisir,
/// dan dapat dibuka kapan saja untuk melihat detail setiap transaksi.
class DailyPurchaseCard extends StatelessWidget {
  const DailyPurchaseCard({
    required this.ingredient,
    required this.group,
    super.key,
  });

  final Ingredient ingredient;
  final DailyPurchaseGroup group;

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = dateOnly(now);
    final target = dateOnly(date);
    final diffDays = today.difference(target).inDays;

    final fullDate = DateFormat('EEEE, d MMM yyyy', 'id_ID').format(date);
    if (diffDays == 1) {
      return 'Kemarin · $fullDate';
    } else if (diffDays == 2) {
      return '2 Hari Lalu · $fullDate';
    }
    return fullDate;
  }

  @override
  Widget build(BuildContext context) {
    final unit = ingredient.unit;
    final avgCost = group.averageCostPerUnit;
    final secondaryCost = unit.secondaryCost(avgCost);
    final secondaryLabel = unit.secondaryUnitLabel;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest,
          child: Icon(
            Icons.history,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                _formatDateHeader(group.date),
                style: Theme.of(context).textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            StatusChip(
              label: '${group.transactionCount} transaksi',
              color: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Wrap(
            spacing: AppSpacing.sm,
            runSpacing: 4,
            children: [
              Text(
                'Total: +${unit.formatStockWithConversion(group.totalQuantity)}',
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text('·', style: Theme.of(context).textTheme.bodySmall),
              Text(
                RupiahFormatter.format(group.totalCostRupiah),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              if (secondaryCost != null && secondaryLabel != null) ...[
                Text('·', style: Theme.of(context).textTheme.bodySmall),
                Text(
                  'Rata-rata: ${RupiahFormatter.format(secondaryCost.round())}/$secondaryLabel',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        children: [
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.xs),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: group.purchases.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final purchase = group.purchases[index];
              return _DailyPurchaseItemTile(
                ingredient: ingredient,
                purchase: purchase,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DailyPurchaseItemTile extends StatelessWidget {
  const _DailyPurchaseItemTile({
    required this.ingredient,
    required this.purchase,
  });

  final Ingredient ingredient;
  final IngredientPurchase purchase;

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm', 'id_ID');
    final unit = ingredient.unit;
    final unitPrice = purchase.totalPriceRupiah / purchase.quantity;
    final secondaryCost = unit.secondaryCost(unitPrice);
    final secondaryLabel = unit.secondaryUnitLabel;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => showPurchaseDetailSheet(
        context,
        ingredient: ingredient,
        purchase: purchase,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.xs,
        ),
        child: Row(
          children: [
            Icon(
              Icons.receipt_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Pukul ${timeFormat.format(purchase.purchasedAt)} WIB',
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (purchase.batchId != null) ...[
                        const SizedBox(width: AppSpacing.xs),
                        const StatusChip(
                          label: 'Borongan',
                          color: Colors.deepPurple,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    [
                      'Jumlah: ${unit.formatStockWithConversion(purchase.quantity)}',
                      if (purchase.storeName != null &&
                          purchase.storeName!.trim().isNotEmpty)
                        purchase.storeName!,
                    ].join(' · '),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  RupiahFormatter.format(purchase.totalPriceRupiah),
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  secondaryCost != null && secondaryLabel != null
                      ? '${RupiahFormatter.format(secondaryCost.round())}/$secondaryLabel'
                      : '${RupiahFormatter.format(unitPrice.round())}/${unit.shortLabel}',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: Theme.of(context).colorScheme.outline),
                ),
              ],
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: Theme.of(context).colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }
}
