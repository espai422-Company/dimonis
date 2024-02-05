import 'package:app_dimonis/api/db_connection.dart';
import 'package:app_dimonis/models/firebase/firebase_gimcama.dart';
import 'package:app_dimonis/models/firebase/firebase_gimcama.dart';
import 'package:app_dimonis/models/state/gimcama.dart';
import 'package:app_dimonis/providers/dimoni_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';

class GimcanaProvider {
  List<Gimcama> _gimcanes = [];

  final DimoniProvider dimoniProvider;

  void Function() notifyListeners;

  GimcanaProvider(this._gimcanes, this.dimoniProvider, this.notifyListeners);

  static Future<List<FirebaseGimana>> getGimcames() async {
    final ref = SignleDBConn.getDatabase().ref('/gimcames');
    final snapshot = await ref.get();
    if (snapshot.exists) {
      var res = snapshot.value as Map;
      Map<Object, dynamic> json = res.cast<String, dynamic>();
      List<FirebaseGimana> gimcames = [];
      json.forEach((key, value) {
        Map<String, dynamic> b = value.cast<String, dynamic>();
        FirebaseGimana gimcama = FirebaseGimana.fromMap(b, id: key.toString());
        gimcames.add(gimcama);
      });
      return gimcames;
    } else {
      return [];
    }
  }

  static List<Gimcama> mapFirebaseGimcanaToGimcana(
      List<FirebaseGimana> gimcames, DimoniProvider dimoniProvider) {
    List<Gimcama> gimcanes = [];
    for (var gimcama in gimcames) {
      List<Ubication> ubications = [];
      for (var dimoniz in gimcama.dimonis.entries) {
        var dimoniId = dimoniz.key;
        var dimoniData = dimoniz.value;
        var dimoni = dimoniProvider.getDimoniById(dimoniId);
        var ubication = Ubication(
          dimoni: dimoni,
          x: dimoniData['x'],
          y: dimoniData['y'],
        );
        ubications.add(ubication);
      }
      var gimcana = Gimcama(
        nom: gimcama.nom,
        start: gimcama.start,
        end: gimcama.end,
        id: gimcama.id,
        ubications: ubications,
      );
      gimcanes.add(gimcana);
    }
    return gimcanes;
  }

  // use Firebase model for CRUD operations
  void saveGimcama(FirebaseGimana gimcama) {
    var ref = getRef();
    final newGimcamaRef = ref.push();
    newGimcamaRef.set(gimcama.toMap());
    gimcanes.add(Gimcama(
      nom: gimcama.nom,
      start: gimcama.start,
      end: gimcama.end,
      id: newGimcamaRef.key!,
      ubications: [],
    ));
    notifyListeners();
  }

  void removeGimcama(FirebaseGimana gimcama) {
    var ref = getRef();
    ref.child(gimcama.id).remove();
    gimcanes.removeWhere((element) => element.id == gimcama.id);
    notifyListeners();
  }

  void updateGimcama(FirebaseGimana gimcama) {
    var ref = getRef();
    ref.child(gimcama.id).set(gimcama.toMap());
    gimcanes.removeWhere((element) => element.id == gimcama.id);
    gimcanes.add(Gimcama(
      nom: gimcama.nom,
      start: gimcama.start,
      end: gimcama.end,
      id: gimcama.id,
      ubications: [],
    ));
    notifyListeners();
  }

  void update() async {
    final firebaseGimames = await GimcanaProvider.getGimcames();
    _gimcanes = mapFirebaseGimcanaToGimcana(firebaseGimames, dimoniProvider);

    notifyListeners();
  }

  Gimcama getGimcanaById(String id) =>
      _gimcanes.firstWhere((element) => element.id == id);

  DatabaseReference getRef() => SignleDBConn.getDatabase().ref('/gimcames');

  List<Gimcama> get gimcanes => _gimcanes;
}
