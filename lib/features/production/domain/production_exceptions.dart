import '../../../core/error/app_exception.dart';

class PurchaseOrderNotClosedException implements AppException {
  const PurchaseOrderNotClosedException();

  @override
  String get message => 'PO harus berstatus Tutup sebelum diproses produksi.';

  @override
  String toString() => message;
}

/// Defensive check inside the confirm-cook transaction — should not happen
/// if the UI's preview was fresh, but guards against stale data (e.g. stock
/// changed from another action between preview and confirm).
class StockChangedSinceSelectionException implements AppException {
  const StockChangedSinceSelectionException();

  @override
  String get message =>
      'Stok bahan berubah sejak terakhir dicek. Muat ulang dan coba lagi.';

  @override
  String toString() => message;
}
