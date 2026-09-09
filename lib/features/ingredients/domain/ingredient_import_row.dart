import '../../../data/local/app_database.dart';

/// Satu baris hasil parsing file Excel impor bahan baku (update.md).
class IngredientImportRow {
  const IngredientImportRow({
    required this.rowNumber,
    required this.name,
    required this.unit,
    this.categoryName,
  });

  /// Nomor baris di file asli (1-based, termasuk header) supaya pesan error
  /// bisa menunjuk baris yang salah.
  final int rowNumber;
  final String name;
  final IngredientUnit unit;
  final String? categoryName;
}

/// Baris yang ditolak beserta alasannya — ditampilkan ke pemilik sebelum
/// impor dijalankan, bukan dilewati diam-diam.
class IngredientImportIssue {
  const IngredientImportIssue({required this.rowNumber, required this.reason});

  final int rowNumber;
  final String reason;
}

/// Hasil parsing: baris valid + baris bermasalah. Impor tidak pernah menulis
/// sebelum pemilik melihat ringkasan ini.
class IngredientImportPreview {
  const IngredientImportPreview({required this.rows, required this.issues});

  final List<IngredientImportRow> rows;
  final List<IngredientImportIssue> issues;

  bool get hasRows => rows.isNotEmpty;
  bool get hasIssues => issues.isNotEmpty;
}
