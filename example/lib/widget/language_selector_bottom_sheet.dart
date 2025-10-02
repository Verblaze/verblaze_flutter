import 'package:flutter/material.dart';
import 'package:verblaze_flutter/verblaze_flutter.dart';
import 'package:country_flags/country_flags.dart';

class LanguageSelectorBottomSheet extends AutoTranslatedWidget {
  const LanguageSelectorBottomSheet({super.key});

  @override
  Widget buildView(BuildContext context, VerblazeProvider provider) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "language_selector_bottom_sheet.languages".vbt,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text("language_selector_bottom_sheet.test".vbt),
          const SizedBox(height: 10),
          ...Verblaze.supportedLanguages.map((language) => ListTile(
                leading:
                    CountryFlag.fromCountryCode(language.code.split("-")[1]),
                title: Text(language.generalName),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  // Show loading indicator while changing language
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                  try {
                    await VerblazeProvider().setLanguage(language.code);
                    if (context.mounted) {
                      Navigator.pop(context); // Close loading dialog
                      Navigator.pop(context); // Close bottom sheet
                    }
                  } catch (e) {
                    if (context.mounted) {
                      Navigator.pop(context); // Close loading dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error changing language: $e')),
                      );
                    }
                  }
                },
              )),
        ],
      ),
    );
  }
}
