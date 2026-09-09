import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/app_database.dart';
import '../../../data/local/database_provider.dart';
import '../data/ingredient_repository.dart';
import '../data/ingredient_repository_impl.dart';
import '../domain/daily_purchase_group.dart';
import '../domain/ingredient_usage_models.dart';

final ingredientRepositoryProvider = Provider<IngredientRepository>((ref) {
  return IngredientRepositoryImpl(ref.watch(appDatabaseProvider));
});

final ingredientListProvider = StreamProvider<List<Ingredient>>((ref) {
  return ref.watch(ingredientRepositoryProvider).watchAll();
});

final ingredientByIdProvider = StreamProvider.family<Ingredient?, int>((
  ref,
  id,
) {
  return ref.watch(ingredientRepositoryProvider).watchById(id);
});

final ingredientPurchasesProvider =
    StreamProvider.family<List<IngredientPurchase>, int>((ref, ingredientId) {
      return ref
          .watch(ingredientRepositoryProvider)
          .watchPurchases(ingredientId);
    });

final ingredientCategoriesProvider = StreamProvider<List<IngredientCategory>>((
  ref,
) {
  return ref.watch(ingredientRepositoryProvider).watchCategories();
});

final purchaseBatchesProvider = StreamProvider<List<PurchaseBatch>>((ref) {
  return ref.watch(ingredientRepositoryProvider).watchPurchaseBatches();
});

/// Kategori yang sedang dipilih di layar Master Bahan Baku. `null` = semua.
class IngredientCategoryFilter extends Notifier<int?> {
  @override
  int? build() => null;

  void select(int? categoryId) => state = categoryId;
}

final ingredientCategoryFilterProvider =
    NotifierProvider<IngredientCategoryFilter, int?>(
      IngredientCategoryFilter.new,
    );

/// Status stok untuk filter Master Bahan Baku
enum StockStatusFilter {
  all('Semua Stok'),
  available('Tersedia'),
  outOfStock('Stok Habis');

  const StockStatusFilter(this.label);
  final String label;
}

/// Opsi pengurutan (sorting) Master Bahan Baku
enum IngredientSortOption {
  nameAsc('Nama (A-Z)'),
  nameDesc('Nama (Z-A)'),
  stockDesc('Stok Terbanyak'),
  stockAsc('Stok Tersedikit'),
  costDesc('Modal Tertinggi'),
  costAsc('Modal Terendah');

  const IngredientSortOption(this.label);
  final String label;
}

/// Filter resep yang sedang dipilih. `null` = semua bahan, `-1` = bahan tanpa resep, `productId` = bahan yang dipakai oleh produk tsb.
class IngredientRecipeFilter extends Notifier<int?> {
  @override
  int? build() => null;

  void select(int? recipeId) => state = recipeId;
}

final ingredientRecipeFilterProvider =
    NotifierProvider<IngredientRecipeFilter, int?>(IngredientRecipeFilter.new);

/// Filter status stok yang sedang dipilih.
class IngredientStockStatusFilter extends Notifier<StockStatusFilter> {
  @override
  StockStatusFilter build() => StockStatusFilter.all;

  void select(StockStatusFilter filter) => state = filter;
}

final ingredientStockStatusFilterProvider =
    NotifierProvider<IngredientStockStatusFilter, StockStatusFilter>(
      IngredientStockStatusFilter.new,
    );

/// Opsi sorting yang sedang dipilih.
class IngredientSortOptionNotifier extends Notifier<IngredientSortOption> {
  @override
  IngredientSortOption build() => IngredientSortOption.nameAsc;

  void select(IngredientSortOption option) => state = option;
}

final ingredientSortOptionProvider =
    NotifierProvider<IngredientSortOptionNotifier, IngredientSortOption>(
      IngredientSortOptionNotifier.new,
    );

/// Kata kunci pencarian nama bahan di layar Master Bahan Baku.
class IngredientSearchQuery extends Notifier<String> {
  @override
  String build() => '';

  void update(String query) => state = query;
}

final ingredientSearchQueryProvider =
    NotifierProvider<IngredientSearchQuery, String>(IngredientSearchQuery.new);

/// Daftar bahan setelah disaring kategori, resep, status stok, pencarian, dan diurutkan.
final filteredIngredientListProvider = StreamProvider<List<Ingredient>>((ref) {
  final categoryId = ref.watch(ingredientCategoryFilterProvider);
  final query = ref.watch(ingredientSearchQueryProvider);
  final recipeFilter = ref.watch(ingredientRecipeFilterProvider);
  final stockStatus = ref.watch(ingredientStockStatusFilterProvider);
  final sortOption = ref.watch(ingredientSortOptionProvider);

  return ref
      .watch(ingredientRepositoryProvider)
      .watchFiltered(
        categoryId: categoryId,
        query: query,
        recipeProductId: recipeFilter,
        stockStatus: stockStatus,
        sortOption: sortOption,
      );
});

/// Pemilahan riwayat pembelian harian: pembelian hari ini vs ringkasan card 1 hari sebelumnya.
final groupedIngredientPurchasesProvider =
    Provider.family<AsyncValue<GroupedPurchases>, int>((ref, ingredientId) {
      final purchasesAsync = ref.watch(
        ingredientPurchasesProvider(ingredientId),
      );
      return purchasesAsync.whenData(
        (purchases) => groupPurchasesByDay(purchases),
      );
    });

/// Rincian resep menu aktif yang menggunakan bahan baku ini.
final ingredientActiveRecipesProvider =
    StreamProvider.family<List<IngredientRecipeUsage>, int>((
      ref,
      ingredientId,
    ) {
      return ref
          .watch(ingredientRepositoryProvider)
          .watchRecipesUsingIngredient(ingredientId);
    });

/// Riwayat pemakaian bahan baku dalam sesi produksi PO.
final ingredientProductionUsagesProvider =
    StreamProvider.family<List<IngredientProductionUsage>, int>((
      ref,
      ingredientId,
    ) {
      return ref
          .watch(ingredientRepositoryProvider)
          .watchProductionUsages(ingredientId);
    });

/// Detail data batch belanja borongan berdasarkan id.
final purchaseBatchByIdProvider = FutureProvider.family<PurchaseBatch?, int>((
  ref,
  batchId,
) {
  return ref.watch(ingredientRepositoryProvider).getPurchaseBatch(batchId);
});

/// Nama kategori untuk suatu ID kategori.
final ingredientCategoryNameProvider = Provider.family<String?, int?>((
  ref,
  categoryId,
) {
  if (categoryId == null) return null;
  final categories = ref.watch(ingredientCategoriesProvider).asData?.value;
  if (categories == null) return null;
  for (final cat in categories) {
    if (cat.id == categoryId) return cat.name;
  }
  return null;
});
