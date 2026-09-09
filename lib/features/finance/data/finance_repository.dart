import '../../../data/local/app_database.dart';
import '../domain/finance_models.dart';

/// Bagian E (Modal & Arus Kas) plus laporan finansial Bagian C (BEP/MoS dan
/// rekap mingguan).
///
/// Semua angka mingguan diturunkan dari data harian yang sudah ada — modul ini
/// tidak pernah meminta input mingguan manual (new_flow.md E.2).
abstract interface class FinanceRepository {
  // --- E.1 Modal Awal ---

  Stream<List<CapitalEntry>> watchCapitalEntries();

  Stream<CapitalSummary> watchCapitalSummary();

  Future<int> addCapitalEntry({
    required CapitalEntryKind kind,
    required int amountRupiah,
    String? note,
    required DateTime recordedAt,
  });

  Future<void> deleteCapitalEntry(int id);

  // --- E.2 Arus Kas Mingguan ---

  /// Satu baris per minggu yang punya aktivitas, terurut dari minggu paling
  /// awal. Kas Awal tiap minggu menyambung dari Kas Akhir minggu sebelumnya,
  /// dan minggu pertama berangkat dari Modal Kerja Tersedia.
  Future<List<WeeklyCashFlow>> weeklyCashFlow();

  // --- E.3 Kesehatan Modal Kerja ---

  Future<WorkingCapitalHealth> workingCapitalHealth();

  // --- Bagian C: BEP & Margin of Safety ---

  Future<BepAnalysis> bepAnalysis();

  // --- Bagian C: Rekap Mingguan Aktual vs Target ---

  /// Baseline bergulir dari [lookbackWeeks] minggu terakhir yang sudah
  /// selesai, dikali [growthMultiplier] (1.1 = target 10% di atas kebiasaan).
  Future<List<WeeklyTargetRecap>> weeklyTargetRecap({
    double growthMultiplier = 1.1,
    int lookbackWeeks = 4,
  });
}
