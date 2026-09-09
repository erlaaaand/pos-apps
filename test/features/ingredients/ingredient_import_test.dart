import 'dart:typed_data';

import 'package:dapur_kelaris/data/local/app_database.dart';
import 'package:dapur_kelaris/features/ingredients/data/ingredient_repository_impl.dart';
import 'package:dapur_kelaris/features/ingredients/domain/ingredient_import_parser.dart';
import 'package:drift/native.dart';
import 'package:excel/excel.dart';
import 'package:flutter_test/flutter_test.dart';

/// Impor massal bahan baku dari Excel (update.md). Parsing dites terpisah dari
/// penulisan database supaya jelas: file yang bermasalah harus ketahuan
/// SEBELUM apa pun ditulis.
void main() {
  Uint8List buildWorkbook(List<List<String?>> rows) {
    final workbook = Excel.createExcel();
    final sheet = workbook[workbook.getDefaultSheet()!];
    for (final row in rows) {
      sheet.appendRow([
        for (final cell in row)
          if (cell == null) null else TextCellValue(cell),
      ]);
    }
    return Uint8List.fromList(workbook.encode()!);
  }

  group('parseIngredientImport', () {
    test('reads valid rows and skips the header', () {
      final bytes = buildWorkbook([
        ['Nama Bahan', 'Satuan', 'Kategori'],
        ['Durian', 'kg', 'Buah'],
        ['Gula Pasir', 'Gram', 'Bumbu'],
      ]);

      final preview = parseIngredientImport(bytes, existingNames: {});

      expect(preview.rows, hasLength(2));
      expect(preview.rows.first.name, 'Durian');
      expect(preview.rows.first.unit, IngredientUnit.kilogram);
      expect(preview.rows.first.categoryName, 'Buah');
      expect(preview.rows.last.unit, IngredientUnit.gram);
      expect(preview.issues, isEmpty);
    });

    test('accepts long, short, and enum spellings of a unit', () {
      final bytes = buildWorkbook([
        ['Nama Bahan', 'Satuan', 'Kategori'],
        ['A', 'Sendok Makan', null],
        ['B', 'sdm', null],
        ['C', 'sendokMakan', null],
      ]);

      final preview = parseIngredientImport(bytes, existingNames: {});

      expect(preview.rows, hasLength(3));
      expect(
        preview.rows.every((row) => row.unit == IngredientUnit.sendokMakan),
        isTrue,
      );
    });

    test('flags an unknown unit instead of guessing', () {
      final bytes = buildWorkbook([
        ['Nama Bahan', 'Satuan', 'Kategori'],
        ['Durian', 'karung', 'Buah'],
      ]);

      final preview = parseIngredientImport(bytes, existingNames: {});

      expect(preview.rows, isEmpty);
      expect(preview.issues, hasLength(1));
      expect(preview.issues.single.reason, contains('karung'));
      expect(preview.issues.single.rowNumber, 2);
    });

    test('flags names that already exist in the database', () {
      final bytes = buildWorkbook([
        ['Nama Bahan', 'Satuan', 'Kategori'],
        ['Durian', 'kg', 'Buah'],
      ]);

      final preview = parseIngredientImport(bytes, existingNames: {'durian'});

      expect(preview.rows, isEmpty);
      expect(preview.issues.single.reason, contains('sudah terdaftar'));
    });

    test('flags a name repeated twice inside the same file', () {
      final bytes = buildWorkbook([
        ['Nama Bahan', 'Satuan', 'Kategori'],
        ['Durian', 'kg', 'Buah'],
        ['durian', 'gram', 'Buah'],
      ]);

      final preview = parseIngredientImport(bytes, existingNames: {});

      expect(preview.rows, hasLength(1));
      expect(preview.issues, hasLength(1));
      expect(preview.issues.single.rowNumber, 3);
    });

    test('reports unreadable files instead of throwing', () {
      final preview = parseIngredientImport(
        Uint8List.fromList([1, 2, 3, 4]),
        existingNames: {},
      );

      expect(preview.rows, isEmpty);
      expect(preview.issues, isNotEmpty);
    });
  });

  group('importIngredients', () {
    late AppDatabase db;
    late IngredientRepositoryImpl repository;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repository = IngredientRepositoryImpl(db);
    });

    tearDown(() => db.close());

    test('inserts rows and creates referenced categories once', () async {
      final bytes = buildWorkbook([
        ['Nama Bahan', 'Satuan', 'Kategori'],
        ['Durian', 'kg', 'Buah'],
        ['Nangka', 'kg', 'Buah'],
        ['Cup 22oz', 'pcs', 'Kemasan'],
      ]);
      final preview = parseIngredientImport(bytes, existingNames: {});

      final inserted = await repository.importIngredients(preview.rows);

      expect(inserted, 3);
      final ingredients = await db.select(db.ingredients).get();
      expect(ingredients, hasLength(3));

      final categories = await db.select(db.ingredientCategories).get();
      expect(
        categories.map((c) => c.name),
        containsAll(<String>['Buah', 'Kemasan']),
      );
      expect(
        categories,
        hasLength(2),
        reason: '"Buah" muncul dua kali di file tapi hanya dibuat sekali',
      );

      final durian = ingredients.firstWhere((i) => i.name == 'Durian');
      final buah = categories.firstWhere((c) => c.name == 'Buah');
      expect(durian.categoryId, buah.id);
    });

    test('leaves category empty when the column is blank', () async {
      final bytes = buildWorkbook([
        ['Nama Bahan', 'Satuan', 'Kategori'],
        ['Durian', 'kg', null],
      ]);
      final preview = parseIngredientImport(bytes, existingNames: {});

      await repository.importIngredients(preview.rows);

      final durian = await db.select(db.ingredients).getSingle();
      expect(durian.categoryId, isNull);
      expect(await db.select(db.ingredientCategories).get(), isEmpty);
    });
  });
}
