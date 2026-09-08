import '../../../core/error/app_exception.dart';

/// Thrown when trying to delete an ingredient that already has purchase
/// history or is referenced by at least one recipe — deleting it would break
/// traceability that erp.md requires ("setiap entitas ... bisa ditelusuri").
class IngredientInUseException implements AppException {
  const IngredientInUseException(this.ingredientId);

  final int ingredientId;

  @override
  String get message =>
      'Bahan baku ini tidak bisa dihapus karena sudah punya riwayat pembelian atau dipakai di resep.';

  @override
  String toString() => message;
}

/// Thrown when an operation references an ingredient id that no longer
/// exists.
class IngredientNotFoundException implements AppException {
  const IngredientNotFoundException(this.ingredientId);

  final int ingredientId;

  @override
  String get message => 'Bahan baku tidak ditemukan.';

  @override
  String toString() => message;
}

/// Thrown when trying to create an ingredient whose name already exists.
class DuplicateIngredientNameException implements AppException {
  const DuplicateIngredientNameException(this.name);

  final String name;

  @override
  String get message => 'Bahan baku dengan nama "$name" sudah ada.';

  @override
  String toString() => message;
}
