import '../providers/language_provider.dart';
import '../exceptions/verblaze_exception.dart';
import '../verblaze_base.dart';

/// Extension for easy translation access on String
extension VerblazeTranslation on String {
  /// Gets translation for current language
  /// Example: "home_view.welcome_back".vbt
  String get vbt {
    if (!contains('.')) {
      throw VerblazeException(
        'Invalid translation key format. Use: file_key.translation_key',
      );
    }
    return VerblazeProvider().translate(this);
  }

  /// Gets translation for specific language
  /// Example: "home_view.welcome_back".vbtWithLang('en')
  String vbtWithLang(String languageCode) {
    if (!contains('.')) {
      throw VerblazeException(
        'Invalid translation key format. Use: file_key.translation_key',
      );
    }
    return Verblaze.translate(this, languageCode);
  }
}
