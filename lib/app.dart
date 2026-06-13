
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:perpusku/core/constant/app_constant.dart';
import 'package:perpusku/core/router/app_router.dart';
import 'package:perpusku/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  final Locale initialLocale;

  const App({super.key, required this.initialLocale});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  void setLocale(Locale locale) {
    setState(() => _locale = locale);
    SharedPreferences.getInstance().then(
      (p) => p.setString(AppConstants.keyLocale, locale.languageCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Perpusku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('id'),
      ],
      routerConfig: appRouter,
    );
  }
}

