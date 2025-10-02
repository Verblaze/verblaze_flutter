import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:verblaze_flutter/src/cache/translation_cache.dart';
import 'package:verblaze_flutter/src/loaders/local_translation_loader.dart';
import 'package:verblaze_flutter/verblaze_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

/// Main class for Verblaze SDK
class Verblaze {
  static Verblaze? _instance;
  static String? _apiKey;
  static const String _baseUrl = 'https://api.verblaze.com/v1';
  static final TranslationManager _translationManager = TranslationManager();
  static List<Language>? _supportedLanguages;
  static Language? _baseLanguage;

  Verblaze._();

  /// Gets singleton instance
  static Verblaze get instance {
    _instance ??= Verblaze._();
    return _instance!;
  }

  /// Configures the SDK with optional API key
  /// Only loads the selected language for optimal performance
  /// API key is only required when using remote translations
  static Future<void> configure([String? apiKey]) async {
    // Check if local translations are available first
    final hasLocalTranslations =
        await LocalTranslationLoader.hasLocalTranslations();

    if (hasLocalTranslations) {
      // Use local translations - no API key needed
      if (kDebugMode) {
        debugPrint('Verblaze: Using local translations from locales folder');
      }

      // Get supported languages from local files
      _supportedLanguages =
          await LocalTranslationLoader.getSupportedLanguages();
      _baseLanguage = await LocalTranslationLoader.getBaseLanguage();

      // Determine which language to load
      final selectedLanguage = await _determineLanguageToLoad();

      // Load only the selected language
      await _loadSingleLocalLanguage(selectedLanguage);

      // Set selected language
      await VerblazeProvider.setInitialLanguage(selectedLanguage);
    } else {
      // Use remote translations - API key required
      if (apiKey == null || apiKey.isEmpty) {
        throw VerblazeException(
            'API key is required when no local translations are available. '
            'Either provide an API key or add translation files to the locales folder.');
      }
      _apiKey = apiKey;
      if (kDebugMode) {
        print('Verblaze: Using remote translations from API');
      }

      // Fetch supported languages first
      await _fetchSupportedLanguages();

      // Determine which language to load
      final selectedLanguage = await _determineLanguageToLoad();

      // Load only the selected language
      await _fetchSingleLanguageTranslation(selectedLanguage);

      // Set selected language
      await VerblazeProvider.setInitialLanguage(selectedLanguage);
    }
  }

  /// Determines which language to load based on user preference, device language, or base language
  static Future<String> _determineLanguageToLoad() async {
    // 1. Check saved language
    final savedLanguage = await TranslationCache.getCurrentLanguage();
    if (savedLanguage != null &&
        _supportedLanguages!.any((lang) => lang.code == savedLanguage)) {
      return savedLanguage;
    }

    // 2. Check device language
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    final deviceLanguageCode =
        '${deviceLocale.languageCode}-${deviceLocale.countryCode?.toUpperCase()}';

    if (_supportedLanguages!.any((lang) => lang.code == deviceLanguageCode)) {
      return deviceLanguageCode;
    }

    // 3. Use base language
    if (_baseLanguage != null) {
      return _baseLanguage!.code;
    }

    // 4. Fallback to first supported language
    if (_supportedLanguages!.isNotEmpty) {
      return _supportedLanguages!.first.code;
    }

    throw VerblazeException('No supported languages found');
  }

  /// Loads a single language from local translations
  static Future<void> _loadSingleLocalLanguage(String languageCode) async {
    try {
      final translations =
          await LocalTranslationLoader.loadSingleLanguageTranslation(
              languageCode);
      if (translations != null) {
        _translationManager.setTranslations(languageCode, translations);

        // Cache the translation for consistency
        await TranslationCache.cacheTranslations({languageCode: translations});

        if (kDebugMode) {
          debugPrint('Verblaze: Loaded local translations for $languageCode');
        }
      }
    } catch (e) {
      throw VerblazeException(
          'Failed to load local translations for $languageCode: $e');
    }
  }

  /// Fetches a single language translation from API
  static Future<void> _fetchSingleLanguageTranslation(
      String languageCode) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/translations'),
        headers: {
          'x-api-key': _apiKey!,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'language': languageCode}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final translations = data['data']['translations'] as List<dynamic>;

        _translationManager.setTranslations(languageCode, translations);

        // Cache the translation
        await TranslationCache.cacheTranslations({languageCode: translations});

        if (kDebugMode) {
          debugPrint('Verblaze: Fetched remote translations for $languageCode');
        }
      } else {
        throw VerblazeException(
            'Failed to fetch translations for $languageCode: ${response.statusCode}');
      }
    } catch (e) {
      throw VerblazeException(
          'Failed to fetch translations for $languageCode: $e');
    }
  }

  /// Loads a new language asynchronously (used when user changes language)
  static Future<void> loadLanguage(String languageCode) async {
    if (!_supportedLanguages!.any((lang) => lang.code == languageCode)) {
      throw VerblazeException('Unsupported language code: $languageCode');
    }

    // Check if already loaded
    if (_translationManager.hasTranslations(languageCode)) {
      if (kDebugMode) {
        debugPrint('Verblaze: Language $languageCode already loaded');
      }
      return;
    }

    final hasLocalTranslations =
        await LocalTranslationLoader.hasLocalTranslations();

    if (hasLocalTranslations) {
      await _loadSingleLocalLanguage(languageCode);
    } else {
      await _fetchSingleLanguageTranslation(languageCode);
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

  static String translate(String key, String languageCode) {
    final keyParts = key.split('.');
    if (keyParts.length != 2) {
      // Return the original key as fallback for invalid format
      return key;
    }

    final fileKey = keyParts[0];
    final translationKey = keyParts[1];
    return _translationManager.getTranslation(
        languageCode, fileKey, translationKey);
  }

  static List<Language> get supportedLanguages => _supportedLanguages ?? [];
  static Language? get baseLanguage => _baseLanguage;

  /// Returns true if using local translations, false if using remote API
  static Future<bool> get isUsingLocalTranslations =>
      LocalTranslationLoader.hasLocalTranslations();

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
