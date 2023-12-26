import 'package:app_dimonis/screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var user = snapshot.data!;
          if (user.emailVerified) {
            return const HomeScreen();
          } else {
            // return HomeScreen();
            return const VerifyEmail();
          }
        } else {
          return const AuthScreen();
        }
      },
    );
  }
}
