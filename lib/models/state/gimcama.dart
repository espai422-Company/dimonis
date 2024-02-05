import 'package:app_dimonis/models/firebase/dimoni.dart';

class Gimcama {
  String nom;
  DateTime start;
  DateTime end;
  String id;
  List<Ubication> ubications;

  Gimcama({
    required this.nom,
    required this.start,
    required this.end,
    required this.id,
    required this.ubications,
  });
}

class Ubication {
  final Dimoni dimoni;
  final String x;
  final String y;

  Ubication({required this.dimoni, required this.x, required this.y});
}
