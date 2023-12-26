import 'package:app_dimonis/screens/screens.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const AuthScreen(),
  '/createGinkana': (context) => const CreateGinkana()
};
