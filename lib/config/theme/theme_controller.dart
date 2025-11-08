import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _storage = GetStorage();
  final _key = 'isDarkMode';
  
  // Observable untuk theme mode
  final Rx<ThemeMode> _themeMode = ThemeMode.light.obs;
  
  ThemeMode get themeMode => _themeMode.value;
  bool get isDarkMode => _themeMode.value == ThemeMode.dark;
  
  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }
  
  void _loadThemeFromStorage() {
    final isDark = _storage.read(_key);
    if (isDark != null) {
      _themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    }
  }
  
  void toggleTheme() {
    if (_themeMode.value == ThemeMode.light) {
      _themeMode.value = ThemeMode.dark;
      _storage.write(_key, true);
    } else {
      _themeMode.value = ThemeMode.light;
      _storage.write(_key, false);
    }
    Get.changeThemeMode(_themeMode.value);
  }
  
  void setThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    _storage.write(_key, mode == ThemeMode.dark);
    Get.changeThemeMode(mode);
  }
}
