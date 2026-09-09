import 'package:dapur_kelaris/app/app.dart';
import 'package:dapur_kelaris/data/local/app_database.dart';
import 'package:dapur_kelaris/data/local/database_provider.dart';
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  testWidgets('app boots to the dashboard with bottom navigation', (
    tester,
  ) async {
    await initializeDateFormatting('id_ID');
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const BusinessManagementApp(),
      ),
    );
    // Bounded pumps instead of pumpAndSettle: the Ingredients/Products tabs
    // show an indeterminate CircularProgressIndicator while their Drift
    // stream connects to the real (in-memory) database, and that spinner's
    // perpetual animation would make pumpAndSettle wait forever.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Header Beranda menampilkan brand sebagai baris kapital kecil di atas
    // judul layar (mengikuti reference_theme/design.html).
    expect(find.text('DAPUR KELARIS'), findsOneWidget);
    expect(find.text('Beranda Bisnis'), findsOneWidget);
    // NavigationBar renders each destination label in both its selected and
    // unselected animation layers, so these match twice even though only
    // one of each is visible at a time.
    expect(find.text('Beranda'), findsWidgets);
    expect(find.text('Bahan Baku'), findsWidgets);
    expect(find.text('Produk'), findsWidgets);

    await tester.tap(find.text('Bahan Baku').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Master Bahan Baku'), findsOneWidget);
    expect(
      find.text(
        'Belum ada bahan baku. Tambahkan bahan baku dulu sebelum '
        'bisa mencatat pembelian atau membuat resep.',
      ),
      findsOneWidget,
    );

    // Unmount and pump once more so Drift cancels its stream-query
    // subscriptions (and the cleanup Timer that schedules) while still
    // inside a pump cycle we control — otherwise that Timer is still
    // pending when the test framework's own teardown runs and its
    // "no pending timers" invariant check fails.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
  });
}
