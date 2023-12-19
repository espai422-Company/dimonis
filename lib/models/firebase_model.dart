import 'package:firebase_database/firebase_database.dart';

import '../api/api.dart';

abstract class FirebaseModel {
  String path;
  late DatabaseReference ref;

  FirebaseModel({required this.path}) {
    ref = SignleDBConn.getDatabase().ref().child('$path/{$getId()}');
  }

  // used to get the id of the object to be used in the path
  String getId();
}
