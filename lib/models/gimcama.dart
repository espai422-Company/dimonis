import 'package:app_dimonis/api/db_connection.dart';
import 'package:app_dimonis/models/dimoni.dart';
import 'package:firebase_database/firebase_database.dart';

class Gimcama {
  String nom;
  DateTime start;
  DateTime end;
  String? id;
  Map<Object, Object> dimonis;

  late DatabaseReference _ref;

  Gimcama(
      {required this.nom,
      required this.start,
      required this.end,
      this.id,
      required this.dimonis}) {
    id ??= SignleDBConn.getDatabase().ref('/gimcames').push().key;
    _ref = SignleDBConn.getDatabase().ref('/dimonis/$id');
  }

  factory Gimcama.fromMap(Map<Object, dynamic> json) => Gimcama(
        nom: json["nom"],
        start: DateTime.parse(json["start"]),
        end: DateTime.parse(json["end"]),
        dimonis: json["dimonis"],
      );

  Map<String, dynamic> toMap() => {
        "nom": nom,
        "start": start.toString(),
        "end": end.toString(),
        "dimonis": dimonis,
      };

  void save() {
    _ref.set(toMap());
  }

  void delete() {
    _ref.remove();
  }

  // Metodes per afegir un dimoni a la gimcama
  void addDimoniById(String dimoniId, String x, String y) {
    dimonis[dimoniId] = {'x': x, 'y': y};
    _ref.child('dimonis').set(dimonis);
  }

  void addDimoni(Dimoni dimoni, String x, String y) {
    if (dimoni.id != null) {
      dimonis[dimoni.id!] = {'x': x, 'y': y};
      _ref.child('dimonis').set(dimonis);
    }
    throw Exception('Dimoni has no id');
  }

  // Metodes per treure un dimoni de la gimcama
  void removeDimoniById(String dimoniId) {
    dimonis.remove(dimoniId);
    _ref.child('dimonis').set(dimonis);
  }

  void removeDimoni(Dimoni dimoni) {
    if (dimoni.id != null) {
      dimonis.remove(dimoni.id);
      _ref.child('dimonis').set(dimonis);
    }
    throw Exception('Dimoni has no id');
  }

  // Retorna una llista de gimcames
  static Future<List<Gimcama>> getGimcames() async {
    final ref = SignleDBConn.getDatabase().ref('/gimcames');
    final snapshot = await ref.get();
    if (snapshot.exists) {
      var a = snapshot.value as Map;
      Map<Object, dynamic> b = a.cast<String, dynamic>();
      List<Gimcama> gimcames = [];
      b.forEach((key, value) {
        Gimcama gimcama = Gimcama.fromMap(value);
        gimcama.id = key.toString();
        gimcames.add(gimcama);
      });
      return gimcames;
    } else {
      return [];
    }
  }

  // Retorna una gimcama a partir de una id
  static Future<Gimcama> getGimcama(String id) async {
    final ref = SignleDBConn.getDatabase().ref('/gimcames/$id');
    final snapshot = await ref.get();
    if (snapshot.exists) {
      var a = snapshot.value as Map;
      Map<Object, dynamic> b = a.cast<String, dynamic>();
      Gimcama gimcama = Gimcama.fromMap(b);
      gimcama.id = id;
      return gimcama;
    } else {
      throw Exception('Gimcama not found');
    }
  }
}
