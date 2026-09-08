import '../../../data/local/app_database.dart';
import '../domain/po_quota_input.dart';
import '../domain/po_quota_status.dart';

/// Abstraction over PO batches (B.1) and their per-product quotas.
abstract interface class PurchaseOrderRepository {
  Stream<List<PurchaseOrderBatch>> watchAll();

  Stream<PurchaseOrderBatch?> watchById(int id);

  Future<PurchaseOrderBatch?> getById(int id);

  Stream<List<PoQuotaStatus>> watchQuotaStatus(int purchaseOrderId);

  /// Creates a PO in `draft` status with its per-product quotas. Throws
  /// [TodayAlreadyClosedException] if today's orders are already closed
  /// (B.5), [EmptyQuotaException] if [quotas] is empty.
  Future<int> create({required String label, required List<PoQuotaInput> quotas});

  /// draft → open, sets openedAt to now.
  Future<void> open(int purchaseOrderId);

  /// open → closed, sets closedAt to now. After this, orders can no longer
  /// be added (B.2) and the PO is ready for production (B.3).
  Future<void> close(int purchaseOrderId);
}
