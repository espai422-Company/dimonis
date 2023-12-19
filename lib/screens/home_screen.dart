import 'package:app_dimonis/api/db_connection.dart';
import 'package:app_dimonis/screens/auth_screen.dart';
import 'package:app_dimonis/screens/verify_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var user = snapshot.data!;
          if (user.emailVerified) {
            return const HomeWidget();
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

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  //Use this to Log Out user
                  FirebaseAuth.instance.signOut();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: const Text('Sign Out'),
              ),
              ElevatedButton(
                onPressed: () {
                  DBConnection().readFromDatabase();
                  // DBConnection().writeToDatabase();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: const Text('Print dimonis'),
              ),
              Text(FirebaseAuth.instance.currentUser!.uid)
            ],
          ),
        ),
      ),
    );
  }
}
