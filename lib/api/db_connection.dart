import 'dart:async';

import 'package:app_dimonis/models/dimoni.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class DBConnection {
// Initialize the Firebase Database reference
  // FirebaseDatabase database = FirebaseDatabase.instance;
  final FirebaseDatabase database = SignleDBConn.getDatabase();

// Example: Writing data to the Firebase Realtime Database
  void writeToDatabase() {
    database
        .ref()
        .child('messages')
        .push()
        .set({'username': 'John Doe', 'message': 'Hello, Firebase!'});
  }

// Example: Reading data from the Firebase Realtime Database
  void readFromDatabase() async {
    final ref = database.ref();
    // ref.child('messages').set()
    // final snapshot = await ref.child('messages').get();
    // if (snapshot.exists) {
    //   print(snapshot.value);
    //   // print(snapshot.value.runtimeType);
    //   var a = snapshot.value as Map;
    //   Map<Object, dynamic> b = a.cast<String, dynamic>();
    //   Dimoni dimoni = Dimoni.fromMap(b);
    // } else {
    //   print('No data available.');
    // }

    var snapshot = await ref.child('updates/id').update({
      'author': 'E2ve',
    });
  }
}

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
