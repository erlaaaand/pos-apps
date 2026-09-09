import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/money/rupiah_formatter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../data/local/app_database.dart';
import '../application/ingredient_providers.dart';
import '../domain/daily_purchase_group.dart';
import '../domain/ingredient_unit_label.dart';
import '../domain/ingredient_usage_models.dart';
import 'widgets/daily_purchase_card.dart';
import 'widgets/ingredient_form_sheet.dart';
import 'widgets/purchase_detail_sheet.dart';
import 'widgets/purchase_form_sheet.dart';

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
                    tooltip: 'Ubah Data Bahan',
                    onPressed: () =>
                        showIngredientFormSheet(context, editing: ingredient),
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
                heroTag: 'fab_ingredient_detail',
                onPressed: () =>
                    showPurchaseFormSheet(context, ingredient: ingredient),
                icon: const Icon(Icons.add_shopping_cart_outlined),
                label: const Text('Catat Belanja'),
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
    final groupedAsync = ref.watch(
      groupedIngredientPurchasesProvider(ingredient.id),
    );
    final recipesAsync = ref.watch(
      ingredientActiveRecipesProvider(ingredient.id),
    );
    final usagesAsync = ref.watch(
      ingredientProductionUsagesProvider(ingredient.id),
    );
    final categoryName = ref.watch(
      ingredientCategoryNameProvider(ingredient.categoryId),
    );

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        // 1. Kartu Header & Identitas Bahan
        _HeaderCard(ingredient: ingredient, categoryName: categoryName),
        const SizedBox(height: AppSpacing.md),

        // 2. Metrik Detail Stok & Finansial (Sangat Rinci)
        _StockAndFinancialMetrics(
          ingredient: ingredient,
          groupedAsync: groupedAsync,
          usagesAsync: usagesAsync,
        ),
        const SizedBox(height: AppSpacing.lg),

        // 3. Resep Menu Terkait (BOM)
        _ActiveRecipesSection(
          recipesAsync: recipesAsync,
          unitLabel: ingredient.unit.shortLabel,
        ),
        const SizedBox(height: AppSpacing.lg),

        // 4. Pembelian Hari Ini (Segar & Siap Diisi)
        _TodayPurchasesSection(
          ingredient: ingredient,
          groupedAsync: groupedAsync,
        ),
        const SizedBox(height: AppSpacing.lg),

        // 5. Riwayat Pembelian Sebelumnya (Card 1 Hari)
        _PastDailyPurchasesSection(
          ingredient: ingredient,
          groupedAsync: groupedAsync,
        ),
        const SizedBox(height: AppSpacing.lg),

        // 6. Riwayat Pemakaian dalam Produksi PO
        _ProductionUsageSection(
          usagesAsync: usagesAsync,
          unit: ingredient.unit,
        ),
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 1. Kartu Header & Identitas
// ---------------------------------------------------------------------------
class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.ingredient, required this.categoryName});

  final Ingredient ingredient;
  final String? categoryName;

  @override
  Widget build(BuildContext context) {
    final stock = ingredient.currentStock;
    final stockColor = stock <= 0
        ? AppColors.danger
        : stock < 100
        ? AppColors.warning
        : AppColors.success;
    final stockLabel = stock <= 0
        ? 'Stok Habis'
        : stock < 100
        ? 'Stok Menipis'
        : 'Stok Tersedia';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondary, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon badge
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ingredient.name,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                      ),
                      const SizedBox(height: 4),
                      // Stock status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: stockColor.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          stockLabel,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                _InfoChip(
                  icon: Icons.straighten,
                  label: 'Satuan: ${ingredient.unit.label}',
                ),
                if (categoryName != null)
                  _InfoChip(
                    icon: Icons.folder_outlined,
                    label: 'Kategori: $categoryName',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white.withValues(alpha: 0.85)),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. Metrik Detail Stok & Finansial Rinci
// ---------------------------------------------------------------------------
class _StockAndFinancialMetrics extends StatelessWidget {
  const _StockAndFinancialMetrics({
    required this.ingredient,
    required this.groupedAsync,
    required this.usagesAsync,
  });

  final Ingredient ingredient;
  final AsyncValue<GroupedPurchases> groupedAsync;
  final AsyncValue<List<IngredientProductionUsage>> usagesAsync;

