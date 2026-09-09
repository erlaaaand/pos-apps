import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/money/rupiah_formatter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../application/product_providers.dart';
import '../domain/product_with_active_recipe.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsWithActiveRecipeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Master Produk & Resep')),
      body: AsyncValueView(
        value: products,
        onRetry: () => ref.invalidate(productsWithActiveRecipeProvider),
        data: (context, items) {
          if (items.isEmpty) {
            return EmptyState(
              message:
                  'Belum ada produk. Tambahkan produk beserta resepnya — '
                  'bahan yang dipakai harus sudah terdaftar di Master Bahan Baku.',
              icon: Icons.set_meal_outlined,
              action: FilledButton.icon(
                onPressed: () => context.push('/products/new'),
                icon: const Icon(Icons.add),
                label: const Text('Tambah Produk'),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) => _ProductTile(entry: items[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_product_list',
        onPressed: () => context.push('/products/new'),
        tooltip: 'Tambah Produk',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.entry});

  final ProductWithActiveRecipe entry;

  @override
  Widget build(BuildContext context) {
    final product = entry.product;
    final recipe = entry.recipe;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isActive = product.isActive;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/products/${product.id}'),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 2,
          ),
          child: Row(
            children: [
              // Icon badge
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: (isActive ? AppColors.primary : AppColors.neutral)
                      .withValues(alpha: 0.12),
                  borderRadius: AppRadius.smRadius,
                ),
                child: Icon(
                  Icons.set_meal_outlined,
                  color: isActive ? AppColors.primary : AppColors.neutral,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Name + status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: tt.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color:
                            (isActive ? AppColors.success : AppColors.neutral)
                                .withValues(alpha: 0.12),
                        borderRadius: AppRadius.smRadius,
                      ),
                      child: Text(
                        isActive ? 'Aktif' : 'Nonaktif',
                        style: tt.labelSmall?.copyWith(
                          color: isActive
                              ? AppColors.success
                              : AppColors.neutral,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Selling price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    RupiahFormatter.format(recipe.sellingPriceRupiah),
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    '/ porsi',
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(Icons.chevron_right, size: 18, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
