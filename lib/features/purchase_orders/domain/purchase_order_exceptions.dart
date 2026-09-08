import '../../../core/error/app_exception.dart';
import '../../../data/local/app_database.dart';

class PurchaseOrderNotFoundException implements AppException {
  const PurchaseOrderNotFoundException(this.id);

  final int id;

  @override
  String get message => 'PO tidak ditemukan.';

  @override
  String toString() => message;
}

class InvalidPoStatusTransitionException implements AppException {
  const InvalidPoStatusTransitionException(this.from, this.to);

  final PoStatus from;
  final PoStatus to;

  @override
  String get message => 'PO tidak bisa diubah dari status ini.';

  @override
  String toString() => message;
}

class EmptyQuotaException implements AppException {
  const EmptyQuotaException();

  @override
  String get message => 'PO harus punya kuota untuk minimal 1 produk.';

  @override
  String toString() => message;
}

class TodayAlreadyClosedException implements AppException {
  const TodayAlreadyClosedException();

  @override
  String get message =>
      'Pesanan hari ini sudah ditutup. PO baru bisa dibuat besok.';

  @override
  String toString() => message;
}
