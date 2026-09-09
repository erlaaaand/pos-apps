import 'package:flutter/material.dart';

import 'widgets/bep_tab.dart';
import 'widgets/capital_tab.dart';
import 'widgets/weekly_cash_flow_tab.dart';
import 'widgets/weekly_target_tab.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manajemen Keuangan'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                icon: Icon(Icons.account_balance_wallet_outlined),
                text: 'Modal & Alat',
              ),
              Tab(icon: Icon(Icons.waterfall_chart_outlined), text: 'Arus Kas'),
              Tab(icon: Icon(Icons.analytics_outlined), text: 'BEP & MoS'),
              Tab(
                icon: Icon(Icons.track_changes_outlined),
                text: 'Rekap Target',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CapitalTab(),
            WeeklyCashFlowTab(),
            BepTab(),
            WeeklyTargetTab(),
          ],
        ),
      ),
    );
  }
}
