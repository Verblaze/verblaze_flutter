import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verblaze_flutter/src/cache/translation_cache.dart';
import 'package:verblaze_flutter/verblaze_flutter.dart';
import 'package:flutter/widgets.dart';

/// Main class for Verblaze SDK
class Verblaze {
  static Verblaze? _instance;
  static String? _apiKey;
  static const String _baseUrl = 'https://api.verblaze.com/v1';
  static const String _versionKey = 'verblaze_translation_version';
  static late final SharedPreferences _prefs;
  static final TranslationManager _translationManager = TranslationManager();
  static List<Language>? _supportedLanguages;
  static Language? _baseLanguage;

  Verblaze._();

  /// Gets singleton instance
  static Verblaze get instance {
    _instance ??= Verblaze._();
    return _instance!;
  }

  /// Configures the SDK with API key
  static Future<void> configure(String apiKey) async {
    _apiKey = apiKey;
    _prefs = await SharedPreferences.getInstance();

    await _checkVersion();
    await _fetchSupportedLanguages();

    // Dil seçim mantığı
    String? selectedLanguage;

    // 1. Kayıtlı dili kontrol et
    final savedLanguage = await TranslationCache.getCurrentLanguage();
    if (savedLanguage != null &&
        _supportedLanguages!.any((lang) => lang.code == savedLanguage)) {
      selectedLanguage = savedLanguage;
    }

    // 2. Cihaz dilini kontrol et
    if (selectedLanguage == null) {
      final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
      final deviceLanguageCode =
          '${deviceLocale.languageCode}-${deviceLocale.countryCode?.toUpperCase()}';

      if (_supportedLanguages!.any((lang) => lang.code == deviceLanguageCode)) {
        selectedLanguage = deviceLanguageCode;
      }
    }

    // 3. Base dili kullan
    if (selectedLanguage == null && _baseLanguage != null) {
      selectedLanguage = _baseLanguage!.code;
    }

    // Seçilen dili ayarla
    if (selectedLanguage != null) {
      await VerblazeProvider.setInitialLanguage(selectedLanguage);
    }

    await _fetchTranslations();
  }

  /// Checks for translation version updates
  static Future<void> _checkVersion() async {
    try {
      final currentVersion = _prefs.getInt(_versionKey) ?? 1;
      final response = await http.post(
        Uri.parse('$_baseUrl/version-check'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey!,
        },
        body: jsonEncode({
          'currentVersion': currentVersion,
          'platform': 'flutter',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data']['needsUpdate']) {
          await _prefs.setInt(_versionKey, data['data']['latestVersion']);
          await _fetchTranslations();

          // Cache'i temizle
          final cache = await SharedPreferences.getInstance();
          await cache.remove(TranslationCache.translationsKey);
        }
      }
    } catch (e) {
      throw VerblazeException('Failed to check version: $e');
    }
  }

  /// Fetches supported languages from API
  static Future<void> _fetchSupportedLanguages() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/supported-languages'),
        headers: {'x-api-key': _apiKey!},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _supportedLanguages = (data['data']['supportedLanguages'] as List)
            .map((lang) => Language.fromJson(lang))
            .toList();
        _baseLanguage = Language.fromJson(data['data']['baseLanguage']);
      }
    } catch (e) {
      throw VerblazeException('Failed to fetch supported languages: $e');
    }
  }

  /// Fetches translations for all supported languages
  static Future<void> _fetchTranslations() async {
    if (_supportedLanguages == null) return;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/translations/multiple'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey!,
        },
        body: jsonEncode({
          'languages': _supportedLanguages!.map((lang) => lang.code).toList(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final translations =
            data['data']['translations'] as Map<String, dynamic>;

        translations.forEach((languageCode, languageTranslations) {
          if (languageTranslations is List) {
            _translationManager.setTranslations(
                languageCode, languageTranslations);
          }
        });
      }
    } catch (e) {
      throw VerblazeException('Failed to fetch translations: $e');
    }
  }

  static String translate(String key, String languageCode) {
    final keyParts = key.split('.');
    if (keyParts.length != 2) {
      throw VerblazeException(
          'Invalid translation key format. Use: file_key.translation_key');
    }

    final fileKey = keyParts[0];
    final translationKey = keyParts[1];
    return _translationManager.getTranslation(
        languageCode, fileKey, translationKey);
  }

  static List<Language> get supportedLanguages => _supportedLanguages ?? [];
  static Language? get baseLanguage => _baseLanguage;

  /// Gets list of supported locales
  static List<Locale> get supportedLocales => supportedLanguages
      .map((lang) => Locale(lang.code.split('-')[0], lang.code.split('-')[1]))
      .toList();

  /// Gets current locale
  static Locale get currentLocale {
    final provider = VerblazeProvider();
    return provider.currentLocale;
  }
}
