import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/app_database.dart';
import '../../../data/local/database_provider.dart';
import '../../backup/application/backup_providers.dart';
import '../data/daily_closing_repository.dart';
import '../data/daily_closing_repository_impl.dart';
import '../domain/daily_summary.dart';

final dailyClosingRepositoryProvider = Provider<DailyClosingRepository>((
  ref,
) {
  return DailyClosingRepositoryImpl(
    ref.watch(appDatabaseProvider),
    ref.watch(backupRepositoryProvider),
  );
});

final dailyClosingHistoryProvider = StreamProvider<List<DailyClosing>>((ref) {
  return ref.watch(dailyClosingRepositoryProvider).watchHistory();
});

final todayOperationalCostsProvider =
    StreamProvider<List<DailyOperationalCost>>((ref) {
      return ref
          .watch(dailyClosingRepositoryProvider)
          .watchTodayOperationalCosts();
    });

final todaySummaryProvider = FutureProvider<DailySummary>((ref) {
  // Re-runs whenever today's orders or operational costs change.
  ref.watch(todayOperationalCostsProvider);
  return ref.watch(dailyClosingRepositoryProvider).previewToday();
});
