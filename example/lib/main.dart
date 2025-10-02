import 'package:example/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:verblaze_flutter/verblaze_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // No API key needed when using local translations
  await Verblaze.configure("vb-api-f99b79be9f809691");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => VerblazeProvider()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: Verblaze.supportedLocales,
        home: const HomeView(),
      ),
    );
  }
}
