import 'package:app_dimonis/api/db_connection.dart';
import 'package:app_dimonis/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookSignInButton extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FacebookSignInButton({super.key});

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      var user = await signInWithFacebook();
      var ref = SignleDBConn.getDatabase().ref('/users');
      auth.saveUserToRTDB(user.credential?.providerId ?? 'Facebook');
      print(user.user?.displayName);
      Navigator.pushNamed(context, '/');
      print('User signed in with Facebook');
      // Perform any actions after successful login
    } catch (error) {
      print('Error signing in with Facebook: $error');
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    if (LoginStatus.success != loginResult.status) {
      throw Exception('Facebook login failed');
    }
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
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
          _signInWithFacebook(context);
        },
        label: const Text("Sign-In With Facebook"),
      ),
    );
  }
}
