import 'package:app_dimonis/api/db_connection.dart';
import 'package:app_dimonis/models/dimoni.dart';
import 'package:firebase_database/firebase_database.dart';

class Gimcama {
  String nom;
  DateTime start;
  DateTime end;
  String? id;
  late Map<Object, Object> dimonis;

  late DatabaseReference _ref;

  Gimcama({
    required this.nom,
    required this.start,
    required this.end,
    this.id,
  }) {
    id ??= SignleDBConn.getDatabase().ref('/gimcames').push().key;
    _ref = SignleDBConn.getDatabase().ref('/gimcames/$id');
    dimonis = {};
  }

  factory Gimcama.fromMap(Map<Object, dynamic> json) {
    var gimcama = Gimcama(
      nom: json["nom"],
      start: DateTime.parse(json["start"]),
      end: DateTime.parse(json["end"]),
    );

    gimcama.dimonis = json["dimonis"];
    return gimcama;
  }

  Map<String, dynamic> toMap() => {
        "nom": nom,
        "start": start.toString(),
        "end": end.toString(),
        "dimonis": dimonis,
      };

  void save() {
    if (id == null) {
      throw Exception('Can not save a Gimcama without an id');
    }
    _ref.set(toMap());
  }

  void delete() {
    if (id == null) {
      throw Exception('Can not delete a Gimcama without an id');
    }
    _ref.remove();
  }

  // Metodes per afegir un dimoni a la gimcama
  void addDimoniById(String dimoniId, String x, String y) {
    dimonis[dimoniId] = {'x': x, 'y': y};
    _ref.child('dimonis').update(dimonis.cast());
  }

  void addDimoni(Dimoni dimoni, String x, String y) {
    if (dimoni.id != null) {
      dimonis[dimoni.id!] = {'x': x, 'y': y};
      _ref.child('dimonis').update(dimonis.cast());
    } else {
      throw Exception('Dimoni has no id so it can not be added to gimcama');
    }
  }

  // Cridar sempre aquest metode per obtenir els dimonis de la gimcama
  Future<List<Dimoni>> getDimonis() async {
    var response = await _ref.child('dimonis').get();

    // map response to a Dimonis list
    var dimonis = response.value as Map;
    Map<Object, dynamic> castedResponse = dimonis.cast<String, dynamic>();
    List<Dimoni> dimonisList = [];
    for (var id in castedResponse.keys) {
      Dimoni dimoni = await Dimoni.getDimoni(id.toString());
      dimoni.id = id.toString();
      dimonisList.add(dimoni);
    }
    return dimonisList;
  }

  // Metodes per treure un dimoni de la gimcama
  void removeDimoniById(String dimoniId) async {
    var res = await _ref.child('/dimonis').get();

    if (res.exists) {
      var dimonis = res.value! as Map;
      dimonis.remove(dimoniId);
      _ref.child('dimonis').set(dimonis);
    }
  }

  void removeDimoni(Dimoni dimoni) async {
    if (dimoni.id != null) {
      var res = await _ref.child('dimonis').get();
      if (res.exists) {
        var dimonis = res.value! as Map;
        dimonis.remove(dimoni.id);
        _ref.child('dimonis').set(dimonis);
      }
    } else {
      throw Exception('Dimoni has no id');
    }
  }

  // Retorna una llista de gimcames
  static Future<List<Gimcama>> getGimcames() async {
    final ref = SignleDBConn.getDatabase().ref('/gimcames');
    final snapshot = await ref.get();
    if (snapshot.exists) {
      var res = snapshot.value as Map;
      Map<Object, dynamic> json = res.cast<String, dynamic>();
      List<Gimcama> gimcames = [];
      json.forEach((key, value) {
        Map<Object, dynamic> b = value.cast<String, dynamic>();
        Gimcama gimcama = Gimcama.fromMap(b);
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
