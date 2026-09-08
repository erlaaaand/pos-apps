import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/app_database.dart';
import '../../../data/local/database_provider.dart';
import '../data/ingredient_repository.dart';
import '../data/ingredient_repository_impl.dart';

final ingredientRepositoryProvider = Provider<IngredientRepository>((ref) {
  return IngredientRepositoryImpl(ref.watch(appDatabaseProvider));
});

final ingredientListProvider = StreamProvider<List<Ingredient>>((ref) {
  return ref.watch(ingredientRepositoryProvider).watchAll();
});

final ingredientByIdProvider = StreamProvider.family<Ingredient?, int>((
  ref,
  id,
) {
  return ref.watch(ingredientRepositoryProvider).watchById(id);
});

final ingredientPurchasesProvider =
    StreamProvider.family<List<IngredientPurchase>, int>((ref, ingredientId) {
      return ref
          .watch(ingredientRepositoryProvider)
          .watchPurchases(ingredientId);
    });
