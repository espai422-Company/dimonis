import 'package:app_dimonis/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GithubSignInButton extends StatelessWidget {
  const GithubSignInButton({super.key});

  Future<void> _signInWithGithub(BuildContext context) async {
    try {
      var user = await signInWithGithub();
      auth.saveUserToRTDB(user.credential?.providerId ?? 'Github');
      Navigator.pushNamed(context, '/');
      // Perform any actions after successful login
    } catch (error) {
      print('Error signing in with Github: $error');
    }
  }

  Future<UserCredential> signInWithGithub() async {
    GithubAuthProvider githubProvider = GithubAuthProvider();
    return await FirebaseAuth.instance.signInWithProvider(githubProvider);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 50,
      child: OutlinedButton.icon(
        icon: const Image(
          image: AssetImage("assets/github.png"),
          width: 20.0,
          alignment: Alignment.center,
        ),
        onPressed: () {
          _signInWithGithub(context);
        },
        label: const Text("Github"),
      ),
    );
  }
}
