import 'package:app_dimonis/firebase_options.dart';
import 'package:app_dimonis/preferences/preferences.dart';
import 'package:app_dimonis/providers/dimonis_ginkana.dart';
import 'package:app_dimonis/providers/playing_gimcama.dart';
import 'package:app_dimonis/providers/theme_provider.dart';
import 'package:app_dimonis/providers/ui_provider.dart';
import 'package:app_dimonis/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Preferences.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TotalDimonisProvider()),
        ChangeNotifierProvider(
            create: (_) => ThemeProvider(isDarkMode: Preferences.isDarkMode)),
        ChangeNotifierProvider(create: (_) => UIProvider()),
        ChangeNotifierProvider(create: (_) => PlayingGimcanaProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DimonisGo',
      theme: Provider.of<ThemeProvider>(context).currentTheme,
      // initialRoute: '/login',
      routes: routes,
    );
  }
}
