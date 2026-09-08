import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/app_database.dart';
import '../../../data/local/database_provider.dart';
import '../data/purchase_order_repository.dart';
import '../data/purchase_order_repository_impl.dart';
import '../domain/po_quota_status.dart';

final purchaseOrderRepositoryProvider = Provider<PurchaseOrderRepository>((
  ref,
) {
  return PurchaseOrderRepositoryImpl(ref.watch(appDatabaseProvider));
});

final purchaseOrderListProvider = StreamProvider<List<PurchaseOrderBatch>>((
  ref,
) {
  return ref.watch(purchaseOrderRepositoryProvider).watchAll();
});

final purchaseOrderByIdProvider = StreamProvider.family<PurchaseOrderBatch?, int>(
  (ref, id) {
    return ref.watch(purchaseOrderRepositoryProvider).watchById(id);
  },
);

final poQuotaStatusProvider = StreamProvider.family<List<PoQuotaStatus>, int>((
  ref,
  purchaseOrderId,
) {
  return ref
      .watch(purchaseOrderRepositoryProvider)
      .watchQuotaStatus(purchaseOrderId);
});
