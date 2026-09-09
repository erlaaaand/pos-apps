import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../products/application/product_providers.dart';
import '../../application/ingredient_providers.dart';

class IngredientFilterSheet extends ConsumerWidget {
  const IngredientFilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortOption = ref.watch(ingredientSortOptionProvider);
    final stockStatus = ref.watch(ingredientStockStatusFilterProvider);
    final recipeFilter = ref.watch(ingredientRecipeFilterProvider);
    final productsAsync = ref.watch(productsWithActiveRecipeProvider);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.xs,
                ),
                child: Row(
                  children: [
                    Text(
                      'Filter & Urutkan Bahan',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        ref
                            .read(ingredientSortOptionProvider.notifier)
                            .select(IngredientSortOption.nameAsc);
                        ref
                            .read(ingredientStockStatusFilterProvider.notifier)
                            .select(StockStatusFilter.all);
                        ref
                            .read(ingredientRecipeFilterProvider.notifier)
                            .select(null);
                      },
                      child: const Text('Reset'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    // --- Urutkan ---
                    Text(
                      'Urutkan Berdasarkan',
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: IngredientSortOption.values.map((option) {
                        final selected = sortOption == option;
                        return ChoiceChip(
                          label: Text(option.label),
                          selected: selected,
                          onSelected: (val) {
                            if (val) {
                              ref
                                  .read(ingredientSortOptionProvider.notifier)
                                  .select(option);
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // --- Status Stok ---
                    Text(
                      'Status Stok',
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: StockStatusFilter.values.map((status) {
                        final selected = stockStatus == status;
                        return ChoiceChip(
                          label: Text(status.label),
                          selected: selected,
                          onSelected: (val) {
                            if (val) {
                              ref
                                  .read(
                                    ingredientStockStatusFilterProvider
                                        .notifier,
                                  )
                                  .select(status);
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // --- Filter Penggunaan Resep ---
                    Text(
                      'Penggunaan Resep / Menu',
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        ChoiceChip(
                          label: const Text('Semua Bahan'),
                          selected: recipeFilter == null,
                          onSelected: (val) {
                            if (val) {
                              ref
                                  .read(ingredientRecipeFilterProvider.notifier)
                                  .select(null);
                            }
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Tidak Ada Resep'),
                          selected: recipeFilter == -1,
                          onSelected: (val) {
                            if (val) {
                              ref
                                  .read(ingredientRecipeFilterProvider.notifier)
                                  .select(-1);
                            }
                          },
                        ),
                        ...productsAsync.maybeWhen(
                          data: (products) => products.map((item) {
                            final selected = recipeFilter == item.product.id;
                            return ChoiceChip(
                              label: Text(item.product.name),
                              selected: selected,
                              onSelected: (val) {
                                ref
                                    .read(
                                      ingredientRecipeFilterProvider.notifier,
                                    )
                                    .select(val ? item.product.id : null);
                              },
                            );
                          }),
                          orElse: () => [],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Terapkan Filter'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

void showIngredientFilterSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => const IngredientFilterSheet(),
  );
}
