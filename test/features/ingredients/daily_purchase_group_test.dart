import 'package:dapur_kelaris/data/local/app_database.dart';
import 'package:dapur_kelaris/features/ingredients/domain/daily_purchase_group.dart';
import 'package:dapur_kelaris/features/ingredients/domain/ingredient_unit_label.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('groupPurchasesByDay', () {
    final now = DateTime(2026, 9, 9, 15, 30);

    IngredientPurchase makePurchase({
      required int id,
      required double quantity,
      required int totalPriceRupiah,
      required DateTime purchasedAt,
      String? storeName,
      int? batchId,
    }) {
      return IngredientPurchase(
        id: id,
        ingredientId: 1,
        batchId: batchId,
        quantity: quantity,
        totalPriceRupiah: totalPriceRupiah,
        storeName: storeName,
        purchasedAt: purchasedAt,
        createdAt: purchasedAt,
      );
    }

    test('separates today purchases from past daily groups', () {
      final purchases = [
        makePurchase(
          id: 1,
          quantity: 2.0,
          totalPriceRupiah: 40000,
          purchasedAt: DateTime(2026, 9, 9, 10, 0),
        ),
        makePurchase(
          id: 2,
          quantity: 1.5,
          totalPriceRupiah: 30000,
          purchasedAt: DateTime(2026, 9, 9, 14, 0),
        ),
        makePurchase(
          id: 3,
          quantity: 5.0,
          totalPriceRupiah: 90000,
          purchasedAt: DateTime(2026, 9, 8, 9, 0),
        ),
        makePurchase(
          id: 4,
          quantity: 3.0,
          totalPriceRupiah: 60000,
          purchasedAt: DateTime(2026, 9, 7, 11, 0),
        ),
      ];

      final grouped = groupPurchasesByDay(purchases, now: now);

      expect(grouped.todayPurchases.length, 2);
      expect(grouped.todayPurchases[0].id, 2); // newest first (14:00)
      expect(grouped.todayPurchases[1].id, 1); // 10:00

      expect(grouped.pastDailyGroups.length, 2);
      expect(grouped.pastDailyGroups[0].date, DateTime(2026, 9, 8));
      expect(grouped.pastDailyGroups[0].purchases.length, 1);
      expect(grouped.pastDailyGroups[0].totalQuantity, 5.0);
      expect(grouped.pastDailyGroups[0].totalCostRupiah, 90000);
      expect(grouped.pastDailyGroups[0].averageCostPerUnit, 18000.0);

      expect(grouped.pastDailyGroups[1].date, DateTime(2026, 9, 7));
      expect(grouped.pastDailyGroups[1].purchases.length, 1);
      expect(grouped.pastDailyGroups[1].totalQuantity, 3.0);
      expect(grouped.pastDailyGroups[1].totalCostRupiah, 60000);

      expect(grouped.totalTransactions, 4);
      expect(grouped.totalAllTimeQuantity, 11.5);
      expect(grouped.totalAllTimeCostRupiah, 220000);
    });

    test('multiple purchases on the same past day are packed into 1 group', () {
      final purchases = [
        makePurchase(
          id: 1,
          quantity: 1.0,
          totalPriceRupiah: 20000,
          purchasedAt: DateTime(2026, 9, 8, 8, 30),
        ),
        makePurchase(
          id: 2,
          quantity: 2.0,
          totalPriceRupiah: 40000,
          purchasedAt: DateTime(2026, 9, 8, 16, 45),
        ),
      ];

      final grouped = groupPurchasesByDay(purchases, now: now);

      expect(grouped.todayPurchases, isEmpty);
      expect(grouped.pastDailyGroups.length, 1);

      final group = grouped.pastDailyGroups.first;
      expect(group.date, DateTime(2026, 9, 8));
      expect(group.transactionCount, 2);
      expect(group.totalQuantity, 3.0);
      expect(group.totalCostRupiah, 60000);
      expect(group.averageCostPerUnit, 20000.0);
      expect(group.purchases.first.id, 2); // 16:45 first
    });

    test('returns empty lists when there are no purchases', () {
      final grouped = groupPurchasesByDay([], now: now);
      expect(grouped.todayPurchases, isEmpty);
      expect(grouped.pastDailyGroups, isEmpty);
      expect(grouped.totalTransactions, 0);
      expect(grouped.totalAllTimeQuantity, 0.0);
      expect(grouped.totalAllTimeCostRupiah, 0);
    });
  });

  group('IngredientUnit conversion and formatting', () {
    test('converts gram to kg for stock and cost per kg', () {
      const unit = IngredientUnit.gram;

      final stockFormatted = unit.formatStockWithConversion(2500);
      expect(stockFormatted, '2500 gram (2.5 kg)');

      final costPerKg = unit.costPerKg(50);
      expect(costPerKg, 50000.0);

      final secondaryCost = unit.secondaryCost(50);
      expect(secondaryCost, 50000.0);
      expect(unit.secondaryUnitLabel, 'kg');
    });

    test('converts kilogram to gram for stock and cost', () {
      const unit = IngredientUnit.kilogram;

      final stockFormatted = unit.formatStockWithConversion(3.5);
      expect(stockFormatted, '3.5 kg (3500 gram)');

      final costPerKg = unit.costPerKg(60000);
      expect(costPerKg, 60000.0);

      final secondaryCost = unit.secondaryCost(60000);
      expect(secondaryCost, 60.0);
      expect(unit.secondaryUnitLabel, 'gram');
    });

    test('converts milliliter to liter for stock and cost', () {
      const unit = IngredientUnit.milliliter;

      final stockFormatted = unit.formatStockWithConversion(1500);
      expect(stockFormatted, '1500 ml (1.5 liter)');

      final costPerLiter = unit.costPerKg(25); // volume uses same basis
      expect(costPerLiter, 25000.0);
      expect(unit.secondaryUnitLabel, 'liter');
    });

    test('formats discrete units without unit conversion', () {
      const unit = IngredientUnit.pcs;

      expect(unit.formatStockWithConversion(10), '10 pcs');
      expect(unit.costPerKg(5000), isNull);
      expect(unit.secondaryCost(5000), isNull);
      expect(unit.secondaryUnitLabel, isNull);
    });
  });
}
