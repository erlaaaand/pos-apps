/// Model-model Bagian E (Manajemen Keuangan) dan laporan finansial Bagian C.
///
/// Semuanya dihitung dari data yang sudah tercatat di Bagian A & B — tidak ada
/// input mingguan manual seperti di spreadsheet asli (new_flow.md E.2).
library;

/// E.1 — Modal Awal dan investasi alat.
class CapitalSummary {
  const CapitalSummary({
    required this.modalMasukRupiah,
    required this.investasiAlatRupiah,
  });

  /// Modal awal + seluruh suntikan modal berikutnya.
  final int modalMasukRupiah;

  /// Pembelian alat/perlengkapan yang diambil dari modal.
  final int investasiAlatRupiah;

  /// Modal Kerja Tersedia = Modal Awal − Investasi Alat.
  int get modalKerjaTersediaRupiah => modalMasukRupiah - investasiAlatRupiah;
}

/// E.2 — satu baris arus kas mingguan.
class WeeklyCashFlow {
  const WeeklyCashFlow({
    required this.weekStart,
    required this.kasAwalRupiah,
    required this.kasMasukRupiah,
    required this.kasKeluarRupiah,
    required this.labaRugiRupiah,
    required this.modalTerkumpulRupiah,
  });

  /// Hari Senin dari minggu ini (lihat `weekStart()` di core/date).
  final DateTime weekStart;

  /// Kas Akhir minggu sebelumnya, atau Modal Kerja Tersedia untuk minggu
  /// pertama.
  final int kasAwalRupiah;

  /// Pendapatan penjualan minggu ini (dari tutup harian B.5).
  final int kasMasukRupiah;

  /// Pembelian bahan (A.2) + biaya operasional (B.5) minggu ini.
  final int kasKeluarRupiah;

  /// Jumlah laba bersih harian minggu ini.
  final int labaRugiRupiah;

  /// Akumulasi laba/rugi sejak minggu pertama.
  final int modalTerkumpulRupiah;

  int get kasAkhirRupiah => kasAwalRupiah + kasMasukRupiah - kasKeluarRupiah;
}

/// E.3 — status kesehatan modal kerja.
enum WorkingCapitalStatus { aman, waspada, kritis }

class WorkingCapitalHealth {
  const WorkingCapitalHealth({
    required this.kebutuhanKasPerMingguRupiah,
    required this.kasAkhirRupiah,
  });

  /// Rata-rata (pembelian bahan + biaya operasional) per minggu.
  final int kebutuhanKasPerMingguRupiah;

  /// Kas akhir minggu terakhir yang tercatat.
  final int kasAkhirRupiah;

  /// Kas Akhir ÷ Kebutuhan Kas per Minggu. `null` kalau belum ada kebutuhan
  /// yang bisa dihitung (belum ada belanja/biaya sama sekali).
  double? get rasio => kebutuhanKasPerMingguRupiah <= 0
      ? null
      : kasAkhirRupiah / kebutuhanKasPerMingguRupiah;

  WorkingCapitalStatus? get status {
    final value = rasio;
    if (value == null) return null;
    if (value >= 1) return WorkingCapitalStatus.aman;
    if (value >= 0.5) return WorkingCapitalStatus.waspada;
    return WorkingCapitalStatus.kritis;
  }
}

/// Margin kontribusi satu produk = harga jual − HPP per porsi (new_flow.md C).
class ProductContribution {
  const ProductContribution({
    required this.productId,
    required this.productName,
    required this.avgPriceRupiah,
    required this.avgHppRupiah,
    required this.unitsSold,
  });

  final int productId;
  final String productName;

  /// Rata-rata harga jual per porsi dari pesanan yang sudah selesai.
  final double avgPriceRupiah;

  /// Rata-rata HPP per porsi, dari snapshot HPP tiap pesanan.
  final double avgHppRupiah;

  /// Total porsi terjual — dasar bobot sales mix.
  final int unitsSold;

  double get marginRupiah => avgPriceRupiah - avgHppRupiah;
}

/// Kategori Margin of Safety sesuai ambang di new_flow.md C.
enum MarginOfSafetyCategory { sehat, amanTipis, rawan }

/// Hasil analisis BEP & Margin of Safety.
class BepAnalysis {
  const BepAnalysis({
    required this.fixedCostPerWeekRupiah,
    required this.contributions,
    required this.actualPortionsPerWeek,
    required this.actualRevenuePerWeekRupiah,
    required this.weeksObserved,
  });

