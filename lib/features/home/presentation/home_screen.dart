import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/date/date_only.dart';
import '../../../core/branding/app_logo.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_metric_card.dart';
import '../../../core/widgets/app_nav_card.dart';
import '../../../core/widgets/app_section_header.dart';
import '../../../data/local/app_database.dart';
import '../../daily_closing/application/daily_closing_providers.dart';
import '../../ingredients/application/ingredient_providers.dart';
import '../../products/application/product_providers.dart';
import '../../purchase_orders/application/purchase_order_providers.dart';

/// Beranda — mengikuti tata letak referensi: header gradasi hangat yang
/// meluruh ke warna latar, tiga metrik ringkas, lalu seksi pintasan.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredientCount = ref.watch(ingredientListProvider).value?.length;
    final productCount = ref
        .watch(productsWithActiveRecipeProvider)
        .value
        ?.length;
    final openPoCount = ref
        .watch(purchaseOrderListProvider)
        .value
        ?.where((po) => po.status == PoStatus.open)
        .length;

    // Status toko diambil dari data nyata: hari ini sudah ditutup atau belum.
    final today = dateOnly(DateTime.now());
    final isDayClosed =
        ref
            .watch(dailyClosingHistoryProvider)
            .value
            ?.any((closing) => dateOnly(closing.date) == today) ??
        false;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _Header(isDayClosed: isDayClosed)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.xl,
            ),
            sliver: SliverList.list(
              children: [
                const AppSectionHeader(
                  title: 'Ringkasan Operasional',
                  icon: Icons.insights_outlined,
                  trailingLabel: 'Real-time',
                ),
                const SizedBox(height: AppSpacing.compact),
                // IntrinsicHeight memberi ketiga kartu tinggi yang sama tanpa
                // memaksa tinggi tak hingga di dalam sliver.
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: AppMetricCard(
                          icon: Icons.receipt_long_outlined,
                          value: openPoCount == null ? '—' : '$openPoCount',
                          label: 'PO Aktif',
                          onTap: () => context.go('/purchase-orders'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.compact),
                      Expanded(
                        child: AppMetricCard(
                          icon: Icons.inventory_2_outlined,
                          value: ingredientCount == null
                              ? '—'
                              : '$ingredientCount',
                          label: 'Bahan Baku',
                          onTap: () => context.go('/ingredients'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.compact),
                      Expanded(
                        child: AppMetricCard(
                          icon: Icons.restaurant_menu_outlined,
                          value: productCount == null ? '—' : '$productCount',
                          label: 'Produk',
                          onTap: () => context.go('/products'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.section),
                const AppSectionHeader(
                  title: 'Operasional Harian',
                  icon: Icons.calendar_month_outlined,
                ),
                const SizedBox(height: AppSpacing.compact),
                AppNavCard(
                  icon: Icons.receipt_long_outlined,
                  title: 'PO Harian',
                  subtitle: 'Buat & kelola purchase order hari ini',
                  badge: 'Utama',
                  onTap: () => context.go('/purchase-orders'),
                ),
                const SizedBox(height: AppSpacing.compact),
                AppNavCard(
                  icon: Icons.lock_clock_outlined,
                  title: 'Tutup Pesanan Hari Ini',
                  subtitle: 'Ringkasan laba rugi & tutup hari',
                  tint: AppColors.secondary,
                  onTap: () => context.push('/daily-closing'),
                ),

                const SizedBox(height: AppSpacing.section),
                const AppSectionHeader(
                  title: 'Manajemen',
                  icon: Icons.storefront_outlined,
                ),
                const SizedBox(height: AppSpacing.compact),
                AppNavCard(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Manajemen Keuangan',
                  subtitle: 'Modal kerja, arus kas mingguan, BEP & target',
                  onTap: () => context.push('/finance'),
                ),
                const SizedBox(height: AppSpacing.compact),
                AppNavCard(
                  icon: Icons.bar_chart_outlined,
                  title: 'Laporan & Analitik',
                  subtitle: 'Tren penjualan, performa menu, bottleneck bahan',
                  tint: AppColors.success,
                  onTap: () => context.push('/analytics'),
                ),

                const SizedBox(height: AppSpacing.section),
                const AppSectionHeader(
                  title: 'Sistem',
                  icon: Icons.settings_outlined,
                ),
                const SizedBox(height: AppSpacing.compact),
                AppNavCard(
                  icon: Icons.backup_outlined,
                  title: 'Backup & Restore',
                  subtitle: 'Salinan data, pulihkan dari file',
                  tint: AppColors.neutral,
                  onTap: () => context.push('/backup'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Header gradasi yang meluruh ke warna latar halaman, persis seperti
/// referensi (`from-[#D96B00] via-[#E87800] to-[#FAF7F3]`).
class _Header extends StatelessWidget {
  const _Header({required this.isDayClosed});

  final bool isDayClosed;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.headerGradientTop,
            AppColors.headerGradientMid,
            AppColors.headerGradientBottom,
          ],
          stops: [0, 0.55, 1],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 56,
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.20),
                        borderRadius: AppRadius.cardRadius,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                        ),
                      ),
                      child: const Center(
                        child: AppLogo(
                          size: 30,
                          showContainer: false,
                          glyphColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm + 2),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppBrand.nameUpper,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.85),
                                letterSpacing: 1.2,
                              ),
                        ),
                        Text(
                          'Beranda Bisnis',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.compact),
              _HeroCard(isDayClosed: isDayClosed, now: now),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.isDayClosed, required this.now});

  final bool isDayClosed;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.20),
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _StatusPill(isDayClosed: isDayClosed),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _greeting(now.hour),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(now),
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.compact),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: AppRadius.lgRadius,
            ),
            child: const Icon(Icons.restaurant, size: 26, color: Colors.white),
          ),
        ],
      ),
    );
  }

  String _greeting(int hour) {
    if (hour < 11) return 'Selamat Pagi!';
    if (hour < 15) return 'Selamat Siang!';
    if (hour < 18) return 'Selamat Sore!';
    return 'Selamat Malam!';
  }
}

/// Menandai apakah hari ini masih menerima pesanan — dibaca dari ada/tidaknya
/// catatan tutup harian, bukan status karangan.
class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.isDayClosed});

  final bool isDayClosed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        borderRadius: AppRadius.pillRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDayClosed
                  ? Colors.white.withValues(alpha: 0.7)
                  : const Color(0xFF6EE7B7),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isDayClosed ? 'Pesanan Hari Ini Ditutup' : 'Menerima Pesanan',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.95),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
