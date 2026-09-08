import 'package:flutter/material.dart';

import 'widgets/bottleneck_tab.dart';
import 'widgets/ingredient_price_trend_tab.dart';
import 'widgets/menu_performance_tab.dart';
import 'widgets/po_slot_performance_tab.dart';
import 'widgets/weekly_sales_tab.dart';

/// Bagian C: laporan & analisis, semua dari data pesanan/penjualan internal
/// sendiri (bukan riset pasar eksternal — aplikasi tidak terhubung ke
/// sumber data luar).
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Laporan'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Tren Penjualan'),
              Tab(text: 'Performa Slot'),
              Tab(text: 'Performa Menu'),
              Tab(text: 'Bottleneck Bahan'),
              Tab(text: 'Tren Harga Beli'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            WeeklySalesTab(),
            PoSlotPerformanceTab(),
            MenuPerformanceTab(),
            BottleneckTab(),
            IngredientPriceTrendTab(),
          ],
        ),
      ),
    );
  }
}
