import '../domain/production_preview.dart';
import '../domain/session_cost_input.dart';

/// Abstraction over "processing" a closed PO into a cooking session (B.3):
/// aggregating ingredient needs, checking sufficiency, and confirming which
/// orders actually get cooked.
abstract interface class ProductionRepository {
  /// Aggregates ingredient needs across the PO's waiting orders and checks
  /// them against current stock. Throws [PurchaseOrderNotClosedException] if
  /// the PO isn't `closed`.
  Future<ProductionPreview> preview(int purchaseOrderId);

  /// Confirms "Selesai Masak": deducts realized ingredient stock for exactly
  /// [orderIdsToCook], snapshots each cooked order's HPP, records the
  /// session and its resource costs, cancels the PO's remaining waiting
  /// orders as "bahan baku tidak cukup", and marks the PO `cooked`.
  Future<void> confirmCook({
    required int purchaseOrderId,
    required List<int> orderIdsToCook,
    required List<SessionCostInput> sessionCosts,
  });
}
