import 'dart:typed_data';

import 'package:excel/excel.dart';

import '../../../data/local/app_database.dart';
import 'ingredient_import_row.dart';
import 'ingredient_unit_label.dart';

/// Kolom yang diharapkan di file impor, dipakai juga untuk membuat template.
const List<String> kIngredientImportHeaders = [
  'Nama Bahan',
  'Satuan',
  'Kategori',
];

/// Membaca file Excel impor bahan baku (update.md) menjadi daftar baris valid
/// + daftar masalah.
///
/// Fungsi ini murni: tidak menyentuh database sama sekali. Nama yang sudah ada
/// diberikan lewat [existingNames] supaya pemilik bisa melihat dulu baris mana
/// yang akan ditolak sebelum apa pun ditulis.
IngredientImportPreview parseIngredientImport(
  Uint8List bytes, {
  required Set<String> existingNames,
}) {
  final Excel workbook;
  try {
    workbook = Excel.decodeBytes(bytes);
  } catch (_) {
    return const IngredientImportPreview(
      rows: [],
      issues: [
        IngredientImportIssue(
          rowNumber: 0,
          reason: 'File tidak terbaca sebagai Excel (.xlsx).',
        ),
      ],
    );
  }

  if (workbook.tables.isEmpty) {
    return const IngredientImportPreview(
      rows: [],
      issues: [
        IngredientImportIssue(rowNumber: 0, reason: 'File tidak punya sheet.'),
      ],
    );
  }

  final sheet = workbook.tables[workbook.tables.keys.first]!;
  final rows = <IngredientImportRow>[];
  final issues = <IngredientImportIssue>[];

  // Nama yang sudah ada di database + yang sudah dipakai baris sebelumnya di
  // file yang sama, supaya duplikat di dalam file ikut tertangkap.
  final takenNames = existingNames.map((name) => name.toLowerCase()).toSet();

  for (var index = 0; index < sheet.rows.length; index++) {
    final rowNumber = index + 1;
    final cells = sheet.rows[index];

    final name = _cellText(cells, 0);
    final unitText = _cellText(cells, 1);
    final categoryName = _cellText(cells, 2);

    // Lewati baris kosong dan baris header tanpa menganggapnya error.
    if (name == null && unitText == null && categoryName == null) continue;
    if (index == 0 && _looksLikeHeader(name, unitText)) continue;

    if (name == null || name.isEmpty) {
      issues.add(
        IngredientImportIssue(
          rowNumber: rowNumber,
          reason: 'Nama bahan kosong.',
        ),
      );
      continue;
    }

    if (takenNames.contains(name.toLowerCase())) {
      issues.add(
        IngredientImportIssue(
          rowNumber: rowNumber,
          reason: '"$name" sudah terdaftar, baris dilewati.',
        ),
      );
      continue;
    }

    final unit = _resolveUnit(unitText);
    if (unit == null) {
      issues.add(
        IngredientImportIssue(
          rowNumber: rowNumber,
          reason: unitText == null || unitText.isEmpty
              ? 'Satuan kosong untuk "$name".'
              : 'Satuan "$unitText" tidak dikenal untuk "$name".',
        ),
      );
      continue;
    }

    takenNames.add(name.toLowerCase());
    rows.add(
      IngredientImportRow(
        rowNumber: rowNumber,
        name: name,
        unit: unit,
        categoryName: (categoryName == null || categoryName.isEmpty)
            ? null
            : categoryName,
      ),
    );
  }

  if (rows.isEmpty && issues.isEmpty) {
    issues.add(
      const IngredientImportIssue(
        rowNumber: 0,
        reason: 'Tidak ada baris data yang bisa diimpor.',
      ),
    );
  }

  return IngredientImportPreview(rows: rows, issues: issues);
}

/// Menerima nama panjang ("Kilogram"), singkatan ("kg"), atau nama enum
/// ("kilogram") — pemilik tidak harus hafal satu bentuk saja.
IngredientUnit? _resolveUnit(String? text) {
  if (text == null) return null;
  final needle = text.trim().toLowerCase();
  if (needle.isEmpty) return null;

  if (needle == 'pemakaian' || needle == 'porsi' || needle == 'kali') {
    return IngredientUnit.pcs;
  }

  for (final unit in IngredientUnit.values) {
    if (unit.label.toLowerCase() == needle ||
        unit.shortLabel.toLowerCase() == needle ||
        unit.name.toLowerCase() == needle) {
      return unit;
    }
  }
  return null;
}

bool _looksLikeHeader(String? first, String? second) {
  final a = first?.toLowerCase() ?? '';
  final b = second?.toLowerCase() ?? '';
  return a.contains('nama') || b.contains('satuan');
}

String? _cellText(List<Data?> cells, int index) {
  if (index >= cells.length) return null;
  final value = cells[index]?.value;
  if (value == null) return null;

  // `CellValue` is sealed; every variant's toString() yields the plain text we
  // want (TextSpan.toString() concatenates its runs), so the default branch is
  // safe for the numeric/date cases too.
  final text = switch (value) {
    TextCellValue() => value.value.toString(),
    IntCellValue() => value.value.toString(),
    DoubleCellValue() => value.value.toString(),
    _ => value.toString(),
  };
  final trimmed = text.trim();
  return trimmed.isEmpty ? null : trimmed;
}
