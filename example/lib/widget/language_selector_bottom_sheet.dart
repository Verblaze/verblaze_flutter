import 'package:verblaze_flutter/src/widget/auto_translated_widget.dart';
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
          const SizedBox(height: 10),
          ...Verblaze.supportedLanguages.map((language) => ListTile(
                leading:
                    CountryFlag.fromCountryCode(language.code.split("-")[1]),
                title: Text(language.generalName),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  VerblazeProvider().setLanguage(language.code);
                  Navigator.pop(context);
                },
              )),
        ],
      ),
    );
  }
}