  @override
  Widget build(BuildContext context) {
    final unit = ingredient.unit;
    final costPerUnit = ingredient.currentCostPerUnit;
    final secondaryCost = unit.secondaryCost(costPerUnit);
    final secondaryLabel = unit.secondaryUnitLabel;
    final valuationRupiah = (ingredient.currentStock * costPerUnit).round();

    final totalPurchasedQty = groupedAsync.maybeWhen(
      data: (g) => g.totalAllTimeQuantity,
      orElse: () => 0.0,
    );
    final totalSpentRupiah = groupedAsync.maybeWhen(
      data: (g) => g.totalAllTimeCostRupiah,
      orElse: () => 0,
    );
    final totalTransactions = groupedAsync.maybeWhen(
      data: (g) => g.totalTransactions,
      orElse: () => 0,
    );

    final totalUsedQty = usagesAsync.maybeWhen(
      data: (items) => items.fold(0.0, (sum, u) => sum + u.quantityUsed),
      orElse: () => 0.0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informasi Stok & Finansial',
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Baris 1: Stok Saat Ini & Harga Modal / Kg
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.inventory_2_outlined,
                iconColor: AppColors.info,
                title: 'Stok Saat Ini',
                value:
                    '${formatQuantity(ingredient.currentStock)} ${unit.shortLabel}',
                subtitle: unit.formatStockWithConversion(
                  ingredient.currentStock,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _MetricCard(
                icon: Icons.payments_outlined,
                iconColor: AppColors.primary,
                title: 'Harga Modal',
                value: secondaryCost != null && secondaryLabel != null
                    ? '${RupiahFormatter.format(secondaryCost.round())}/$secondaryLabel'
                    : '${RupiahFormatter.format(costPerUnit.round())}/${unit.shortLabel}',
                subtitle: secondaryCost != null
                    ? 'Basis: ${RupiahFormatter.format(costPerUnit.round())}/${unit.shortLabel}'
                    : 'Rata-rata tertimbang',
                highlightValue: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        // Baris 2: Nilai Valuasi Aset Stok
        _MetricCard(
          icon: Icons.account_balance_wallet_outlined,
          iconColor: AppColors.success,
          title: 'Total Valuasi Nilai Persediaan',
          value: RupiahFormatter.format(valuationRupiah),
          subtitle:
              'Kalkulasi: ${formatQuantity(ingredient.currentStock)} ${unit.shortLabel} × ${RupiahFormatter.format(costPerUnit.round())}',
        ),
        const SizedBox(height: AppSpacing.sm),

        // Baris 3: Akumulasi Belanja & Pemakaian
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.shopping_cart_checkout_outlined,
                iconColor: AppColors.secondary,
                title: 'Total Pembelian',
                value: RupiahFormatter.format(totalSpentRupiah),
                subtitle:
                    '$totalTransactions transaksi (${formatQuantity(totalPurchasedQty)} ${unit.shortLabel})',
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _MetricCard(
                icon: Icons.restaurant_outlined,
                iconColor: AppColors.neutral,
                title: 'Total Pemakaian',
                value: '${formatQuantity(totalUsedQty)} ${unit.shortLabel}',
                subtitle: 'Realisasi sesi masak PO',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.subtitle,
    this.highlightValue = false,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String subtitle;
  final bool highlightValue;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: iconColor),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: highlightValue
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: Theme.of(context).colorScheme.outline),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. Resep Menu Terkait
// ---------------------------------------------------------------------------
class _ActiveRecipesSection extends StatelessWidget {
  const _ActiveRecipesSection({
    required this.recipesAsync,
    required this.unitLabel,
  });

  final AsyncValue<List<IngredientRecipeUsage>> recipesAsync;
  final String unitLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Digunakan Pada Resep Menu',
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.sm),
        AsyncValueView(
          value: recipesAsync,
          data: (context, recipes) {
            if (recipes.isEmpty) {
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 20, color: Colors.grey),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Bahan baku ini belum didaftarkan pada resep menu aktif manapun.',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recipes.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = recipes[index];
                  final isKemasan = item.kind == RecipeItemKind.packaging;

                  return ListTile(
                    dense: true,
                    leading: Icon(
                      isKemasan
                          ? Icons.inventory_outlined
                          : Icons.fastfood_outlined,
                      color: isKemasan ? Colors.blueGrey : Colors.orange,
                    ),
                    title: Text(
                      item.productName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      isKemasan ? 'Kategori Kemasan' : 'Bahan Baku Masakan',
                    ),
                    trailing: Text(
                      '${formatQuantity(item.quantity)} $unitLabel / porsi',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 4. Pembelian Hari Ini (Segar & Siap Diisi)
// ---------------------------------------------------------------------------
class _TodayPurchasesSection extends StatelessWidget {
  const _TodayPurchasesSection({
    required this.ingredient,
    required this.groupedAsync,
  });

  final Ingredient ingredient;
  final AsyncValue<GroupedPurchases> groupedAsync;

  @override
  Widget build(BuildContext context) {
    final todayFormatted = DateFormat(
      'EEEE, d MMMM yyyy',
      'id_ID',
    ).format(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pembelian Hari Ini',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    todayFormatted,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        AsyncValueView(
          value: groupedAsync,
          data: (context, grouped) {
            final todayItems = grouped.todayPurchases;

            if (todayItems.isEmpty) {
              return Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: SizedBox(
                  width: double
                      .infinity, // 1. Membuat lebar card seragam (responsive)
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.lg,
                      horizontal: AppSpacing.md,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize
                          .min, // 2. Mencegah Column mengambil tinggi berlebih
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // 3. Memastikan semua elemen rata tengah
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 36,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(
                          height: AppSpacing.sm,
                        ), // 4. Mengganti AppSpacing.xs agar lebih bernafas
                        Text(
                          'Belum Ada Pembelian Hari Ini',
                          textAlign: TextAlign.center, // 5. Memastikan judul selalu rata tengah jika text membungkus (wrap)
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6), // 6. Diperlebar dari 2 menjadi 6 agar tidak terlalu menempel dengan judul
                        Text(
                          'Tampilan segar dan siap menerima pencatatan belanja hari ini.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            // Jika ada belanja hari ini, tampilkan satu per satu secara segar
            return Column(
              children: todayItems.map((purchase) {
                final timeFormat = DateFormat('HH:mm', 'id_ID');
                final unit = ingredient.unit;
                final unitPrice = purchase.totalPriceRupiah / purchase.quantity;
                final secondaryCost = unit.secondaryCost(unitPrice);
                final secondaryLabel = unit.secondaryUnitLabel;

                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: ListTile(
                    onTap: () => showPurchaseDetailSheet(
                      context,
                      ingredient: ingredient,
                      purchase: purchase,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primaryContainer,
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(
                          'Pukul ${timeFormat.format(purchase.purchasedAt)} WIB',
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
                    subtitle: Text(
                      [
                        '+${unit.formatStockWithConversion(purchase.quantity)}',
                        if (purchase.storeName != null &&
                            purchase.storeName!.trim().isNotEmpty)
                          purchase.storeName!,
                      ].join(' · '),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          RupiahFormatter.format(purchase.totalPriceRupiah),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        Text(
                          secondaryCost != null && secondaryLabel != null
                              ? '${RupiahFormatter.format(secondaryCost.round())}/$secondaryLabel'
                              : '${RupiahFormatter.format(unitPrice.round())}/${unit.shortLabel}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 5. Riwayat Pembelian Sebelumnya (Card 1 Hari)
// ---------------------------------------------------------------------------
class _PastDailyPurchasesSection extends StatelessWidget {
  const _PastDailyPurchasesSection({
    required this.ingredient,
    required this.groupedAsync,
  });

  final Ingredient ingredient;
  final AsyncValue<GroupedPurchases> groupedAsync;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Riwayat Pembelian Sebelumnya',
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          'Transaksi hari-hari lalu dikemas dalam card 1 hari (bisa dibuka untuk melihat rincian).',
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.sm),
        AsyncValueView(
          value: groupedAsync,
          data: (context, grouped) {
            final pastGroups = grouped.pastDailyGroups;

            if (pastGroups.isEmpty) {
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Icon(Icons.history, size: 20, color: Colors.grey),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Belum ada riwayat pembelian dari hari-hari sebelumnya.',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: pastGroups.map((group) {
                return DailyPurchaseCard(ingredient: ingredient, group: group);
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 6. Riwayat Pemakaian dalam Produksi PO
// ---------------------------------------------------------------------------
class _ProductionUsageSection extends StatelessWidget {
  const _ProductionUsageSection({
    required this.usagesAsync,
    required this.unit,
  });

  final AsyncValue<List<IngredientProductionUsage>> usagesAsync;
  final IngredientUnit unit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Riwayat Pemakaian Produksi',
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.sm),
        AsyncValueView(
          value: usagesAsync,
          data: (context, usages) {
            if (usages.isEmpty) {
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Icon(
                        Icons.soup_kitchen_outlined,
                        size: 20,
                        color: Colors.grey,
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Belum ada pemakaian bahan pada sesi produksi PO.',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final dateFormat = DateFormat('d MMM yyyy, HH:mm', 'id_ID');

            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: ExpansionTile(
                leading: const Icon(
                  Icons.soup_kitchen_outlined,
                  color: Colors.teal,
                ),
                title: Text(
                  '${usages.length} Sesi Masak Telah Menggunakan Bahan Ini',
                  style: Theme.of(context).textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Total terpakai: ${unit.formatStockWithConversion(usages.fold(0.0, (s, u) => s + u.quantityUsed))}',
                ),
                children: usages.map((usage) {
                  return ListTile(
                    dense: true,
                    title: Text(
                      usage.poLabel ?? 'Sesi Masak #${usage.sessionId}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(dateFormat.format(usage.sessionDate)),
                    trailing: Text(
                      '-${unit.formatStockWithConversion(usage.quantityUsed)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}
