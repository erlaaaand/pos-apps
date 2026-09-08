import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/money/rupiah_formatter.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../data/local/app_database.dart';
import '../../ingredients/presentation/widgets/ingredient_unit_label.dart';
import '../application/product_providers.dart';
import '../domain/recipe_item_detail.dart';
import 'recipe_form_screen.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({required this.productId, super.key});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productByIdProvider(productId));
    final recipeAsync = ref.watch(activeRecipeForProductProvider(productId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        actions: [
          productAsync.maybeWhen(
            data: (product) => product == null
                ? const SizedBox.shrink()
                : Switch(
                    value: product.isActive,
                    onChanged: (value) => ref
                        .read(recipeRepositoryProvider)
                        .setProductActive(product.id, isActive: value),
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: AsyncValueView(
        value: productAsync,
        data: (context, product) {
          if (product == null) {
            return const EmptyState(message: 'Produk tidak ditemukan.');
          }
          return AsyncValueView(
            value: recipeAsync,
            data: (context, recipe) {
              if (recipe == null) {
                return const EmptyState(
                  message: 'Produk ini belum punya resep aktif.',
                );
              }
              return _ProductDetailBody(recipe: recipe);
            },
          );
        },
      ),
      floatingActionButton: productAsync.maybeWhen(
        data: (product) {
          if (product == null) return null;
          return FloatingActionButton.extended(
            onPressed: () async {
              final recipe = await ref.read(
                activeRecipeForProductProvider(productId).future,
              );
              final items = recipe == null
                  ? const <RecipeItemDetail>[]
                  : await ref.read(recipeItemsProvider(recipe.id).future);
              if (!context.mounted) return;
              context.push(
                '/products/${product.id}/new-recipe',
                extra: RecipeFormArgs(
                  existingProduct: product,
                  prefillItems: items,
                  prefillSellingPriceRupiah: recipe?.sellingPriceRupiah,
                ),
              );
            },
            icon: const Icon(Icons.receipt_long_outlined),
            label: const Text('Resep Baru'),
          );
        },
        orElse: () => null,
      ),
    );
  }
}

class _ProductDetailBody extends ConsumerWidget {
  const _ProductDetailBody({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(recipeItemsProvider(recipe.id));
    final dateFormat = DateFormat('d MMM yyyy', 'id_ID');

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AsyncValueView(
              value: itemsAsync,
              data: (context, items) {
                final hpp = items.fold<double>(0, (sum, item) => sum + item.lineCost);
                final margin = recipe.sellingPriceRupiah - hpp;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatRow(
                      label: 'Harga Jual',
                      value: RupiahFormatter.format(recipe.sellingPriceRupiah),
                    ),
                    _StatRow(
                      label: 'HPP (estimasi saat ini)',
                      value: RupiahFormatter.format(hpp.round()),
                    ),
                    _StatRow(
                      label: 'Margin',
                      value: RupiahFormatter.format(margin.round()),
                      emphasize: true,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Bahan & Takaran', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        AsyncValueView(
          value: itemsAsync,
          data: (context, items) => Column(
            children: items
                .map(
                  (item) => Card(
                    child: ListTile(
                      title: Text(item.ingredientName),
                      subtitle: Text(
                        '${_formatQuantity(item.quantityPerBatch)} ${item.unit.shortLabel}',
                      ),
                      trailing: Text(RupiahFormatter.format(item.lineCost.round())),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Riwayat Resep', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Consumer(
          builder: (context, ref, _) {
            final historyAsync = ref.watch(recipeHistoryProvider(recipe.productId));
            return AsyncValueView(
              value: historyAsync,
              data: (context, history) => Column(
                children: history
                    .map(
                      (version) => Card(
                        child: ListTile(
                          title: Text(RupiahFormatter.format(version.sellingPriceRupiah)),
                          subtitle: Text(dateFormat.format(version.createdAt)),
                          trailing: version.isActive
                              ? const Chip(label: Text('Aktif'))
                              : const Text('Nonaktif'),
                        ),
                      ),
                    )
                    .toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  String _formatQuantity(double quantity) {
    return quantity == quantity.roundToDouble()
        ? quantity.toStringAsFixed(0)
        : quantity.toStringAsFixed(2);
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value, this.emphasize = false});

  final String label;
  final String value;
  final bool emphasize;

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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: emphasize ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}
