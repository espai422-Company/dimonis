import 'package:app_dimonis/models/models.dart';
import 'package:app_dimonis/models/state/gimcama.dart';
import 'package:flutter/material.dart';

class PlayingGimcanaProvider extends ChangeNotifier {
  Gimcama? _currentGimcana;
  List<Dimoni>? dimonis;
  List<Dimoni>? dimonisTrobats = [];
  FirebaseProgress? progress;
  Dimoni? nextDimoni;
  bool completed = false;

  set currentGimcana(Gimcama? gimcana) {
    _currentGimcana = gimcana;

    if (gimcana != null && gimcana.id != null) {
      nextDimoni = null;
      completed = false;
      progress = FirebaseProgress(gimcanaId: gimcana.id!);
      getDimonis().then((value) => getNextDimoni());
    } else {
      progress = null;
      dimonis = null;
    }

    progress
        ?.getProgressDimonis()
        .then((value) => dimonisTrobats = value.keys.toList());

    notifyListeners();
  }

  Gimcama? get currentGimcana => _currentGimcana;

  getDimonis() async {
    if (_currentGimcana == null) {
      return;
    }

    // dimonis = await _currentGimcana!.getDimonis();
    notifyListeners();
  }

  getNextDimoni() async {
    if (_currentGimcana == null || _currentGimcana!.id == null) {
      return;
    }

    if (dimonis == null || dimonis!.isEmpty) {
      return;
    }

    if (progress == null) {
      return;
    }

    if (nextDimoni != null) {
      await progress!.findDimoni(nextDimoni!);
      var trobats = await progress!.getProgressDimonis();
      dimonisTrobats = trobats.keys.toList();
      nextDimoni = null;
    }

    var dimonisFound = (await progress!.getProgress()).keys.toList();
    var notFound =
        dimonis!.where((dimoni) => !dimonisFound.contains(dimoni.id)).toList();

    if (notFound.isEmpty) {
      completed = true;
      notifyListeners();
      return;
    }

    nextDimoni = notFound.first;

    notifyListeners();
  }

  dimoniTrobat(Dimoni dimoni) {
    dimonisTrobats!.add(dimoni);
    notifyListeners();
  }
}
