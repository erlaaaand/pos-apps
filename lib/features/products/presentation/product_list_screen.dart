import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/money/rupiah_formatter.dart';
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
              icon: Icons.restaurant_menu_outlined,
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

    return Card(
      child: ListTile(
        onTap: () => context.push('/products/${product.id}'),
        title: Text(product.name),
        subtitle: Text(product.isActive ? 'Aktif' : 'Nonaktif'),
        trailing: Text(
          RupiahFormatter.format(recipe.sellingPriceRupiah),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
