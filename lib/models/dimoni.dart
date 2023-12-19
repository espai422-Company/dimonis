import 'dart:convert';

import 'package:app_dimonis/api/db_connection.dart';
import 'package:firebase_database/firebase_database.dart';

class Dimoni {
  String nom;
  String image;
  String description;
  String? id;

  late DatabaseReference _ref;

  Dimoni(
      {required this.nom,
      required this.image,
      required this.description,
      this.id}) {
    id ??= SignleDBConn.getDatabase().ref('/dimonis').push().key;
    _ref = SignleDBConn.getDatabase().ref('/dimonis/$id');
  }

  factory Dimoni.fromMap(Map<Object, dynamic> json) => Dimoni(
        nom: json["nom"],
        image: json["image"],
        description: json["description"],
      );

  Map<String, dynamic> toMap() => {
        "nom": nom,
        "image": image,
        "description": description,
      };

  void save() {
    _ref.set(toMap());
  }

  void delete() {
    _ref.remove();
  }

  // Torna una llista de dimonis
  static Future<List<Dimoni>> getDimonis() async {
    final ref = SignleDBConn.getDatabase().ref('/dimonis');
    final snapshot = await ref.get();
    if (snapshot.exists) {
      var a = snapshot.value as Map;
      Map<Object, dynamic> b = a.cast<String, dynamic>();
      List<Dimoni> dimonis = [];
      b.forEach((key, value) {
        Dimoni dimoni = Dimoni.fromMap(value);
        dimoni.id = key.toString();
        dimonis.add(dimoni);
      });
      return dimonis;
    } else {
      return [];
    }
  }

  // Torna un dimoni
  static Future<Dimoni> getDimoni(String id) async {
    final ref = SignleDBConn.getDatabase().ref('/dimonis/$id');
    final snapshot = await ref.get();
    if (snapshot.exists) {
      var a = snapshot.value as Map;
      Map<Object, dynamic> b = a.cast<String, dynamic>();
      Dimoni dimoni = Dimoni.fromMap(b);
      dimoni.id = id;
      return dimoni;
    } else {
      throw Exception('Dimoni not found');
    }
  }
}
