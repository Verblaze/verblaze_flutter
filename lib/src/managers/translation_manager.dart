import '../models/translation.dart';
import '../exceptions/verblaze_exception.dart';

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
  String getTranslation(
      String language, String fileKey, String translationKey) {
    final languageTranslations = _translations[language];
    if (languageTranslations == null) {
      throw VerblazeException('Language not found: $language');
    }

    final file = languageTranslations[fileKey];
    if (file == null) {
      throw VerblazeException('Translation file not found: $fileKey');
    }

    final translation = file.values[translationKey];
    if (translation == null) {
      throw VerblazeException(
          'Translation key not found: $translationKey in file: $fileKey');
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
