import 'package:app_dimonis/api/db_connection.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInButton extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleSignInButton({super.key});

  Future<void> _signInWithGoogle() async {
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
        ref.update({user.user!.uid: user.user!.email});
        print(user.user?.displayName);
        print('User signed in with Google');
        // Perform any actions after successful login
      } else {
        print('Google sign in canceled');
        // Handle sign-in cancellation
      }
    } catch (error) {
      print('Error signing in with Google: $error');
      // Handle sign-in error
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _signInWithGoogle,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.red, width: 3),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/google.png',
              width: 40,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Sign in with Google',
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
