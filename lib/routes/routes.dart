import 'package:app_dimonis/screens/screens.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const LoginScreen(),
  '/login': (context) => const AuthScreen(),
  'home_screen': (context) => const HomeScreen(),
  'settings_screen': (context) => const SettingsScreen(),
  'user_screen': (context) => const UserScreen(),
  '/createGinkana': (context) => const CreateGinkana(),
  'mapa_picker_dimoni': (context) => const MapaPickerScreen(),
  'crear_dimoni': (context) => const CrearDimoni(),
  'reset_password_screen': (context) => const ResetPasswordScreen(),
};
