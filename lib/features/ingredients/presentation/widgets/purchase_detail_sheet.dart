import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/money/rupiah_formatter.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/sheet_scaffold.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../../data/local/app_database.dart';
import '../../application/ingredient_providers.dart';
import '../../domain/ingredient_unit_label.dart';

/// Membuka modal bottom sheet rincian detail satu transaksi pembelian.
Future<void> showPurchaseDetailSheet(
  BuildContext context, {
  required Ingredient ingredient,
  required IngredientPurchase purchase,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) =>
        PurchaseDetailSheet(ingredient: ingredient, purchase: purchase),
  );
}

class PurchaseDetailSheet extends ConsumerWidget {
  const PurchaseDetailSheet({
    required this.ingredient,
    required this.purchase,
    super.key,
  });

  final Ingredient ingredient;
  final IngredientPurchase purchase;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
    final timeFormat = DateFormat('HH:mm', 'id_ID');
    final createdFormat = DateFormat('d MMM yyyy, HH:mm', 'id_ID');

    final unit = ingredient.unit;
    final unitPrice = purchase.totalPriceRupiah / purchase.quantity;
    final secondaryCost = unit.secondaryCost(unitPrice);
    final secondaryLabel = unit.secondaryUnitLabel;

    final batchAsync = purchase.batchId == null
        ? null
        : ref.watch(purchaseBatchByIdProvider(purchase.batchId!));

    return SheetScaffold(
      title: 'Rincian Pembelian Bahan',
      subtitle: ingredient.name,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner Tanggal & Waktu
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateFormat.format(purchase.purchasedAt),
                        style: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Pukul ${timeFormat.format(purchase.purchasedAt)} WIB',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (purchase.batchId != null)
                  const StatusChip(
                    label: 'Batch Borongan',
                    color: Colors.deepPurple,
                  )
                else
                  const StatusChip(
                    label: 'Pembelian Satuan',
                    color: Colors.teal,
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Detail Kuantitas & Harga
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  _DetailRow(
                    label: 'Jumlah Dibeli',
                    value: unit.formatStockWithConversion(purchase.quantity),
                    isBold: true,
                  ),
                  const Divider(),
                  _DetailRow(
                    label: 'Total Biaya Pembelian',
                    value: RupiahFormatter.format(purchase.totalPriceRupiah),
                    isBold: true,
                    valueColor: Theme.of(context).colorScheme.primary,
                  ),
                  const Divider(),
                  _DetailRow(
                    label: 'Harga per ${unit.shortLabel}',
                    value: RupiahFormatter.format(unitPrice.round()),
                  ),
                  if (secondaryCost != null && secondaryLabel != null) ...[
                    const Divider(),
                    _DetailRow(
                      label: 'Harga ekuivalen / $secondaryLabel',
                      value: RupiahFormatter.format(secondaryCost.round()),
                      isHighlighted: true,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Informasi Lokasi & Toko
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(
                    label: 'Toko / Pasar / Supplier',
                    value: purchase.storeName?.trim().isNotEmpty == true
                        ? purchase.storeName!
                        : 'Tidak dicantumkan',
                  ),
                  const Divider(),
                  _DetailRow(
                    label: 'Dicatat ke Sistem',
                    value: createdFormat.format(purchase.createdAt),
                  ),
                ],
              ),
            ),
          ),

          // Informasi Batch Borongan (jika pembelian bagian dari belanja borongan)
          if (batchAsync != null) ...[
            const SizedBox(height: AppSpacing.md),
            batchAsync.when(
              data: (batch) {
                if (batch == null) return const SizedBox.shrink();
                return Card(
                  color: Theme.of(context).colorScheme.primaryContainer
                      .withValues(alpha: 0.25),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.shopping_bag_outlined,
                              size: 18,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              'Bagian dari Batch Belanja #${batch.id}',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Total belanja batch: ${RupiahFormatter.format(batch.totalPriceRupiah)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (batch.note != null &&
                            batch.note!.trim().isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Catatan: "${batch.note}"',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ],

          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.isHighlighted = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool isBold;
  final bool isHighlighted;
  final Color? valueColor;

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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isHighlighted
                    ? Theme.of(context).colorScheme.primary
                    : null,
                fontWeight: isHighlighted ? FontWeight.w600 : null,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            value,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isBold || isHighlighted ? FontWeight.bold : null,
              color:
                  valueColor ??
                  (isHighlighted
                      ? Theme.of(context).colorScheme.primary
                      : null),
            ),
          ),
        ],
      ),
    );
  }
}
