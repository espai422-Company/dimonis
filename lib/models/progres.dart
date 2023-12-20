import 'package:app_dimonis/api/db_connection.dart';
import 'package:app_dimonis/models/dimoni.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Progress {
  static final path = '/progress';
  final String gimcanaId;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  Progress({required this.gimcanaId});

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
}
