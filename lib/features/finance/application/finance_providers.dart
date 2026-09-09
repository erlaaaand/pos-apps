import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/app_database.dart';
import '../../../data/local/database_provider.dart';
import '../data/finance_repository.dart';
import '../data/finance_repository_impl.dart';
import '../domain/finance_models.dart';

final financeRepositoryProvider = Provider<FinanceRepository>((ref) {
  return FinanceRepositoryImpl(ref.watch(appDatabaseProvider));
});

final capitalEntriesProvider = StreamProvider<List<CapitalEntry>>((ref) {
  return ref.watch(financeRepositoryProvider).watchCapitalEntries();
});

final capitalSummaryProvider = StreamProvider<CapitalSummary>((ref) {
  return ref.watch(financeRepositoryProvider).watchCapitalSummary();
});

/// Arus kas ikut berubah begitu ada entri modal baru, karena minggu pertama
/// berangkat dari Modal Kerja Tersedia.
final weeklyCashFlowProvider = FutureProvider<List<WeeklyCashFlow>>((ref) {
  ref.watch(capitalEntriesProvider);
  return ref.watch(financeRepositoryProvider).weeklyCashFlow();
});

final workingCapitalHealthProvider = FutureProvider<WorkingCapitalHealth>((
  ref,
) {
  ref.watch(capitalEntriesProvider);
  return ref.watch(financeRepositoryProvider).workingCapitalHealth();
});

final bepAnalysisProvider = FutureProvider<BepAnalysis>((ref) {
  return ref.watch(financeRepositoryProvider).bepAnalysis();
});

/// Faktor ambisi target mingguan: 1.0 = sama dengan kebiasaan 4 minggu
/// terakhir, 1.1 = 10% di atasnya (default).
class TargetGrowthMultiplier extends Notifier<double> {
  @override
  double build() => 1.1;

  void select(double value) => state = value;
}

final targetGrowthMultiplierProvider =
    NotifierProvider<TargetGrowthMultiplier, double>(
      TargetGrowthMultiplier.new,
    );

final weeklyTargetRecapProvider = FutureProvider<List<WeeklyTargetRecap>>((
  ref,
) {
  final multiplier = ref.watch(targetGrowthMultiplierProvider);
  return ref
      .watch(financeRepositoryProvider)
      .weeklyTargetRecap(growthMultiplier: multiplier);
});
