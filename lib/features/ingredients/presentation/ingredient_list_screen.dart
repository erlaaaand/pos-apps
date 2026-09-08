import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/money/rupiah_formatter.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../data/local/app_database.dart';
import '../application/ingredient_providers.dart';
import 'widgets/ingredient_unit_label.dart';

class IngredientListScreen extends ConsumerWidget {
  const IngredientListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredients = ref.watch(ingredientListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Master Bahan Baku')),
      body: AsyncValueView(
        value: ingredients,
        onRetry: () => ref.invalidate(ingredientListProvider),
        data: (context, items) {
          if (items.isEmpty) {
            return EmptyState(
              message:
                  'Belum ada bahan baku. Tambahkan bahan baku dulu sebelum '
                  'bisa mencatat pembelian atau membuat resep.',
              icon: Icons.inventory_2_outlined,
              action: FilledButton.icon(
                onPressed: () => context.push('/ingredients/new'),
                icon: const Icon(Icons.add),
                label: const Text('Tambah Bahan Baku'),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final ingredient = items[index];
              return _IngredientTile(ingredient: ingredient);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/ingredients/new'),
        tooltip: 'Tambah Bahan Baku',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _IngredientTile extends StatelessWidget {
  const _IngredientTile({required this.ingredient});

  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => context.push('/ingredients/${ingredient.id}'),
        title: Text(ingredient.name),
        subtitle: Text(
          'Stok: ${formatQuantity(ingredient.currentStock)} '
          '${ingredient.unit.shortLabel}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              RupiahFormatter.format(ingredient.currentCostPerUnit.round()),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '/ ${ingredient.unit.shortLabel}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

/// Trims trailing zeros so whole quantities don't show as "2.0".
String formatQuantity(double quantity) {
  if (quantity == quantity.roundToDouble()) {
    return quantity.toStringAsFixed(0);
  }
  return quantity.toStringAsFixed(2);
}
