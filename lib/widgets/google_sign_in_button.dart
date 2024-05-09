import 'package:app_dimonis/api/db_connection.dart';
import 'package:app_dimonis/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInButton extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleSignInButton({super.key});

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        var user = await _auth.signInWithCredential(credential);
        var ref = SignleDBConn.getDatabase().ref('/users');
        auth.saveUserToRTDB(user.credential?.providerId ?? 'Google');
        Navigator.pushNamed(context, '/');
        // Perform any actions after successful login
      }
    } catch (error) {
      print('Error signing in with Google: $error');
      // Handle sign-in error
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 130),
      child: SizedBox(
        height: 50,
        child: OutlinedButton.icon(
          icon:
              const Image(image: AssetImage("assets/google.png"), width: 20.0),
          onPressed: () {
            _signInWithGoogle(context);
          },
          label: const Text("Google"),
        ),
      ),
    );
  }
}
