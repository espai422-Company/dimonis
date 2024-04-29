import 'package:app_dimonis/api/db_connection.dart';
import 'package:app_dimonis/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MicrosoftSignInButton extends StatelessWidget {
  MicrosoftSignInButton({super.key});

  Future<void> _signInWithMicrosoft(BuildContext context) async {
    try {
      final provider = OAuthProvider('microsoft.com');
      provider.setCustomParameters(
          {"tenant": "f01b81d2-b33f-4273-b17c-53cfd09f2561"});
      var user = await FirebaseAuth.instance.signInWithProvider(provider);
      auth.saveUserToRTDB(user.credential?.providerId ?? 'Google');
      print(user.user?.displayName);
      Navigator.pushNamed(context, '/');
      print('User signed in with Microsoft');
    } catch (error) {
      print('Error signing in with Microsoft: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        icon:
            const Image(image: AssetImage("assets/Facebook.jpg"), width: 20.0),
        onPressed: () {
          _signInWithMicrosoft(context);
        },
        label: const Text("Sign-In With Microsoft"),
      ),
    );
  }
}
