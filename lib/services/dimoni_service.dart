import 'package:app_dimonis/api/api.dart';
import 'package:app_dimonis/models/dimoni.dart';
import 'package:firebase_database/firebase_database.dart';

void safe_dimoni(Dimoni dimoni) async {
  dimoni.id ??= SignleDBConn.getDatabase().ref('/dimonis').push().key;
  DatabaseReference ref = SignleDBConn.getDatabase().ref('/dimonis');
}
