import 'package:app_dimonis/api/db_connection.dart';
import 'package:app_dimonis/models/firebase/dimoni.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseProgress {
  static const path = '/progress';
  final String gimcanaId;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  FirebaseProgress({required this.gimcanaId});

  findDimoni(Dimoni dimoni) async {
    if (dimoni.id == null) {
      throw Exception('Can not set as found a Dimoni that has no id');
    }

    var ref = SignleDBConn.getDatabase().ref('$path/$gimcanaId/$uid');
    await ref.update({
      dimoni.id!: DateTime.now().toString(),
    });
  }

  // Retorna un Map amb els dimonis trobats i la data en que es van trobar
  // Si no hi ha cap dimoni trobat retorna un Map buit
  // Per convertir la data en DateTime: DateTime.parse(value)
  Future<Map<String, DateTime>> getProgress() async {
    var ref = SignleDBConn.getDatabase().ref('$path/$gimcanaId/$uid');
    var snapshot = await ref.get();
    if (snapshot.exists) {
      var a = snapshot.value as Map;
      Map<Object, dynamic> b = a.cast<String, dynamic>();
      Map<String, DateTime> progress = {};
      b.forEach((key, value) {
        progress[key.toString()] = DateTime.parse(value);
      });
      return progress;
    } else {
      return {};
    }
  }

  // Retorna un Map amb els dimonis trobats i la data en que es van trobar
  Future<Map<Dimoni, DateTime>> getProgressDimonis() async {
    var ref = SignleDBConn.getDatabase().ref('$path/$gimcanaId/$uid');
    var snapshot = await ref.get();
    if (snapshot.exists) {
      var a = snapshot.value as Map;
      Map<Object, dynamic> b = a.cast<String, dynamic>();
      Map<Dimoni, DateTime> progress = {};
      var keys = b.keys.toList();
      for (var i = 0; i < keys.length; i++) {
        var key = keys[i];
        var value = b[key];

        // var dimoniResult = await Dimoni.getDimoni(key.toString());
        // progress[dimoniResult] = DateTime.parse(value);
      }
      return progress;
    } else {
      return {};
    }
  }

  Future<List<String>> getLeaderBoard() async {
    var ref = SignleDBConn.getDatabase().ref('$path/$gimcanaId');
    var snapshot = await ref.get();
    if (snapshot.exists) {
      var a = snapshot.value as Map;
      Map<Object, dynamic> b = a.cast<String, dynamic>();
      return sortedIds(b);
    } else {
      return [];
    }
  }

  Future<int> getMyPosition() async {
    var leaderboard = await getLeaderBoard();
    return leaderboard.indexOf(uid) + 1;
  }
}

List<String> sortedIds(Map<Object, dynamic> inputMap) {
  List<String> ids = inputMap.keys.cast<String>().toList();

  ids.sort((a, b) {
    // Sort by the number of keys in the nested map
    int compare = inputMap[b]!.length.compareTo(inputMap[a]!.length);

    if (compare == 0) {
      // If the number of keys is the same, compare the dates
      DateTime dateA = DateTime.parse(
          inputMap[a]!.values.first.toString()); // Parsing the date string
      DateTime dateB = DateTime.parse(
          inputMap[b]!.values.first.toString()); // Parsing the date string

      return dateA.compareTo(dateB);
    }

    return compare;
  });

  return ids;
}
