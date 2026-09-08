import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/database_provider.dart';
import '../data/analytics_repository.dart';
import '../data/analytics_repository_impl.dart';
import '../domain/ingredient_bottleneck.dart';
import '../domain/ingredient_price_point.dart';
import '../domain/menu_performance.dart';
import '../domain/po_slot_performance.dart';
import '../domain/weekly_product_sales.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepositoryImpl(ref.watch(appDatabaseProvider));
});

final weeklySalesTrendProvider = FutureProvider<List<WeeklyProductSales>>((
  ref,
) {
  return ref.watch(analyticsRepositoryProvider).weeklySalesTrend();
});

final poSlotPerformanceProvider = FutureProvider<List<PoSlotPerformance>>((
  ref,
) {
  return ref.watch(analyticsRepositoryProvider).poSlotPerformance();
});

final menuPerformanceProvider = FutureProvider<List<MenuPerformance>>((ref) {
  return ref.watch(analyticsRepositoryProvider).menuPerformance();
});

final cancellationBottlenecksProvider =
    FutureProvider<List<IngredientBottleneck>>((ref) {
      return ref.watch(analyticsRepositoryProvider).cancellationBottlenecks();
    });

final ingredientPriceTrendProvider =
    FutureProvider<List<IngredientPricePoint>>((ref) {
      return ref.watch(analyticsRepositoryProvider).ingredientPriceTrend();
    });
