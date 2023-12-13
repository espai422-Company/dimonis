import 'package:app_dimonis/main.dart';
import 'package:app_dimonis/screens/auth_screen.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => HomeScreen(),
  '/login': (context) => AuthScreen(),
};
