import 'package:flutter/material.dart';
import '../verblaze_base.dart';
import '../models/language.dart';
import '../exceptions/verblaze_exception.dart';
import '../cache/translation_cache.dart';

/// Provider class for managing current language and translations
class VerblazeProvider extends ChangeNotifier {
  static final VerblazeProvider _instance = VerblazeProvider._internal();
  factory VerblazeProvider() => _instance;
  VerblazeProvider._internal();

  String _currentLanguage = 'en-US';

  /// Gets current language code
  String get currentLanguage => _currentLanguage;

  /// Gets list of supported languages
  List<Language> get supportedLanguages => Verblaze.supportedLanguages;

  /// Gets current language object
  Language? get currentLanguageObject =>
      supportedLanguages.firstWhere((lang) => lang.code == _currentLanguage);

  /// Sets current language
  void setLanguage(String languageCode) async {
    if (supportedLanguages.any((lang) => lang.code == languageCode)) {
      _currentLanguage = languageCode;
      await TranslationCache.saveCurrentLanguage(languageCode);
      notifyListeners();
    } else {
      throw VerblazeException('Unsupported language code: $languageCode');
    }
  }

  /// Translates a key using current language
  String translate(String key) {
    return Verblaze.translate(key, _currentLanguage);
  }

  /// Sets initial language
  static Future<void> setInitialLanguage(String languageCode) async {
    final provider = VerblazeProvider();
    if (Verblaze.supportedLanguages.any((lang) => lang.code == languageCode)) {
      provider._currentLanguage = languageCode;
    } else {
      throw VerblazeException('Unsupported language code: $languageCode');
    }
  }
}
