import 'package:app_dimonis/api/db_connection.dart';
import 'package:app_dimonis/models/dimoni.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Progress {
  static final path = '/progress';
  late String gimcana_id;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  void findDimoni(Dimoni dimoni) {
    if (dimoni.id == null) {
      throw Exception('Can not set as found a Dimoni that has no id');
    }

    var ref = SignleDBConn.getDatabase().ref('$path/$gimcana_id/$uid');
    ref.update({
      dimoni.id!: DateTime.now().toString(),
    });
  }

  Future<Map<String, DateTime>> getProgress() async {
    var ref = SignleDBConn.getDatabase().ref('$path/$gimcana_id/$uid');
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
}
