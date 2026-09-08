/// Generic tabular shape every exportable report reduces itself to, so
/// export logic is written once instead of per report screen.
class ReportTable {
  const ReportTable({required this.headers, required this.rows});

  final List<String> headers;
  final List<List<Object?>> rows;
}

enum ExportFormat { csv, xlsx }
