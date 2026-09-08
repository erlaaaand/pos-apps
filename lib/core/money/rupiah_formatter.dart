import 'package:intl/intl.dart';

/// Formats whole-Rupiah integer amounts for display (e.g. `Rp12.000`).
///
/// Money is always stored as whole [int] Rupiah (IDR has no commonly used
/// fractional subunit), never as [double], to avoid floating point drift in
/// financial totals — see [AppDatabase] table docs for where this matters.
abstract final class RupiahFormatter {
  static final NumberFormat _format = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  static String format(int amount) => _format.format(amount);
}
