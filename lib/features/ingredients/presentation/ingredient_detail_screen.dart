import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/money/rupiah_formatter.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../data/local/app_database.dart';
import '../application/ingredient_providers.dart';
import 'ingredient_list_screen.dart' show formatQuantity;
import 'widgets/ingredient_unit_label.dart';

class IngredientDetailScreen extends ConsumerWidget {
  const IngredientDetailScreen({required this.ingredientId, super.key});

  final int ingredientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredientAsync = ref.watch(ingredientByIdProvider(ingredientId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Bahan Baku'),
        actions: [
          ingredientAsync.maybeWhen(
            data: (ingredient) => ingredient == null
                ? const SizedBox.shrink()
                : IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Ubah',
                    onPressed: () => context.push(
                      '/ingredients/${ingredient.id}/edit',
                      extra: ingredient,
                    ),
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: AsyncValueView(
        value: ingredientAsync,
        data: (context, ingredient) {
          if (ingredient == null) {
            return const EmptyState(message: 'Bahan baku tidak ditemukan.');
          }
          return _IngredientDetailBody(ingredient: ingredient);
        },
      ),
      floatingActionButton: ingredientAsync.maybeWhen(
        data: (ingredient) => ingredient == null
            ? null
            : FloatingActionButton.extended(
                onPressed: () => context.push(
                  '/ingredients/${ingredient.id}/purchases/new',
                  extra: ingredient,
                ),
                icon: const Icon(Icons.add_shopping_cart_outlined),
                label: const Text('Catat Pembelian'),
              ),
        orElse: () => null,
      ),
    );
  }
}

class _IngredientDetailBody extends ConsumerWidget {
  const _IngredientDetailBody({required this.ingredient});

  final Ingredient ingredient;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchases = ref.watch(ingredientPurchasesProvider(ingredient.id));
    final dateFormat = DateFormat('d MMM yyyy', 'id_ID');

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                _StatRow(
                  label: 'Stok saat ini',
                  value:
                      '${formatQuantity(ingredient.currentStock)} '
                      '${ingredient.unit.shortLabel}',
                ),
                _StatRow(
                  label: 'Harga modal / ${ingredient.unit.shortLabel}',
                  value: RupiahFormatter.format(
                    ingredient.currentCostPerUnit.round(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Riwayat Pembelian',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        AsyncValueView(
          value: purchases,
          data: (context, items) {
            if (items.isEmpty) {
              return const EmptyState(
                message: 'Belum ada riwayat pembelian untuk bahan ini.',
                icon: Icons.receipt_long_outlined,
              );
            }
            return Column(
              children: items
                  .map(
                    (purchase) => Card(
                      child: ListTile(
                        title: Text(
                          '${formatQuantity(purchase.quantity)} '
                          '${ingredient.unit.shortLabel} · '
                          '${RupiahFormatter.format(purchase.totalPriceRupiah)}',
                        ),
                        subtitle: Text(
                          [
                            dateFormat.format(purchase.purchasedAt),
                            if (purchase.storeName != null)
                              purchase.storeName!,
                          ].join(' · '),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
