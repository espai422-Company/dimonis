import 'dart:async';

import 'package:app_dimonis/api/db_connection.dart';
import 'package:app_dimonis/models/firebase/firebase_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsersProvider {
  void Function() notifyListeners;
  List<FirebaseUser> users = [];
  late FirebaseUser _currentUser;

  UsersProvider({required this.users, required this.notifyListeners}) {
    _currentUser = users.firstWhere(
        (user) => user.id == FirebaseAuth.instance.currentUser!.uid);

    // allow app to change bettween users and accounts

    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        users = await getUsers();
        _currentUser =
            users.firstWhere((userFirebase) => userFirebase.id == user.uid);
      }
    });
  }

  // static function to get users from RTDB
  static getUsers() async {
    final ref = SignleDBConn.getDatabase().ref('/newUsers');
    final snapshot = await ref.get();
    if (snapshot.exists) {
      var res = snapshot.value as Map;
      Map<Object, dynamic> json = res.cast<String, dynamic>();
      List<FirebaseUser> users = [];
      json.forEach((key, value) {
        Map<String, dynamic> b = value.cast<String, dynamic>();
        FirebaseUser user = FirebaseUser.fromMap(b, key.toString());
        users.add(user);
      });
      return users;
    } else {
      return [];
    }
  }

  // static setCurrentUser(List<FirebaseUser> users) {
  //   return users.firstWhere(
  //       (user) => user.id == FirebaseAuth.instance.currentUser!.uid);
  // }

  Future<void> reload() async {
    users = await getUsers();
    notifyListeners();
  }

  // get user by id
  FirebaseUser getUserById(String id) {
    return users.firstWhere((user) => user.id == id);
  }

  // get user by email
  FirebaseUser getUserByEmail(String email) {
    return users.firstWhere((user) => user.email == email);
  }

  // make user prime
  void upgradeToPrime() {
    currentUser.privileges = 'prime';
    _updateUser(_currentUser);
  }

  void makeUserAdmin(FirebaseUser user) {
    currentUser.privileges = 'admin';
    _updateUser(user);
  }

  void removeUserAdmin(FirebaseUser user) {
    currentUser.privileges = 'user';
    _updateUser(user);
  }

  void setPhotoURL(String photoURL) {
    _currentUser.photoUrl = photoURL;
    _updateUser(_currentUser);

    // update in firebase auth
    FirebaseAuth.instance.currentUser!.updatePhotoURL(photoURL);
  }

  void setDisplayName(String displayName) {
    _currentUser.displayName = displayName;
    _updateUser(_currentUser);

    // update in firebase auth
    FirebaseAuth.instance.currentUser!.updateDisplayName(displayName);
  }

  void _updateUser(FirebaseUser user) {
    var ref = SignleDBConn.getDatabase().ref('/newUsers/${user.id}');
    ref.update(user.toMap());

    notifyListeners();
  }

  // get current user
  get currentUser => _currentUser;
}
