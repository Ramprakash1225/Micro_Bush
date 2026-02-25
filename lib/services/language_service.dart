import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/logging_service.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;
  bool get isEnglish => _currentLocale.languageCode == 'en';
  bool get isTamil => _currentLocale.languageCode == 'ta';

  LanguageService() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey);
      if (savedLanguage != null) {
        _currentLocale = Locale(savedLanguage);
        notifyListeners();
        LoggingService.info('Language loaded from preferences: $savedLanguage');
      }
    } catch (e, stackTrace) {
      LoggingService.error('Error loading saved language', e, stackTrace);
    }
  }

  Future<void> setLanguage(Locale locale) async {
    if (_currentLocale == locale) return;

    try {
      _currentLocale = locale;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, locale.languageCode);
      notifyListeners();
      LoggingService.logUserAction('Language changed', details: {
        'language': locale.languageCode,
      });
    } catch (e, stackTrace) {
      LoggingService.error('Error saving language preference', e, stackTrace);
    }
  }

  Future<void> toggleLanguage() async {
    final newLocale = _currentLocale.languageCode == 'en'
        ? const Locale('ta')
        : const Locale('en');
    await setLanguage(newLocale);
  }
}
