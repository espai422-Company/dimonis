import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class SignleDBConn {
  static FirebaseDatabase? _database;

  static FirebaseDatabase getDatabase() {
    _database ??= FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL:
            ' https://appdimonis-default-rtdb.europe-west1.firebasedatabase.app/');
    return _database!;
  }
}
