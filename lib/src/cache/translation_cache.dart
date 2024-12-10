import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TranslationCache {
  static const String translationsKey = 'verblaze_translations';

  static Future<void> cacheTranslations(
      Map<String, List<dynamic>> translations) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(translationsKey, jsonEncode(translations));
  }

  static Future<Map<String, List<dynamic>>?> getCachedTranslations() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(translationsKey);
    if (cached != null) {
      return Map<String, List<dynamic>>.from(jsonDecode(cached));
    }
    return null;
  }
}
