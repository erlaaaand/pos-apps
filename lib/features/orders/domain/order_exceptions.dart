import '../../../core/error/app_exception.dart';

class PurchaseOrderNotOpenException implements AppException {
  const PurchaseOrderNotOpenException();

  @override
  String get message => 'PO ini sedang tidak Buka, tidak bisa menerima pesanan.';

  @override
  String toString() => message;
}

class ProductNotActiveException implements AppException {
  const ProductNotActiveException(this.productName);

  final String productName;

  @override
  String get message => '$productName sedang nonaktif dan tidak bisa dipesan.';

  @override
  String toString() => message;
}

class NoActiveRecipeException implements AppException {
  const NoActiveRecipeException(this.productName);

  final String productName;

  @override
  String get message => '$productName belum punya resep aktif.';

  @override
  String toString() => message;
}

class OrderNotFoundException implements AppException {
  const OrderNotFoundException(this.id);

  final int id;

  @override
  String get message => 'Pesanan tidak ditemukan.';

  @override
  String toString() => message;
}

class InvalidOrderStatusTransitionException implements AppException {
  const InvalidOrderStatusTransitionException();

  @override
  String get message => 'Status pesanan ini tidak bisa diubah dari kondisi sekarang.';

  @override
  String toString() => message;
}
