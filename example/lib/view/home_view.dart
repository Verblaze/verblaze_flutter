import 'package:example/view/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:verblaze_flutter/verblaze_flutter.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    const String screenKey = "home_view";

    return Consumer<VerblazeProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text("$screenKey.home".vbt),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("$screenKey.home".vbt),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsView()));
                },
                child: Text("$screenKey.go_settings".vbt),
              ),
            ],
          ),
        ),
      );
    });
  }
}
