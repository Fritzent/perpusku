import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:perpusku/app.dart';
import 'package:perpusku/core/constant/app_constant.dart';
import 'package:perpusku/core/utils/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  await Supabase.initialize(url: AppConstants.supabaseUrl, publishableKey: AppConstants.supabasePublishedKey, debug: false);

  await setupDependencies();

  final prefs = await SharedPreferences.getInstance();
  final locale = prefs.getString(AppConstants.keyLocale) ??
      AppConstants.defaultLocale;

  runApp(App(initialLocale: Locale(locale)));
}
