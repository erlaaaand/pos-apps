import '../../../core/error/app_exception.dart';

class DuplicateProductNameException implements AppException {
  const DuplicateProductNameException(this.name);

  final String name;

  @override
  String get message => 'Produk dengan nama "$name" sudah ada.';

  @override
  String toString() => message;
}

class EmptyRecipeException implements AppException {
  const EmptyRecipeException();

  @override
  String get message => 'Resep harus punya minimal 1 bahan baku.';

  @override
  String toString() => message;
}

class ProductNotFoundException implements AppException {
  const ProductNotFoundException(this.productId);

  final int productId;

  @override
  String get message => 'Produk tidak ditemukan.';

  @override
  String toString() => message;
}
