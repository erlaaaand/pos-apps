import '../domain/ingredient_bottleneck.dart';
import '../domain/ingredient_price_point.dart';
import '../domain/menu_performance.dart';
import '../domain/po_slot_performance.dart';
import '../domain/weekly_product_sales.dart';

/// Read-only aggregation queries for Bagian C. "Market" here means the
/// business's own order/sales history, not external market research — the
/// app has no outside data source to compare against.
abstract interface class AnalyticsRepository {
  Future<List<WeeklyProductSales>> weeklySalesTrend();

  Future<List<PoSlotPerformance>> poSlotPerformance();

  Future<List<MenuPerformance>> menuPerformance();

  Future<List<IngredientBottleneck>> cancellationBottlenecks();

  Future<List<IngredientPricePoint>> ingredientPriceTrend();
}
