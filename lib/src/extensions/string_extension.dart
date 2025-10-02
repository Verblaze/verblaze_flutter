import '../providers/language_provider.dart';
import '../verblaze_base.dart';

/// Extension for easy translation access on String
extension VerblazeTranslation on String {
  /// Gets translation for current language
  /// Example: "home_view.welcome_back".vbt
  /// Returns the original string as fallback if translation not found
  String get vbt {
    return VerblazeProvider().translate(this);
  }

  /// Gets translation for specific language
  /// Example: "home_view.welcome_back".vbtWithLang('en')
  /// Returns the original string as fallback if translation not found
  String vbtWithLang(String languageCode) {
    return Verblaze.translate(this, languageCode);
  }
}
