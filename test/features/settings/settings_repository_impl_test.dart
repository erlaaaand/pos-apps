import 'package:dapur_kelaris/data/local/app_database.dart';
import 'package:dapur_kelaris/features/settings/data/settings_repository_impl.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late SettingsRepositoryImpl repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = SettingsRepositoryImpl(db);
  });

  tearDown(() => db.close());

  test('defaults to following the phone when nothing is saved', () async {
    expect(await repository.watchThemeMode().first, ThemeMode.system);
  });

  test('saves and reads back each mode', () async {
    for (final mode in ThemeMode.values) {
      await repository.setThemeMode(mode);
      expect(await repository.watchThemeMode().first, mode);
    }
  });

  test('overwrites the previous choice instead of adding a row', () async {
    await repository.setThemeMode(ThemeMode.dark);
    await repository.setThemeMode(ThemeMode.light);

    expect(await repository.watchThemeMode().first, ThemeMode.light);
    expect(
      await db.select(db.appSettings).get(),
      hasLength(1),
      reason: 'satu kunci hanya boleh punya satu baris',
    );
  });

  test('falls back to system for an unreadable stored value', () async {
    // Meniru baris rusak dari pemulihan cadangan lama: aplikasi harus tetap
    // terbuka, bukan gagal karena nilai tema yang tidak dikenali.
    await db
        .into(db.appSettings)
        .insert(AppSettingsCompanion.insert(key: 'theme_mode', value: 'neon'));

    expect(await repository.watchThemeMode().first, ThemeMode.system);
  });
}
