import 'package:app_dimonis/models/firebase/dimoni.dart';
import 'package:app_dimonis/models/state/gimcama.dart';

class Progress {
  final Gimcama gimcamana;
  final List<Discover> discovers;

  Progress(this.gimcamana, this.discovers);
}

class Discover {
  final Dimoni dimoni;
  final String time;

  Discover(this.dimoni, this.time);
}
