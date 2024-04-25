class FirebaseGimana {
  String nom;
  DateTime start;
  DateTime end;
  String id;
  String propietari;
  Map<dynamic, dynamic> dimonis;

  FirebaseGimana({
    required this.nom,
    required this.start,
    required this.end,
    required this.dimonis,
    required this.propietari,
    required this.id,
  });

  factory FirebaseGimana.fromMap(Map<String, dynamic> json,
      {required String id}) {
    var gimcama = FirebaseGimana(
      nom: json["nom"],
      start: DateTime.parse(json["start"]),
      end: DateTime.parse(json["end"]),
      propietari: json["propietari"],
      id: id,
      dimonis: json["dimonis"],
    );

    return gimcama;
  }

  Map<String, dynamic> toMap() => {
        "nom": nom,
        "start": start.toString(),
        "end": end.toString(),
        "propietari": propietari,
        "dimonis": dimonis,
      };
}
