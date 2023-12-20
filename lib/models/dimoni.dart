import 'dart:convert';

import 'package:app_dimonis/api/db_connection.dart';
import 'package:firebase_database/firebase_database.dart';

/*
Per utilitzar la classe dimoni, pode crear una classe normal amb el constructor,
aquesta classe generara una id automaticament per si feim un save que es guardi 
a la bdd. També opcionalment li podem passar una id si ja la tenim. per el 
motiu que sigui.

Dimoni dimoni = Dimoni(nom: 'Dimoni', image: 'image', description: 'description');

Per altre banda tenim el metodes static que ens torna un dimoni a partir de una 
id o una llista de dimonis. aquests dimonis ja tenen una id assignada. per tant 
l' unic que hem de fer si modificam un dimoni es fer un save() i si volem que es 
guarde a la bdd

*/
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
    if (id == null) {
      throw Exception('Can not save a Dimoni without an id');
    }
    _ref.set(toMap());
  }

  void delete() {
    if (id == null) {
      throw Exception('Can not delete a Dimoni without an id');
    }
    _ref.remove();
  }

  // Torna una llista de dimonis
  static Future<List<Dimoni>> getDimonis() async {
    final ref = SignleDBConn.getDatabase().ref('/dimonis');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      var response = snapshot.value as Map;
      Map<Object, dynamic> castedResponse = response.cast<String, dynamic>();
      List<Dimoni> dimonis = [];
      castedResponse.forEach((key, value) {
        Map<Object, dynamic> b = value.cast<String, dynamic>();
        Dimoni dimoni = Dimoni.fromMap(b);
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
