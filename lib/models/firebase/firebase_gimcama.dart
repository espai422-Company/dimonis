import 'package:app_dimonis/api/db_connection.dart';
import 'package:app_dimonis/models/firebase/dimoni.dart';
import 'package:app_dimonis/models/state/gimcama.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseGimana {
  String nom;
  DateTime start;
  DateTime end;
  String id;
  Map<dynamic, dynamic> dimonis;

  FirebaseGimana({
    required this.nom,
    required this.start,
    required this.end,
    required this.dimonis,
    required this.id,
  });

  factory FirebaseGimana.fromMap(Map<String, dynamic> json,
      {required String id}) {
    var gimcama = FirebaseGimana(
      nom: json["nom"],
      start: DateTime.parse(json["start"]),
      end: DateTime.parse(json["end"]),
      id: id,
      dimonis: json["dimonis"],
    );

    return gimcama;
  }

  Map<String, dynamic> toMap() => {
        "nom": nom,
        "start": start.toString(),
        "end": end.toString(),
        "dimonis": dimonis,
      };
}
