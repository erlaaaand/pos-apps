import 'package:drift/drift.dart';

import '../../../core/date/date_only.dart';
import '../../../core/date/week_start.dart';
import '../../../data/local/app_database.dart';
import '../domain/finance_models.dart';
import 'finance_repository.dart';

class FinanceRepositoryImpl implements FinanceRepository {
  FinanceRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<CapitalEntry>> watchCapitalEntries() {
    return (_db.select(_db.capitalEntries)..orderBy([
          (t) =>
              OrderingTerm(expression: t.recordedAt, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  @override
  Stream<CapitalSummary> watchCapitalSummary() {
    return _db.select(_db.capitalEntries).watch().map(_summarise);
  }

  @override
  Future<int> addCapitalEntry({
    required CapitalEntryKind kind,
    required int amountRupiah,
    String? note,
    required DateTime recordedAt,
  }) {
    if (amountRupiah <= 0) {
      throw ArgumentError.value(
        amountRupiah,
        'amountRupiah',
        'Jumlah harus lebih dari 0',
      );
    }
    return _db
        .into(_db.capitalEntries)
        .insert(
          CapitalEntriesCompanion.insert(
            kind: kind,
            amountRupiah: amountRupiah,
            note: Value(note),
            recordedAt: recordedAt,
          ),
        );
  }

  @override
  Future<void> deleteCapitalEntry(int id) async {
    await (_db.delete(_db.capitalEntries)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<List<WeeklyCashFlow>> weeklyCashFlow() async {
    final closings = await _db.select(_db.dailyClosings).get();
    final purchases = await _db.select(_db.ingredientPurchases).get();

    // Kas masuk, laba, dan biaya operasional diambil dari snapshot tutup
    // harian supaya angka mingguan persis sama dengan jumlah angka hariannya
    // (new_flow.md E.2). Pembelian bahan tidak ikut tercatat di tutup harian,
    // jadi diambil langsung dari riwayat pembelian.
    final revenueByWeek = <DateTime, int>{};
    final operationalByWeek = <DateTime, int>{};
    final profitByWeek = <DateTime, int>{};
    for (final closing in closings) {
      final week = weekStart(closing.date);
      revenueByWeek[week] =
          (revenueByWeek[week] ?? 0) + closing.totalRevenueRupiah;
      operationalByWeek[week] =
          (operationalByWeek[week] ?? 0) + closing.totalOperationalCostRupiah;
      profitByWeek[week] = (profitByWeek[week] ?? 0) + closing.netProfitRupiah;
    }

    final purchaseByWeek = <DateTime, int>{};
    for (final purchase in purchases) {
      final week = weekStart(purchase.purchasedAt);
      purchaseByWeek[week] =
          (purchaseByWeek[week] ?? 0) + purchase.totalPriceRupiah;
    }

    final weeks = <DateTime>{
      ...revenueByWeek.keys,
      ...operationalByWeek.keys,
      ...profitByWeek.keys,
      ...purchaseByWeek.keys,
    }.toList()..sort();
    if (weeks.isEmpty) return const [];

    final summary = _summarise(await _db.select(_db.capitalEntries).get());
    var kasAwal = summary.modalKerjaTersediaRupiah;
    var modalTerkumpul = 0;

    final result = <WeeklyCashFlow>[];
    for (final week in weeks) {
      final kasMasuk = revenueByWeek[week] ?? 0;
      final kasKeluar =
          (purchaseByWeek[week] ?? 0) + (operationalByWeek[week] ?? 0);
      final labaRugi = profitByWeek[week] ?? 0;
      modalTerkumpul += labaRugi;

      final row = WeeklyCashFlow(
        weekStart: week,
        kasAwalRupiah: kasAwal,
        kasMasukRupiah: kasMasuk,
        kasKeluarRupiah: kasKeluar,
        labaRugiRupiah: labaRugi,
        modalTerkumpulRupiah: modalTerkumpul,
      );
      result.add(row);
      kasAwal = row.kasAkhirRupiah;
    }
    return result;
  }

  @override
  Future<WorkingCapitalHealth> workingCapitalHealth() async {
    final weeks = await weeklyCashFlow();
    if (weeks.isEmpty) {
      return const WorkingCapitalHealth(
        kebutuhanKasPerMingguRupiah: 0,
        kasAkhirRupiah: 0,
      );
    }

    final totalKeluar = weeks.fold<int>(
      0,
      (sum, week) => sum + week.kasKeluarRupiah,
    );
    return WorkingCapitalHealth(
      kebutuhanKasPerMingguRupiah: (totalKeluar / weeks.length).round(),
      kasAkhirRupiah: weeks.last.kasAkhirRupiah,
    );
  }

  @override
  Future<BepAnalysis> bepAnalysis() async {
    final closings = await _db.select(_db.dailyClosings).get();
    final sales = await _completedSales();

    // Biaya tetap mingguan = rollup biaya operasional harian (new_flow.md C).
    // Catatan: biaya gas per sesi sudah ikut tergabung di dalam angka ini oleh
    // `closeToday`, jadi ia dihitung sebagai biaya tetap juga.
    final operationalByWeek = <DateTime, int>{};
    for (final closing in closings) {
      final week = weekStart(closing.date);
      operationalByWeek[week] =
          (operationalByWeek[week] ?? 0) + closing.totalOperationalCostRupiah;
    }
    final fixedPerWeek = operationalByWeek.isEmpty
        ? 0
        : (operationalByWeek.values.reduce((a, b) => a + b) /
                  operationalByWeek.length)
              .round();

    final salesWeeks = sales.map((s) => weekStart(s.soldAt)).toSet();
    final weeksObserved = salesWeeks.isEmpty ? 0 : salesWeeks.length;

    // Kumpulkan margin & sales mix per produk.
    final byProduct = <int, _ProductAccumulator>{};
    for (final sale in sales) {
      final acc = byProduct.putIfAbsent(
        sale.productId,
        () => _ProductAccumulator(sale.productName),
      );
      acc.units += sale.quantity;
      acc.revenue += sale.unitPriceRupiah * sale.quantity;
      acc.hpp += sale.hppSnapshotRupiah;
    }

    final contributions =
        byProduct.entries
            .map(
              (entry) => ProductContribution(
                productId: entry.key,
                productName: entry.value.name,
                avgPriceRupiah: entry.value.units == 0
                    ? 0
                    : entry.value.revenue / entry.value.units,
                avgHppRupiah: entry.value.units == 0
                    ? 0
                    : entry.value.hpp / entry.value.units,
                unitsSold: entry.value.units,
              ),
            )
            .toList()
          ..sort((a, b) => b.unitsSold.compareTo(a.unitsSold));

    final totalUnits = contributions.fold<int>(0, (s, c) => s + c.unitsSold);
    final totalRevenue = byProduct.values.fold<int>(0, (s, a) => s + a.revenue);

    return BepAnalysis(
      fixedCostPerWeekRupiah: fixedPerWeek,
      contributions: contributions,
      actualPortionsPerWeek: weeksObserved == 0
          ? 0
          : totalUnits / weeksObserved,
      actualRevenuePerWeekRupiah: weeksObserved == 0
          ? 0
          : totalRevenue / weeksObserved,
      weeksObserved: weeksObserved,
    );
  }

  @override
  Future<List<WeeklyTargetRecap>> weeklyTargetRecap({
    double growthMultiplier = 1.1,
    int lookbackWeeks = 4,
  }) async {
    final sales = await _completedSales();
    if (sales.isEmpty) return const [];

    final currentWeek = weekStart(DateTime.now());

    // Porsi per produk per minggu.
    final unitsByProductWeek = <int, Map<DateTime, int>>{};
    final names = <int, String>{};
    final marginAcc = <int, _ProductAccumulator>{};
    for (final sale in sales) {
      names[sale.productId] = sale.productName;
      final week = weekStart(sale.soldAt);
      final weeks = unitsByProductWeek.putIfAbsent(sale.productId, () => {});
      weeks[week] = (weeks[week] ?? 0) + sale.quantity;

      final acc = marginAcc.putIfAbsent(
        sale.productId,
        () => _ProductAccumulator(sale.productName),
      );
      acc.units += sale.quantity;
      acc.revenue += sale.unitPriceRupiah * sale.quantity;
      acc.hpp += sale.hppSnapshotRupiah;
    }

    final result = <WeeklyTargetRecap>[];
    for (final entry in unitsByProductWeek.entries) {
      final weeks = entry.value;

      // Baseline hanya dari minggu yang sudah selesai — minggu berjalan belum
      // lengkap, memasukkannya akan menyeret target ke bawah.
      final pastWeeks =
          weeks.keys.where((week) => week.isBefore(currentWeek)).toList()
            ..sort((a, b) => b.compareTo(a));
      final considered = pastWeeks.take(lookbackWeeks).toList();
      final baseline = considered.isEmpty
          ? 0.0
          : considered.fold<int>(0, (sum, week) => sum + weeks[week]!) /
                considered.length;

      final acc = marginAcc[entry.key]!;
      final margin = acc.units == 0 ? 0.0 : (acc.revenue - acc.hpp) / acc.units;

      result.add(
        WeeklyTargetRecap(
          productName: names[entry.key] ?? '-',
          baselinePortions: baseline,
          targetPortions: baseline * growthMultiplier,
          actualPortions: weeks[currentWeek] ?? 0,
          marginRupiah: margin,
        ),
      );
    }

    result.sort((a, b) => b.actualPortions.compareTo(a.actualPortions));
    return result;
  }

  /// Pesanan yang sudah Selesai, beserta nama produknya. HPP diambil dari
  /// snapshot per pesanan — nilainya sudah total per baris pesanan (bukan per
  /// porsi), jadi jangan dikali qty lagi.
  Future<List<_CompletedSale>> _completedSales() async {
    final query = _db.select(_db.orders).join([
      innerJoin(_db.products, _db.products.id.equalsExp(_db.orders.productId)),
    ])..where(_db.orders.status.equalsValue(OrderStatus.completed));

    final rows = await query.get();
    return rows.map((row) {
      final order = row.readTable(_db.orders);
      final product = row.readTable(_db.products);
      return _CompletedSale(
        productId: product.id,
        productName: product.name,
        quantity: order.quantity,
        unitPriceRupiah: order.unitPriceRupiah,
        hppSnapshotRupiah: order.hppSnapshotRupiah ?? 0,
        soldAt: dateOnly(order.completedAt ?? order.orderedAt),
      );
    }).toList();
  }

  CapitalSummary _summarise(List<CapitalEntry> entries) {
    var masuk = 0;
    var alat = 0;
    for (final entry in entries) {
      switch (entry.kind) {
        case CapitalEntryKind.initial:
        case CapitalEntryKind.injection:
          masuk += entry.amountRupiah;
        case CapitalEntryKind.equipment:
          alat += entry.amountRupiah;
      }
    }
    return CapitalSummary(modalMasukRupiah: masuk, investasiAlatRupiah: alat);
  }
}

class _CompletedSale {
  const _CompletedSale({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPriceRupiah,
    required this.hppSnapshotRupiah,
    required this.soldAt,
  });

  final int productId;
  final String productName;
  final int quantity;
  final int unitPriceRupiah;
  final int hppSnapshotRupiah;
  final DateTime soldAt;
}

class _ProductAccumulator {
  _ProductAccumulator(this.name);

  final String name;
  int units = 0;
  int revenue = 0;
  int hpp = 0;
}