  /// Biaya tetap mingguan — rollup biaya operasional harian (B.5).
  final int fixedCostPerWeekRupiah;

  final List<ProductContribution> contributions;

  /// Rata-rata porsi terjual per minggu.
  final double actualPortionsPerWeek;

  /// Rata-rata pendapatan per minggu.
  final double actualRevenuePerWeekRupiah;

  /// Berapa minggu data yang dipakai — dipakai UI untuk memperingatkan kalau
  /// datanya masih terlalu sedikit untuk dipercaya.
  final int weeksObserved;

  int get totalUnitsSold =>
      contributions.fold<int>(0, (sum, c) => sum + c.unitsSold);

  /// Margin kontribusi rata-rata tertimbang berdasarkan sales mix.
  double get weightedMarginRupiah {
    final total = totalUnitsSold;
    if (total == 0) return 0;
    return contributions.fold<double>(
          0,
          (sum, c) => sum + c.marginRupiah * c.unitsSold,
        ) /
        total;
  }

  /// Harga jual rata-rata tertimbang, untuk mengubah BEP porsi jadi Rupiah.
  double get weightedPriceRupiah {
    final total = totalUnitsSold;
    if (total == 0) return 0;
    return contributions.fold<double>(
          0,
          (sum, c) => sum + c.avgPriceRupiah * c.unitsSold,
        ) /
        total;
  }

  /// BEP dalam porsi per minggu. `null` kalau margin kontribusi belum positif
  /// — pada kondisi itu BEP memang tidak terdefinisi, bukan nol.
  double? get bepPortionsPerWeek {
    final margin = weightedMarginRupiah;
    if (margin <= 0) return null;
    return fixedCostPerWeekRupiah / margin;
  }

  int? get bepRupiahPerWeek {
    final portions = bepPortionsPerWeek;
    if (portions == null) return null;
    return (portions * weightedPriceRupiah).round();
  }

  /// Margin of Safety dalam porsi.
  double? get mosPortions {
    final bep = bepPortionsPerWeek;
    if (bep == null) return null;
    return actualPortionsPerWeek - bep;
  }

  int? get mosRupiah {
    final bep = bepRupiahPerWeek;
    if (bep == null) return null;
    return (actualRevenuePerWeekRupiah - bep).round();
  }

  double? get mosPercent {
    final mos = mosPortions;
    if (mos == null || actualPortionsPerWeek <= 0) return null;
    return (mos / actualPortionsPerWeek) * 100;
  }

  MarginOfSafetyCategory? get category {
    final percent = mosPercent;
    if (percent == null) return null;
    if (percent >= 30) return MarginOfSafetyCategory.sehat;
    if (percent >= 15) return MarginOfSafetyCategory.amanTipis;
    return MarginOfSafetyCategory.rawan;
  }

  /// Proyeksi laba bulanan dengan asumsi 4,3 minggu/bulan (new_flow.md C).
  int get projectedMonthlyProfitRupiah {
    final weeklyProfit =
        weightedMarginRupiah * actualPortionsPerWeek - fixedCostPerWeekRupiah;
    return (weeklyProfit * 4.3).round();
  }
}

/// Rekap Mingguan: Aktual vs Target (new_flow.md C).
///
/// Target dipakai sebagai **baseline bergulir**: rata-rata porsi terjual
/// beberapa minggu terakhir dikali faktor ambisi. Ini menyesuaikan sendiri
/// saat orderan bertambah, jadi tidak ada angka target usang yang harus
/// dirawat manual — metode yang sama dipakai new_flow.md untuk rekomendasi
/// belanja mingguan.
class WeeklyTargetRecap {
  const WeeklyTargetRecap({
    required this.productName,
    required this.baselinePortions,
    required this.targetPortions,
    required this.actualPortions,
    required this.marginRupiah,
  });

  final String productName;

  /// Rata-rata porsi/minggu dari beberapa minggu terakhir yang sudah selesai.
  final double baselinePortions;

  /// baseline × faktor pertumbuhan.
  final double targetPortions;

  /// Porsi terjual di minggu berjalan.
  final int actualPortions;

  /// Margin kontribusi per porsi, untuk menghitung laba "kalau target penuh".
  final double marginRupiah;

  double? get achievementPercent =>
      targetPortions <= 0 ? null : (actualPortions / targetPortions) * 100;

  double get differencePortions => actualPortions - targetPortions;

  int get actualContributionRupiah => (actualPortions * marginRupiah).round();

  int get targetContributionRupiah => (targetPortions * marginRupiah).round();
}
