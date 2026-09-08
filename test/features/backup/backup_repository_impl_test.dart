import 'dart:io';

import 'package:business_management/data/local/app_database.dart';
import 'package:business_management/features/backup/data/backup_repository_impl.dart';
import 'package:business_management/features/ingredients/data/ingredient_repository_impl.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../test_helpers/fake_path_provider.dart';

void main() {
  late Directory tempRoot;

  setUp(() async {
    tempRoot = await Directory.systemTemp.createTemp('backup_test_');
    PathProviderPlatform.instance = FakePathProviderPlatform(tempRoot.path);
  });

  tearDown(() async {
    if (await tempRoot.exists()) {
      await tempRoot.delete(recursive: true);
    }
  });

  test('backupAsDb writes a restorable file and logs it', () async {
    final liveDbFile = await resolveDatabaseFile();
    final db = AppDatabase(NativeDatabase(liveDbFile));
    final ingredients = IngredientRepositoryImpl(db);
    final backup = BackupRepositoryImpl(db);

    await ingredients.create(name: 'Durian', unit: IngredientUnit.gram);

    final log = await backup.backupAsDb(trigger: BackupTrigger.manual);

    expect(await File(log.filePath).exists(), isTrue);
    expect(log.format, BackupFormat.db);
    expect(log.trigger, BackupTrigger.manual);

    final history = await backup.watchHistory().first;
    expect(history, hasLength(1));

    await db.close();
  });

  test('backupAsSql writes a dump containing the schema and data', () async {
    final liveDbFile = await resolveDatabaseFile();
    final db = AppDatabase(NativeDatabase(liveDbFile));
    final ingredients = IngredientRepositoryImpl(db);
    final backup = BackupRepositoryImpl(db);

    await ingredients.create(name: 'Durian', unit: IngredientUnit.gram);

    final log = await backup.backupAsSql(trigger: BackupTrigger.manual);
    final content = await File(log.filePath).readAsString();

    expect(content, contains('CREATE TABLE'));
    expect(content, contains('INSERT INTO "ingredients"'));
    expect(content, contains('Durian'));

    await db.close();
  });

  test(
    'restoreFromFile rolls the live database back to the backed-up state',
    () async {
      final liveDbFile = await resolveDatabaseFile();
      var db = AppDatabase(NativeDatabase(liveDbFile));
      var ingredients = IngredientRepositoryImpl(db);
      var backup = BackupRepositoryImpl(db);

      final durianId = await ingredients.create(
        name: 'Durian',
        unit: IngredientUnit.gram,
      );
      await ingredients.recordPurchase(
        ingredientId: durianId,
        quantity: 5,
        totalPriceRupiah: 25000,
        purchasedAt: DateTime(2026, 1, 1),
      );

      final log = await backup.backupAsDb(trigger: BackupTrigger.manual);

      // Written after the backup — should NOT survive the restore below.
      await ingredients.create(name: 'Ketan', unit: IngredientUnit.gram);
      expect(await ingredients.watchAll().first, hasLength(2));

      await backup.restoreFromFile(log.filePath);

      // restoreFromFile closes `db`; the app would reopen a fresh
      // connection via provider invalidation — mirror that here.
      db = AppDatabase(NativeDatabase(liveDbFile));
      ingredients = IngredientRepositoryImpl(db);

      final restored = await ingredients.watchAll().first;
      expect(restored, hasLength(1));
      expect(restored.single.name, 'Durian');
      expect(restored.single.currentStock, 5);
      expect(restored.single.currentCostPerUnit, 5000);

      await db.close();
    },
  );
}
