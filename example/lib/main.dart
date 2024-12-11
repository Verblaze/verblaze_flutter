import 'package:example/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:verblaze_flutter/verblaze_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Verblaze.configure("vb-api-366dd1f298448176");
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
      child: const MaterialApp(
        home: HomeView(),
      ),
    );
  }
}
