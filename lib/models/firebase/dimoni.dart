import 'package:app_dimonis/api/db_connection.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:quiver/core.dart';

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

  late DatabaseReference ref;

  Dimoni(
      {required this.nom,
      required this.image,
      required this.description,
      this.id}) {
    id ??= SignleDBConn.getDatabase().ref('/dimonis').push().key;
    ref = SignleDBConn.getDatabase().ref('/dimonis/$id');
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Dimoni &&
        nom == other.nom &&
        image == other.image &&
        description == other.description &&
        id == other.id;
  }

  @override
  int get hashCode {
    return hashObjects([nom, image, description, id]);
  }
}
