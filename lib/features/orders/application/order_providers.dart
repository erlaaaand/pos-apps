import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/database_provider.dart';
import '../data/order_repository.dart';
import '../data/order_repository_impl.dart';
import '../domain/order_detail.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl(ref.watch(appDatabaseProvider));
});

final ordersByPurchaseOrderProvider =
    StreamProvider.family<List<OrderDetail>, int>((ref, purchaseOrderId) {
      return ref
          .watch(orderRepositoryProvider)
          .watchByPurchaseOrder(purchaseOrderId);
    });

final waitingOrdersByPurchaseOrderProvider =
    StreamProvider.family<List<OrderDetail>, int>((ref, purchaseOrderId) {
      return ref
          .watch(orderRepositoryProvider)
          .watchWaitingByPurchaseOrder(purchaseOrderId);
    });
