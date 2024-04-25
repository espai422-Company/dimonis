import 'package:app_dimonis/api/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

class Auth {
//Creating new instance of firebase auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerWithEmailAndPassword(
      String email, String password, String displayName) async {
    final user = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await user.user?.updateDisplayName(displayName);
    await user.user?.sendEmailVerification();
    // you can also store the user in Database
    await saveUserToRTDB(user.credential?.providerId ?? 'default');
  }

  Future<void> resendEmailVerification() async {
    await FirebaseAuth.instance.currentUser?.sendEmailVerification();
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

  Future<void> saveUserToRTDB(String providerId) async {
    var ref =
        SignleDBConn.getDatabase().ref('/newUsers/${_auth.currentUser!.uid}');

    var snapshot = await ref.get();
    if (!snapshot.exists) {
      // User does not exist, update the data
      ref.set({
        'email': _auth.currentUser!.email,
        'displayName': _auth.currentUser!.displayName,
        'photoURL': _auth.currentUser!.photoURL,
        'providerId': providerId,
        'privileges': 'user',
      });
    }
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
