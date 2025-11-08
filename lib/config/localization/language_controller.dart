import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final _storage = GetStorage();
  final _key = 'language';
  
  // Observable untuk locale
  final Rx<Locale> _locale = const Locale('en', 'US').obs;
  
  Locale get locale => _locale.value;
  
  @override
  void onInit() {
    super.onInit();
    _loadLanguageFromStorage();
  }
  
  void _loadLanguageFromStorage() {
    final languageCode = _storage.read(_key);
    if (languageCode != null) {
      if (languageCode == 'id') {
        _locale.value = const Locale('id', 'ID');
      } else {
        _locale.value = const Locale('en', 'US');
      }
      Get.updateLocale(_locale.value);
    }
  }
  
  void changeLanguage(String languageCode) {
    if (languageCode == 'id') {
      _locale.value = const Locale('id', 'ID');
    } else {
      _locale.value = const Locale('en', 'US');
    }
    _storage.write(_key, languageCode);
    Get.updateLocale(_locale.value);
  }
  
  void toggleLanguage() {
    if (_locale.value.languageCode == 'en') {
      changeLanguage('id');
    } else {
      changeLanguage('en');
    }
  }
}
