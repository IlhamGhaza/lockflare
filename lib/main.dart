import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'config/theme/theme_controller.dart';
import 'config/theme/theme.dart';
import 'config/localization/app_translations.dart';
import 'config/localization/language_controller.dart';
import 'main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize Controllers
    final themeController = Get.put(ThemeController());
    final languageController = Get.put(LanguageController());
    
    return GetMaterialApp(
      title: 'LockFlare',
      debugShowCheckedModeBanner: false,
      
      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.themeMode,
      
      // Localization configuration
      translations: AppTranslations(),
      locale: Get.deviceLocale, // Use device locale
      fallbackLocale: const Locale('en', 'US'),
      
      home: const MainPage(),
    );
  }
}
