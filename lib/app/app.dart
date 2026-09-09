import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/branding/app_logo.dart';
import '../core/theme/app_theme.dart';
import '../features/settings/application/settings_providers.dart';
import 'router.dart';

class BusinessManagementApp extends ConsumerWidget {
  const BusinessManagementApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Selama pilihan tema belum terbaca (atau gagal dibaca), ikuti setelan
    // HP. Tema bukan data bisnis — lebih baik menggambar dengan tebakan yang
    // wajar daripada menahan seluruh aplikasi menunggu database.
    final themeMode = ref
        .watch(themeModeProvider)
        .maybeWhen(data: (mode) => mode, orElse: () => ThemeMode.system);

    return MaterialApp.router(
      title: AppBrand.name,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: appRouter,
      locale: const Locale('id', 'ID'),
      supportedLocales: const [Locale('id', 'ID')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
