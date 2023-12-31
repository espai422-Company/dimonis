import 'package:app_dimonis/api/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

class Auth {
//Creating new instance of firebase auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerWithEmailAndPassword(
      String email, String password) async {
    final user = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await user.user?.sendEmailVerification();
    // you can also store the user in Database
    var ref = SignleDBConn.getDatabase().ref('/users');
    ref.update({user.user!.uid: user.user!.email});
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    final user = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // you can also store the user in Database
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // return if current user is an admin or not
  Future<bool> isAdmin() async {
    var ref = SignleDBConn.getDatabase().ref('/admins');
    var snapshot = await ref.get();
    if (snapshot.value != null) {
      var a = snapshot.value as Map;
      Map<Object, dynamic> b = a.cast<String, String>();
      return b.containsValue(_auth.currentUser!.email);
    } else {
      return false;
    }
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}

var auth = Auth();
