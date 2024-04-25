import 'package:app_dimonis/firebase_options.dart';
import 'package:app_dimonis/preferences/preferences.dart';
import 'package:app_dimonis/providers/dimonis_ginkana.dart';
import 'package:app_dimonis/providers/firebase_provider.dart';
import 'package:app_dimonis/providers/global_classification_provider.dart';
import 'package:app_dimonis/providers/playing_gimcama.dart';
import 'package:app_dimonis/providers/theme_provider.dart';
import 'package:app_dimonis/providers/ui_provider.dart';
import 'package:app_dimonis/routes/routes.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  await Preferences.init();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FireBaseProvider(1)),
        ChangeNotifierProvider(create: (_) => TotalDimonisProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider(isDarkMode: Preferences.isDarkMode)),
        ChangeNotifierProvider(create: (_) => UIProvider()),
        ChangeNotifierProvider(create: (_) => PlayingGimcanaProvider()),
        ChangeNotifierProvider(create: (_) => GlobalClassificationProvider()),
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
