import '../../../core/date/date_only.dart';
import '../../../data/local/app_database.dart';

/// Kelompok transaksi pembelian bahan baku pada satu hari kalender tertentu.
class DailyPurchaseGroup {
  const DailyPurchaseGroup({required this.date, required this.purchases});

  /// Tanggal pembelian (komponen jam di-strip via [dateOnly]).
  final DateTime date;

  /// Daftar transaksi pembelian yang terjadi pada [date].
  final List<IngredientPurchase> purchases;

  /// Total kuantitas bahan yang dibeli pada hari ini.
  double get totalQuantity =>
      purchases.fold(0.0, (sum, item) => sum + item.quantity);

  /// Total pengeluaran nominal (Rupiah) pada hari ini.
  int get totalCostRupiah =>
      purchases.fold(0, (sum, item) => sum + item.totalPriceRupiah);

  /// Rata-rata harga beli per satuan pada hari ini.
  double get averageCostPerUnit {
    if (totalQuantity <= 0) return 0.0;
    return totalCostRupiah / totalQuantity;
  }

  /// Jumlah transaksi pembelian pada hari ini.
  int get transactionCount => purchases.length;
}

/// Hasil pemilahan riwayat pembelian antara hari ini vs hari-hari sebelumnya.
class GroupedPurchases {
  const GroupedPurchases({
    required this.todayPurchases,
    required this.pastDailyGroups,
  });

  /// Daftar transaksi pembelian yang berlangsung hari ini.
  final List<IngredientPurchase> todayPurchases;

  /// Daftar ringkasan per hari untuk hari-hari sebelum hari ini,
  /// diurutkan dari hari paling baru ke lama.
  final List<DailyPurchaseGroup> pastDailyGroups;

  /// Total semua transaksi (hari ini + masa lalu).
  int get totalTransactions =>
      todayPurchases.length +
      pastDailyGroups.fold(0, (sum, g) => sum + g.transactionCount);

  /// Total kuantitas semua pembelian sepanjang masa.
  double get totalAllTimeQuantity =>
      todayPurchases.fold(0.0, (sum, item) => sum + item.quantity) +
      pastDailyGroups.fold(0.0, (sum, g) => sum + g.totalQuantity);

  /// Total nominal belanja sepanjang masa.
  int get totalAllTimeCostRupiah =>
      todayPurchases.fold(0, (sum, item) => sum + item.totalPriceRupiah) +
      pastDailyGroups.fold(0, (sum, g) => sum + g.totalCostRupiah);
}

/// Mengelompokkan riwayat pembelian [purchases] berdasarkan hari kalender.
///
/// Transaksi di tanggal hari ini ([now] atau DateTime.now()) dimasukkan ke
/// [GroupedPurchases.todayPurchases], sedangkan tanggal-tanggal sebelumnya
/// dikemas ke dalam [DailyPurchaseGroup] terpisah per hari.
GroupedPurchases groupPurchasesByDay(
  List<IngredientPurchase> purchases, {
  DateTime? now,
}) {
  final currentDay = dateOnly(now ?? DateTime.now());
  final todayItems = <IngredientPurchase>[];
  final pastMap = <DateTime, List<IngredientPurchase>>{};

  for (final purchase in purchases) {
    final purchaseDay = dateOnly(purchase.purchasedAt);
    if (purchaseDay.isAtSameMomentAs(currentDay)) {
      todayItems.add(purchase);
    } else {
      pastMap.putIfAbsent(purchaseDay, () => []).add(purchase);
    }
  }

  // Urutkan grup hari-hari masa lalu dari tanggal paling baru ke terlama
  final sortedPastDays = pastMap.keys.toList()..sort((a, b) => b.compareTo(a));

  final pastGroups = sortedPastDays.map((day) {
    final items = pastMap[day]!;
    // Di dalam satu hari, urutkan dari waktu transaksi terbaru
    items.sort((a, b) => b.purchasedAt.compareTo(a.purchasedAt));
    return DailyPurchaseGroup(date: day, purchases: items);
  }).toList();

  // Transaksi hari ini juga diurutkan dari yang paling baru
  todayItems.sort((a, b) => b.purchasedAt.compareTo(a.purchasedAt));

  return GroupedPurchases(
    todayPurchases: todayItems,
    pastDailyGroups: pastGroups,
  );
}
