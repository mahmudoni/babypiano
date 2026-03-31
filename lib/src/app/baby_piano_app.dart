import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../core/providers/bootstrap_providers.dart';
import '../core/theme/app_theme.dart';
import 'app_router.dart';

class BabyPianoApp extends ConsumerWidget {
  const BabyPianoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);

    return MaterialApp.router(
      title: config.appName,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme.light(),
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (BuildContext context, Widget? child) {
        final appChild = child ?? const SizedBox.shrink();
        if (config.showEnvironmentRibbon) {
          return Banner(
            message: config.environmentLabel,
            location: BannerLocation.topEnd,
            child: appChild,
          );
        }

        return appChild;
      },
    );
  }
}
