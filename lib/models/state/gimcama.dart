import 'package:app_dimonis/models/firebase/dimoni.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Gimcama {
  String nom;
  DateTime start;
  DateTime end;
  String id;
  String propietari;
  List<Ubication> ubications;

  Gimcama({
    required this.nom,
    required this.start,
    required this.end,
    required this.id,
    required this.propietari,
    required this.ubications,
  });

  bool isTimeToPlay() {
    return start.isBefore(DateTime.now()) && end.isAfter(DateTime.now());
  }
}

class Ubication {
  final Dimoni dimoni;
  final String x;
  final String y;

  Ubication({required this.dimoni, required this.x, required this.y});

  LatLng getLatLng() {
    return LatLng(double.parse(x), double.parse(y));
  }
}
