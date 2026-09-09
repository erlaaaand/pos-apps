import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/analytics/presentation/analytics_screen.dart';
import '../features/backup/presentation/backup_screen.dart';
import '../features/daily_closing/presentation/daily_closing_screen.dart';
import '../features/finance/presentation/finance_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/ingredients/presentation/ingredient_detail_screen.dart';
import '../features/ingredients/presentation/ingredient_list_screen.dart';
import '../features/orders/presentation/order_form_screen.dart';
import '../features/production/presentation/production_screen.dart';
import '../features/products/presentation/product_detail_screen.dart';
import '../features/products/presentation/product_list_screen.dart';
import '../features/products/presentation/recipe_form_screen.dart';
import '../features/purchase_orders/presentation/purchase_order_detail_screen.dart';
import '../features/purchase_orders/presentation/purchase_order_form_screen.dart';
import '../features/purchase_orders/presentation/purchase_order_list_screen.dart';
import 'app_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/purchase-orders',
              builder: (context, state) => const PurchaseOrderListScreen(),
              routes: [
                GoRoute(
                  path: 'new',
                  builder: (context, state) => const PurchaseOrderFormScreen(),
                ),
                GoRoute(
                  path: ':id',
                  builder: (context, state) {
                    final id = int.tryParse(state.pathParameters['id'] ?? '');
                    if (id == null) return const PurchaseOrderListScreen();
                    return PurchaseOrderDetailScreen(purchaseOrderId: id);
                  },
                  routes: [
                    GoRoute(
                      path: 'orders/new',
                      builder: (context, state) {
                        final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
                        return OrderFormScreen(purchaseOrderId: id);
                      },
                    ),
                    GoRoute(
                      path: 'production',
                      builder: (context, state) {
                        final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
                        return ProductionScreen(purchaseOrderId: id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/ingredients',
              builder: (context, state) => const IngredientListScreen(),
              routes: [
                // Tambah/ubah bahan dan catat pembelian sekarang berupa
                // bottom sheet (update.md), jadi tidak lagi punya rute
                // sendiri — sekaligus menghilangkan cast `state.extra`
                // yang dulu bisa gagal kalau rutenya dibuka lewat deep link.
                GoRoute(
                  path: ':id',
                  builder: (context, state) {
                    final id = int.tryParse(state.pathParameters['id'] ?? '');
                    if (id == null) return const IngredientListScreen();
                    return IngredientDetailScreen(ingredientId: id);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/products',
              builder: (context, state) => const ProductListScreen(),
              routes: [
                GoRoute(
                  path: 'new',
                  builder: (context, state) => const RecipeFormScreen(),
                ),
                GoRoute(
                  path: ':id',
                  builder: (context, state) {
                    final id = int.tryParse(state.pathParameters['id'] ?? '');
                    if (id == null) return const ProductListScreen();
                    return ProductDetailScreen(productId: id);
                  },
                  routes: [
                    GoRoute(
                      path: 'new-recipe',
                      builder: (context, state) =>
                          RecipeFormScreen(args: state.extra as RecipeFormArgs),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/daily-closing',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const DailyClosingScreen(),
    ),
    GoRoute(
      path: '/analytics',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AnalyticsScreen(),
    ),
    GoRoute(
      path: '/backup',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const BackupScreen(),
    ),
    GoRoute(
      path: '/finance',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const FinanceScreen(),
    ),
  ],
);
