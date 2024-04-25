import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../api/db_connection.dart';
import '../models/firebase/firebase_user.dart';

class Classification {
  FirebaseUser user;
  int points;

  Classification({required this.user, required this.points});
}

class GlobalClassificationProvider extends ChangeNotifier {
  final String _path = '/classification';
  Map<FirebaseUser, int> users = {};
  late FirebaseDatabase database = SignleDBConn.getDatabase();

  void finishGimcana(String gimcanaId, String userId) {
    var ref = database.ref('$_path/$userId/$gimcanaId');
    ref.set(true);
  }

  Future<void> _getFinishedGimcanes(FirebaseUser userId) async {
    var ref = database.ref('$_path/${userId.id}');
    var event = await ref.once();

    if (event.snapshot.value == null) {
      users[userId] = 0;
      return;
    }

    var finishedGimcanes = event.snapshot.value as Map;
    users[userId] = finishedGimcanes.length;
  }

  void loadAllUsers(List<FirebaseUser> users) async {
    for (var user in users) {
      await _getFinishedGimcanes(user);
    }
    notifyListeners();
  }

  List<Classification> getRanking() {
    print(users);

    List<Classification> ranking = [];
    users.forEach((key, value) {
      ranking.add(Classification(user: key, points: value));
    });
    ranking.sort((a, b) => b.points.compareTo(a.points));
    return ranking;
  }
}
