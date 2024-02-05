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
  }

  // static function to get users from RTDB

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
    // ugpradde current user to prime
    currentUser.privileges = 'prime';
    // update user in RTDB
    var ref = SignleDBConn.getDatabase().ref('/users/${currentUser.id}');
    ref.update(currentUser.toMap());

    notifyListeners();
  }

  void makeUserAdmin(FirebaseUser user) {
    // make user admin
    throw UnimplementedError();
  }

  // get current user
  get currentUser => _currentUser;
}
