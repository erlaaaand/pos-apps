import 'package:dapur_kelaris/data/local/app_database.dart';
import 'package:dapur_kelaris/features/finance/data/finance_repository_impl.dart';
import 'package:dapur_kelaris/features/finance/domain/finance_models.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// Bagian E + laporan finansial Bagian C. Semua angka diturunkan dari data
/// harian yang sudah ada, jadi tes ini menyemai tabel sumbernya langsung.
void main() {
  late AppDatabase db;
  late FinanceRepositoryImpl repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = FinanceRepositoryImpl(db);
  });

  tearDown(() => db.close());

  Future<void> addCapital(CapitalEntryKind kind, int amount) async {
    await repository.addCapitalEntry(
      kind: kind,
      amountRupiah: amount,
      recordedAt: DateTime(2026, 1, 1),
    );
  }

  Future<void> addClosing({
    required DateTime date,
    int revenue = 0,
    int hpp = 0,
    int operational = 0,
    int waste = 0,
  }) async {
    await db
        .into(db.dailyClosings)
        .insert(
          DailyClosingsCompanion.insert(
            date: date,
            totalRevenueRupiah: revenue,
            totalHppRupiah: hpp,
            totalOperationalCostRupiah: operational,
            totalWasteCostRupiah: waste,
            netProfitRupiah: revenue - hpp - operational - waste,
          ),
        );
  }

  Future<int> addIngredientAndPurchase({
    required String name,
    required DateTime purchasedAt,
    required int totalPrice,
  }) async {
    final id = await db
        .into(db.ingredients)
        .insert(
          IngredientsCompanion.insert(name: name, unit: IngredientUnit.gram),
        );
    await db
        .into(db.ingredientPurchases)
        .insert(
          IngredientPurchasesCompanion.insert(
            ingredientId: id,
            quantity: 1,
            totalPriceRupiah: totalPrice,
            purchasedAt: purchasedAt,
          ),
        );
    return id;
  }

  /// Menyemai satu pesanan yang sudah Selesai lengkap dengan produk, resep,
  /// dan PO induknya.
  Future<void> addCompletedOrder({
    required String productName,
    required int quantity,
    required int unitPrice,
    required int hppSnapshot,
    required DateTime completedAt,
  }) async {
    final existing = await (db.select(
      db.products,
    )..where((t) => t.name.equals(productName))).getSingleOrNull();

    final productId =
        existing?.id ??
        await db
            .into(db.products)
            .insert(ProductsCompanion.insert(name: productName));

    final existingRecipe = await (db.select(
      db.recipes,
    )..where((t) => t.productId.equals(productId))).getSingleOrNull();
    final recipeId =
        existingRecipe?.id ??
        await db
            .into(db.recipes)
            .insert(
              RecipesCompanion.insert(
                productId: productId,
                sellingPriceRupiah: unitPrice,
              ),
            );

    final poId = await db
        .into(db.purchaseOrders)
        .insert(PurchaseOrdersCompanion.insert(label: 'Pagi'));

    await db
        .into(db.orders)
        .insert(
          OrdersCompanion.insert(
            purchaseOrderId: poId,
            productId: productId,
            recipeId: recipeId,
            quantity: quantity,
            unitPriceRupiah: unitPrice,
            status: const Value(OrderStatus.completed),
            hppSnapshotRupiah: Value(hppSnapshot),
            completedAt: Value(completedAt),
          ),
        );
  }

  group('E.1 Modal Kerja Tersedia', () {
    test('is capital in minus equipment investment', () async {
      await addCapital(CapitalEntryKind.initial, 2000000);
      await addCapital(CapitalEntryKind.injection, 500000);
      await addCapital(CapitalEntryKind.equipment, 300000);

      final summary = await repository.watchCapitalSummary().first;

      expect(summary.modalMasukRupiah, 2500000);
      expect(summary.investasiAlatRupiah, 300000);
      expect(summary.modalKerjaTersediaRupiah, 2200000);
    });

    test('rejects a non-positive amount', () async {
      expect(
        () => repository.addCapitalEntry(
          kind: CapitalEntryKind.initial,
          amountRupiah: 0,
          recordedAt: DateTime(2026, 1, 1),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('E.2 Arus Kas Mingguan', () {
    test('starts week one from Modal Kerja Tersedia', () async {
      await addCapital(CapitalEntryKind.initial, 1000000);
      await addCapital(CapitalEntryKind.equipment, 200000);
      // Senin 2026-09-07.
      await addClosing(
        date: DateTime(2026, 9, 7),
        revenue: 300000,
        hpp: 100000,
        operational: 50000,
      );

      final weeks = await repository.weeklyCashFlow();

      expect(weeks, hasLength(1));
      expect(weeks.single.kasAwalRupiah, 800000);
      expect(weeks.single.kasMasukRupiah, 300000);
      expect(weeks.single.kasKeluarRupiah, 50000);
      expect(weeks.single.kasAkhirRupiah, 800000 + 300000 - 50000);
    });

    test('chains each week from the previous week closing cash', () async {
      await addCapital(CapitalEntryKind.initial, 500000);
      await addClosing(
        date: DateTime(2026, 9, 7),
        revenue: 200000,
        operational: 40000,
      );
      await addClosing(
        date: DateTime(2026, 9, 14),
        revenue: 250000,
        operational: 60000,
      );

      final weeks = await repository.weeklyCashFlow();

      expect(weeks, hasLength(2));
      expect(
        weeks[1].kasAwalRupiah,
        weeks[0].kasAkhirRupiah,
        reason: 'Kas Awal minggu ini harus sama dengan Kas Akhir minggu lalu',
      );
    });

    test('counts ingredient purchases as cash out', () async {
      await addCapital(CapitalEntryKind.initial, 500000);
      await addClosing(
        date: DateTime(2026, 9, 7),
        revenue: 100000,
        operational: 20000,
      );
      await addIngredientAndPurchase(
        name: 'Durian',
        purchasedAt: DateTime(2026, 9, 9),
        totalPrice: 75000,
      );

      final weeks = await repository.weeklyCashFlow();

      expect(weeks.single.kasKeluarRupiah, 95000);
    });

    test('accumulates weekly profit into Modal Terkumpul', () async {
      await addClosing(date: DateTime(2026, 9, 7), revenue: 100000, hpp: 40000);
      await addClosing(
        date: DateTime(2026, 9, 14),
        revenue: 200000,
        hpp: 50000,
      );

      final weeks = await repository.weeklyCashFlow();

      expect(weeks[0].modalTerkumpulRupiah, 60000);
      expect(weeks[1].modalTerkumpulRupiah, 60000 + 150000);
    });

    test('returns nothing before any activity is recorded', () async {
      expect(await repository.weeklyCashFlow(), isEmpty);
    });
  });

  group('E.3 Kesehatan Modal Kerja', () {
    test('rates the ratio Aman, Waspada, or Kritis', () async {
      await addCapital(CapitalEntryKind.initial, 1000000);
      // Kebutuhan kas mingguan = 100.000, kas akhir = 1.000.000 + 0 - 100.000.
      await addClosing(date: DateTime(2026, 9, 7), operational: 100000);

      final health = await repository.workingCapitalHealth();

      expect(health.kebutuhanKasPerMingguRupiah, 100000);
      expect(health.kasAkhirRupiah, 900000);
      expect(health.rasio, 9);
      expect(health.status, WorkingCapitalStatus.aman);
    });

    test('flags Kritis when cash covers under half a week', () async {
      await addCapital(CapitalEntryKind.initial, 30000);
      await addClosing(date: DateTime(2026, 9, 7), operational: 100000);

      final health = await repository.workingCapitalHealth();

      // Kas akhir = 30.000 - 100.000 = -70.000 -> rasio negatif.
      expect(health.status, WorkingCapitalStatus.kritis);
    });

    test('has no status at all before any spending exists', () async {
      final health = await repository.workingCapitalHealth();
      expect(health.rasio, isNull);
      expect(health.status, isNull);
    });
  });

  group('BEP & Margin of Safety', () {
    test('computes weighted margin, BEP, and MoS from real sales', () async {
      // Biaya tetap: dua minggu, masing-masing Rp100.000 -> rata-rata 100.000.
      await addClosing(date: DateTime(2026, 9, 7), operational: 100000);
      await addClosing(date: DateTime(2026, 9, 14), operational: 100000);

      // Minggu 1: 10 porsi @15.000 dengan HPP total 50.000 (5.000/porsi).
      await addCompletedOrder(
        productName: 'Es Teler Durian',
        quantity: 10,
        unitPrice: 15000,
        hppSnapshot: 50000,
        completedAt: DateTime(2026, 9, 8),
      );
      // Minggu 2: 10 porsi lagi, sama.
      await addCompletedOrder(
        productName: 'Es Teler Durian',
        quantity: 10,
        unitPrice: 15000,
        hppSnapshot: 50000,
        completedAt: DateTime(2026, 9, 15),
      );

      final analysis = await repository.bepAnalysis();

      expect(analysis.fixedCostPerWeekRupiah, 100000);
      expect(analysis.weeksObserved, 2);
      // Margin kontribusi = 15.000 - 5.000 = 10.000 per porsi.
      expect(analysis.weightedMarginRupiah, 10000);
      // BEP = 100.000 / 10.000 = 10 porsi per minggu.
      expect(analysis.bepPortionsPerWeek, 10);
      expect(analysis.bepRupiahPerWeek, 150000);
      // Aktual 10 porsi/minggu -> MoS nol persen -> Rawan.
      expect(analysis.actualPortionsPerWeek, 10);
      expect(analysis.mosPortions, 0);
      expect(analysis.mosPercent, 0);
      expect(analysis.category, MarginOfSafetyCategory.rawan);
    });

    test('classifies a comfortable margin of safety as Sehat', () async {
      await addClosing(date: DateTime(2026, 9, 7), operational: 100000);
      // 20 porsi terjual di satu minggu, BEP tetap 10 -> MoS 50%.
      await addCompletedOrder(
        productName: 'Es Teler Durian',
        quantity: 20,
        unitPrice: 15000,
        hppSnapshot: 100000,
        completedAt: DateTime(2026, 9, 8),
      );

      final analysis = await repository.bepAnalysis();

      expect(analysis.bepPortionsPerWeek, 10);
      expect(analysis.actualPortionsPerWeek, 20);
      expect(analysis.mosPercent, 50);
      expect(analysis.category, MarginOfSafetyCategory.sehat);
    });

    test('leaves BEP undefined when margin is not positive', () async {
      await addClosing(date: DateTime(2026, 9, 7), operational: 100000);
      // Dijual Rp10.000 tapi HPP-nya Rp12.000 per porsi -> margin negatif.
      await addCompletedOrder(
        productName: 'Rugi',
        quantity: 5,
        unitPrice: 10000,
        hppSnapshot: 60000,
        completedAt: DateTime(2026, 9, 8),
      );

      final analysis = await repository.bepAnalysis();

      expect(analysis.weightedMarginRupiah, lessThan(0));
      expect(analysis.bepPortionsPerWeek, isNull);
      expect(analysis.category, isNull);
    });

    test('projects monthly profit using 4.3 weeks', () async {
      await addClosing(date: DateTime(2026, 9, 7), operational: 100000);
      await addCompletedOrder(
        productName: 'Es Teler Durian',
        quantity: 20,
        unitPrice: 15000,
        hppSnapshot: 100000,
        completedAt: DateTime(2026, 9, 8),
      );

      final analysis = await repository.bepAnalysis();

      // (10.000 x 20 - 100.000) x 4,3 = 430.000
      expect(analysis.projectedMonthlyProfitRupiah, 430000);
    });
  });

  group('Rekap Mingguan vs Target', () {
    test('builds the target from a rolling average of past weeks', () async {
      final currentWeekMonday = DateTime(2026, 9, 7);

      // Dua minggu sebelumnya: 10 lalu 20 porsi -> baseline 15.
      await addCompletedOrder(
        productName: 'Es Teler Durian',
        quantity: 10,
        unitPrice: 15000,
        hppSnapshot: 50000,
        completedAt: currentWeekMonday.subtract(const Duration(days: 14)),
      );
      await addCompletedOrder(
        productName: 'Es Teler Durian',
        quantity: 20,
        unitPrice: 15000,
        hppSnapshot: 100000,
        completedAt: currentWeekMonday.subtract(const Duration(days: 7)),
      );

      final recap = await repository.weeklyTargetRecap(
        growthMultiplier: 1,
        lookbackWeeks: 4,
      );

      expect(recap, hasLength(1));
      expect(recap.single.baselinePortions, 15);
      expect(recap.single.targetPortions, 15);
    });

    test('applies the growth multiplier on top of the baseline', () async {
      await addCompletedOrder(
        productName: 'Es Teler Durian',
        quantity: 20,
        unitPrice: 15000,
        hppSnapshot: 100000,
        completedAt: DateTime.now().subtract(const Duration(days: 7)),
      );

      final recap = await repository.weeklyTargetRecap(growthMultiplier: 1.1);

      expect(recap.single.baselinePortions, 20);
      expect(
        recap.single.targetPortions,
        closeTo(22, 0.001),
        reason: 'target = kebiasaan terakhir + 10%',
      );
    });

    test('excludes the in-progress week from the baseline', () async {
      // Penjualan minggu ini saja: belum ada minggu selesai -> baseline 0.
      await addCompletedOrder(
        productName: 'Es Teler Durian',
        quantity: 7,
        unitPrice: 15000,
        hppSnapshot: 35000,
        completedAt: DateTime.now(),
      );

      final recap = await repository.weeklyTargetRecap();

      expect(recap.single.baselinePortions, 0);
      expect(recap.single.actualPortions, 7);
      expect(recap.single.achievementPercent, isNull);
    });
  });
}
