import '../models/translation.dart';

/// Manages translations for different languages and files
class TranslationManager {
  static final TranslationManager _instance = TranslationManager._internal();
  factory TranslationManager() => _instance;
  TranslationManager._internal();

  /// Stores translations in format: {language: {fileKey: TranslationFile}}
  final Map<String, Map<String, TranslationFile>> _translations = {};

  /// Sets translations for a specific language
  void setTranslations(String language, List<dynamic> translations) {
    _translations[language] = {};
    for (var file in translations) {
      final translationFile = TranslationFile.fromJson(file);
      _translations[language]![file['file_key']] = translationFile;
    }
  }

  /// Gets a specific translation value
  /// Returns the translation if found, otherwise returns the translationKey as fallback
  String getTranslation(
      String language, String fileKey, String translationKey) {
    final languageTranslations = _translations[language];
    if (languageTranslations == null) {
      // Return the translation key as fallback when language not found
      return translationKey;
    }

    final file = languageTranslations[fileKey];
    if (file == null) {
      // Return the translation key as fallback when file not found
      return translationKey;
    }

    final translation = file.values[translationKey];
    if (translation == null) {
      // Return the translation key as fallback when translation not found
      return translationKey;
    }

    return translation;
  }

  /// Checks if translations exist for a language
  bool hasTranslations(String language) => _translations.containsKey(language);

  /// Clears all translations
  void clearTranslations() => _translations.clear();

  /// Gets list of languages that have translations
  Set<String> get supportedLanguages => _translations.keys.toSet();
}
