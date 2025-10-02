import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/language.dart';

/// Loads translations from local JSON files in the locales folder
class LocalTranslationLoader {
  static const String _localesPath = 'locales';

  /// Checks if local translations are available
  static Future<bool> hasLocalTranslations() async {
    try {
      // Try to list files in the locales directory
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      // Check if there are any files in the locales folder
      final localeFiles = manifestMap.keys
          .where((String key) => key.startsWith('$_localesPath/'))
          .where((String key) => key.endsWith('.json'))
          .toList();

      return localeFiles.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Loads all available local translation files
  static Future<Map<String, List<dynamic>>> loadLocalTranslations() async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      // Get all JSON files in the locales folder
      final localeFiles = manifestMap.keys
          .where((String key) => key.startsWith('$_localesPath/'))
          .where((String key) => key.endsWith('.json'))
          .toList();

      final Map<String, List<dynamic>> translations = {};
      final List<Language> supportedLanguages = [];

      for (final filePath in localeFiles) {
        try {
          final fileContent = await rootBundle.loadString(filePath);
          final Map<String, dynamic> jsonData = json.decode(fileContent);

          final languageCode = jsonData['language'] as String;
          final translationsData =
              jsonData['translations'] as Map<String, dynamic>;

          // Convert to the format expected by TranslationManager
          final List<dynamic> translationFiles = [];

          translationsData.forEach((fileKey, fileData) {
            if (fileData is Map<String, dynamic> &&
                fileData.containsKey('values')) {
              translationFiles.add({
                'file_key': fileKey,
                'file_title': fileKey, // Use file_key as title for local files
                'values': fileData['values'],
              });
            }
          });

          translations[languageCode] = translationFiles;

          // Create Language object for this translation
          supportedLanguages.add(Language(
            code: languageCode,
            generalName: _getLanguageName(languageCode),
            localName: _getLocalLanguageName(languageCode),
          ));
        } catch (e) {
          // Skip invalid files
          continue;
        }
      }

      return translations;
    } catch (e) {
      throw Exception('Failed to load local translations: $e');
    }
  }

  /// Gets supported languages from local translation files
  static Future<List<Language>> getSupportedLanguages() async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      final localeFiles = manifestMap.keys
          .where((String key) => key.startsWith('$_localesPath/'))
          .where((String key) => key.endsWith('.json'))
          .toList();

      final List<Language> supportedLanguages = [];

      for (final filePath in localeFiles) {
        try {
          final fileContent = await rootBundle.loadString(filePath);
          final Map<String, dynamic> jsonData = json.decode(fileContent);

          final languageCode = jsonData['language'] as String;

          supportedLanguages.add(Language(
            code: languageCode,
            generalName: _getLanguageName(languageCode),
            localName: _getLocalLanguageName(languageCode),
          ));
        } catch (e) {
          // Skip invalid files
          continue;
        }
      }

      return supportedLanguages;
    } catch (e) {
      return [];
    }
  }

  /// Gets the base language from local translations (first available language)
  static Future<Language?> getBaseLanguage() async {
    final languages = await getSupportedLanguages();
    return languages.isNotEmpty ? languages.first : null;
  }

  /// Helper method to get language name from code
  static String _getLanguageName(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'en-us':
        return 'English';
      case 'tr-tr':
        return 'Turkish';
      default:
        return languageCode.split('-').first.toUpperCase();
    }
  }

  /// Loads translation for a single language from local files
  static Future<List<dynamic>?> loadSingleLanguageTranslation(
      String languageCode) async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      // Get all JSON files in the locales folder
      final localeFiles = manifestMap.keys
          .where((String key) => key.startsWith('$_localesPath/'))
          .where((String key) => key.endsWith('.json'))
          .toList();

      for (final filePath in localeFiles) {
        try {
          final fileContent = await rootBundle.loadString(filePath);
          final Map<String, dynamic> jsonData = json.decode(fileContent);

          final fileLanguageCode = jsonData['language'] as String;

          // Check if this is the language we're looking for
          if (fileLanguageCode == languageCode) {
            final translationsData =
                jsonData['translations'] as Map<String, dynamic>;

            // Convert to the format expected by TranslationManager
            final List<dynamic> translationFiles = [];

            translationsData.forEach((fileKey, fileData) {
              if (fileData is Map<String, dynamic> &&
                  fileData.containsKey('values')) {
                translationFiles.add({
                  'file_key': fileKey,
                  'file_title':
                      fileKey, // Use file_key as title for local files
                  'values': fileData['values'],
                });
              }
            });

            return translationFiles;
          }
        } catch (e) {
          // Skip invalid files
          continue;
        }
      }

      return null; // Language not found
    } catch (e) {
      throw Exception('Failed to load local translation for $languageCode: $e');
    }
  }

  /// Helper method to get local language name from code
  static String _getLocalLanguageName(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'en-us':
        return 'English';
      case 'tr-tr':
        return 'Türkçe';
      default:
        return languageCode;
    }
  }
}
