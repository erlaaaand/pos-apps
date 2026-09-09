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

/// Thrown when a purchase batch is submitted with no ingredient lines.
class EmptyPurchaseBatchException implements AppException {
  const EmptyPurchaseBatchException();

  @override
  String get message => 'Belanja harus berisi minimal 1 bahan.';

  @override
  String toString() => message;
}

/// Thrown when the per-ingredient cost split does not add up to the amount
/// actually paid — letting this through would corrupt every affected
/// ingredient's weighted-average cost.
class BatchAllocationMismatchException implements AppException {
  const BatchAllocationMismatchException({
    required this.expectedRupiah,
    required this.actualRupiah,
  });

  final int expectedRupiah;
  final int actualRupiah;

  @override
  String get message =>
      'Pembagian biaya belum pas: total alokasi Rp$actualRupiah, '
      'sedangkan yang dibayar Rp$expectedRupiah.';

  @override
  String toString() => message;
}

/// Thrown when creating an ingredient category whose name already exists.
class DuplicateIngredientCategoryException implements AppException {
  const DuplicateIngredientCategoryException(this.name);

  final String name;

  @override
  String get message => 'Kategori "$name" sudah ada.';

  @override
  String toString() => message;
}

/// Thrown when an ingredient category still has ingredients attached to it.
class IngredientCategoryInUseException implements AppException {
  const IngredientCategoryInUseException(this.categoryId);

  final int categoryId;

  @override
  String get message =>
      'Kategori ini masih dipakai bahan baku, jadi belum bisa dihapus.';

  @override
  String toString() => message;
}
