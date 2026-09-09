import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/money/rupiah_formatter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../data/local/app_database.dart';
import '../application/ingredient_providers.dart';
import '../domain/ingredient_unit_label.dart';
import 'widgets/batch_purchase_sheet.dart';
import 'widgets/ingredient_filter_sheet.dart';
import 'widgets/ingredient_form_sheet.dart';
import 'widgets/ingredient_import_sheet.dart';

class IngredientListScreen extends ConsumerWidget {
  const IngredientListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredients = ref.watch(filteredIngredientListProvider);
    final categoryFilter = ref.watch(ingredientCategoryFilterProvider);
    final recipeFilter = ref.watch(ingredientRecipeFilterProvider);
    final stockStatus = ref.watch(ingredientStockStatusFilterProvider);
    final sortOption = ref.watch(ingredientSortOptionProvider);
    final query = ref.watch(ingredientSearchQueryProvider);

    var activeFilterCount = 0;
    if (categoryFilter != null) activeFilterCount++;
    if (recipeFilter != null) activeFilterCount++;
    if (stockStatus != StockStatusFilter.all) activeFilterCount++;
    if (sortOption != IngredientSortOption.nameAsc) activeFilterCount++;
    if (query.isNotEmpty) activeFilterCount++;
    final hasFilter = activeFilterCount > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Master Bahan Baku'),
        actions: [
          IconButton(
            onPressed: () => showIngredientImportSheet(context),
            tooltip: 'Impor dari Excel',
            icon: const Icon(Icons.upload_file_outlined),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.compact,
              AppSpacing.md,
              0,
            ),
            child: Column(
              children: [
                _SearchRow(activeFilterCount: activeFilterCount),
                const SizedBox(height: AppSpacing.compact),
                const _KpiStrip(),
                const SizedBox(height: AppSpacing.compact),
              ],
            ),
          ),
          const _CategoryChipRow(),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.compact,
              AppSpacing.md,
              AppSpacing.compact,
            ),
            child: const _BelanjaBanner(),
          ),
          Expanded(
            child: AsyncValueView(
              value: ingredients,
              onRetry: () => ref.invalidate(filteredIngredientListProvider),
              data: (context, items) {
                if (items.isEmpty) {
                  return EmptyState(
                    message: hasFilter
                        ? 'Tidak ada bahan yang cocok dengan kriteria filter tsb.'
                        : 'Belum ada bahan baku. Tambahkan bahan baku dulu '
                              'sebelum bisa mencatat pembelian atau membuat '
                              'resep.',
                    icon: Icons.inventory_2_outlined,
                    action: hasFilter
                        ? OutlinedButton.icon(
                            onPressed: () => _clearFilters(ref),
                            icon: const Icon(Icons.filter_alt_off_outlined),
                            label: const Text('Hapus Semua Filter'),
                          )
                        : FilledButton.icon(
                            onPressed: () => showIngredientFormSheet(context),
                            icon: const Icon(Icons.add),
                            label: const Text('Tambah Bahan Baku'),
                          ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    0,
                    AppSpacing.md,
                    AppSpacing.xxl + AppSpacing.lg,
                  ),
                  itemCount: items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm + 2),
                  itemBuilder: (context, index) =>
                      _IngredientTile(ingredient: items[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_ingredient_list',
        onPressed: () => showIngredientFormSheet(context),
        tooltip: 'Tambah Bahan Baku',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _clearFilters(WidgetRef ref) {
    ref.read(ingredientCategoryFilterProvider.notifier).select(null);
    ref.read(ingredientRecipeFilterProvider.notifier).select(null);
    ref
        .read(ingredientStockStatusFilterProvider.notifier)
        .select(StockStatusFilter.all);
    ref
        .read(ingredientSortOptionProvider.notifier)
        .select(IngredientSortOption.nameAsc);
    ref.read(ingredientSearchQueryProvider.notifier).update('');
  }
}

/// Kolom pencarian + tombol filter, mengikuti referensi: keduanya tinggi 44,
/// latar hangat redup, ikon filter berwarna primary.
class _SearchRow extends ConsumerStatefulWidget {
  const _SearchRow({required this.activeFilterCount});

  final int activeFilterCount;

  @override
  ConsumerState<_SearchRow> createState() => _SearchRowState();
}

class _SearchRowState extends ConsumerState<_SearchRow> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(ingredientSearchQueryProvider),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final query = ref.watch(ingredientSearchQueryProvider);

    // Sinkronkan controller kalau kata kunci direset dari luar (mis. tombol
    // "Hapus Semua Filter"), tanpa mengganggu pengetikan yang sedang berjalan.
    if (_controller.text != query) {
      _controller.value = TextEditingValue(
        text: query,
        selection: TextSelection.collapsed(offset: query.length),
      );
    }

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 44,
            child: TextField(
              controller: _controller,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Cari bahan baku...',
                filled: true,
                fillColor: theme.colorScheme.surfaceContainer,
                prefixIcon: Icon(
                  Icons.search,
                  size: 20,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                suffixIcon: query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.cancel, size: 18),
                        tooltip: 'Hapus pencarian',
                        onPressed: () => ref
                            .read(ingredientSearchQueryProvider.notifier)
                            .update(''),
                      ),
                border: const OutlineInputBorder(
                  borderRadius: AppRadius.lgRadius,
                  borderSide: BorderSide.none,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: AppRadius.lgRadius,
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadius.lgRadius,
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
              ),
              onChanged: (value) => ref
                  .read(ingredientSearchQueryProvider.notifier)
                  .update(value),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm + 2),
        Badge(
          isLabelVisible: widget.activeFilterCount > 0,
          label: Text('${widget.activeFilterCount}'),
          child: AppPressable(
            onTap: () => showIngredientFilterSheet(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: AppRadius.lgRadius,
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: const Icon(Icons.tune, size: 20, color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

/// Tiga angka operasional yang bisa dipindai sekilas. Semuanya diturunkan dari
/// data yang benar-benar ada — aplikasi belum punya ambang "stok menipis",
/// jadi metrik itu sengaja tidak ditampilkan alih-alih dikarang.
class _KpiStrip extends ConsumerWidget {
  const _KpiStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(ingredientListProvider).value;
    final categories = ref.watch(ingredientCategoriesProvider).value;

    final total = all?.length;
    final outOfStock = all?.where((i) => i.currentStock <= 0).length;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _KpiCard(
              label: 'Total Bahan',
              value: total == null ? '—' : '$total',
              unit: 'Item',
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _KpiCard(
              label: 'Perlu Belanja',
              value: outOfStock == null ? '—' : '$outOfStock',
              unit: 'Item',
              accent: AppColors.danger,
              showDot: (outOfStock ?? 0) > 0,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _KpiCard(
              label: 'Kategori',
              value: categories == null ? '—' : '${categories.length}',
              unit: 'Grup',
              accent: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.value,
    required this.unit,
    this.accent,
    this.showDot = false,
  });

  final String label;
  final String value;
  final String unit;
  final Color? accent;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tint = accent;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: tint == null
            ? theme.colorScheme.surfaceContainerLowest
            : tint.withValues(alpha: 0.07),
        borderRadius: AppRadius.lgRadius,
        border: Border.all(
          color: tint == null
              ? theme.colorScheme.outlineVariant
              : tint.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: tint ?? theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (showDot)
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tint ?? theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: tint ?? theme.colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 3),
              Text(
                unit,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: (tint ?? theme.colorScheme.onSurfaceVariant)
                      .withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Chip kategori yang bisa digulir mendatar. Chip terpilih memakai latar
/// primary-container plus ikon centang supaya statusnya tak salah baca.
class _CategoryChipRow extends ConsumerWidget {
  const _CategoryChipRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(ingredientCategoriesProvider);
    final selected = ref.watch(ingredientCategoryFilterProvider);

    return categories.maybeWhen(
      orElse: () => const SizedBox.shrink(),
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            children: [
              _CategoryChip(
                label: 'Semua',
                isSelected: selected == null,
                onTap: () => ref
                    .read(ingredientCategoryFilterProvider.notifier)
                    .select(null),
              ),
              for (final category in items)
                _CategoryChip(
                  label: category.name,
                  isSelected: selected == category.id,
                  onTap: () => ref
                      .read(ingredientCategoryFilterProvider.notifier)
                      .select(selected == category.id ? null : category.id),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: AppPressable(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          curve: AppMotion.standard,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryContainer
                : theme.colorScheme.surfaceContainerLowest,
            borderRadius: AppRadius.pillRadius,
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryContainer
                  : theme.colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected) ...[
                const Icon(Icons.check, size: 15, color: Color(0xFF4D2400)),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: isSelected
                      ? const Color(0xFF4D2400)
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Banner aksi cepat untuk mencatat belanja — aksi paling sering di layar ini.
class _BelanjaBanner extends StatelessWidget {
  const _BelanjaBanner();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppPressable(
      onTap: () => showBatchPurchaseSheet(context),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.compact),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryContainer.withValues(alpha: 0.75),
              AppColors.primaryContainer.withValues(alpha: 0.35),
            ],
          ),
          borderRadius: AppRadius.lgRadius,
          border: Border.all(color: AppColors.primaryContainer),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: AppRadius.cardRadius,
              ),
              child: const Icon(
                Icons.shopping_cart_checkout,
                size: 19,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: AppSpacing.compact),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Catat Belanja Hari Ini',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Perbarui stok & harga modal terbaru',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.primaryDark.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward, size: 20, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

/// Baris bahan baku: pita status di kiri, nama + badge + jumlah di tengah,
/// harga modal di kanan.
class _IngredientTile extends StatelessWidget {
  const _IngredientTile({required this.ingredient});

  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOut = ingredient.currentStock <= 0;
    final statusColor = isOut ? AppColors.danger : AppColors.success;

    return AppPressable(
      onTap: () => context.push('/ingredients/${ingredient.id}'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
          borderRadius: AppRadius.lgRadius,
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            // Pita status: penanda cepat yang tidak bergantung pada warna saja
            // karena badge teksnya tetap ada di sebelahnya.
            Container(
              width: 6,
              height: 36,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: AppRadius.pillRadius,
              ),
            ),
            const SizedBox(width: AppSpacing.compact),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          ingredient.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (isOut) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.dangerContainer,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text(
                            'Habis',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.danger,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${formatQuantity(ingredient.currentStock)} '
                    '${ingredient.unit.shortLabel}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  RupiahFormatter.format(ingredient.currentCostPerUnit.round()),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                  ),
                ),
                Text(
                  '/ ${ingredient.unit.shortLabel}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
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
