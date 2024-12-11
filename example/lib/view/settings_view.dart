import 'package:verblaze_flutter/src/widget/auto_translated_widget.dart';
import 'package:example/widget/language_selector_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:verblaze_flutter/verblaze_flutter.dart';

class SettingsView extends AutoTranslatedWidget {
  const SettingsView({super.key});

  @override
  Widget buildView(BuildContext context, verblaze) {
    const String screenKey = "settings_view";
    return Scaffold(
      appBar: AppBar(
        title: Text("$screenKey.settings".vbt),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: ListTile(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) =>
                          const LanguageSelectorBottomSheet());
                },
                title: Text("settings_view.change_language".vbt),
                subtitle: Text("settings_view.change_of_app".vbt),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
              label: Text("settings_view.go_back".vbt),
            )
          ],
        ),
      ),
    );
  }
}
