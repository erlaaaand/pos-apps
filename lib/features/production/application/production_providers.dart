import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/database_provider.dart';
import '../data/production_repository.dart';
import '../data/production_repository_impl.dart';
import '../domain/production_preview.dart';

final productionRepositoryProvider = Provider<ProductionRepository>((ref) {
  return ProductionRepositoryImpl(ref.watch(appDatabaseProvider));
});

final productionPreviewProvider = FutureProvider.family<ProductionPreview, int>(
  (ref, purchaseOrderId) {
    return ref.watch(productionRepositoryProvider).preview(purchaseOrderId);
  },
);
