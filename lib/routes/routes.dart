import 'package:app_dimonis/screens/paypal.dart';
import 'package:app_dimonis/screens/screens.dart';
import 'package:app_dimonis/screens/upgrade_to_premium.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const ComprovacioLogin(),
  '/login': (context) => const AuthScreen(),
  'accountConfirmed': (context) => const AccountCreated(),
  'home_screen': (context) => const HomeScreen(),
  'settings_screen': (context) => const SettingsScreen(),
  'user_screen': (context) => const ProfileScreen(),
  'crear_gimcana': (context) => const CreateGinkana(),
  'mapa_picker_dimoni': (context) => const MapaPickerScreen(),
  'crear_dimoni': (context) => const CrearDimoni(),
  'reset_password_screen': (context) => const ResetPasswordScreen(),
  '/upgrade_to_premium': (context) => const UpgradeToPremium(),
  '/paypal': (context) => const PayPal(),
  'update_user_data_screen': (context) => const UpdateProfileScreen(),
  'guia_inicial': (context) => const GuiaInicial(),
};
