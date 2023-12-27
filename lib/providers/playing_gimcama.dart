import 'package:app_dimonis/models/models.dart';
import 'package:flutter/material.dart';

class PlayingGimcanaProvider extends ChangeNotifier {
  Gimcama? _currentGimcana;
  List<Dimoni>? dimonis;
  Progress? progress;


  set currentGimcana(Gimcama? gimcana) {
    _currentGimcana = gimcana;
    notifyListeners();

    if (gimcana != null && gimcana.id != null) {
      progress = Progress(gimcanaId: gimcana.id!);
      getDimonis();
    }
  }

  Gimcama? get currentGimcana => _currentGimcana;

  Future<void> getDimonis() async {
    if (_currentGimcana == null) {
      return;
    }
    dimonis = await _currentGimcana!.getDimonis();
    notifyListeners();
  }

  Future<Dimoni?> nextDimoni() async {
    if (_currentGimcana == null) {
      return null;
    }

    if (dimonis == null) {
      return null;
    }

    if (dimonis!.isEmpty) {
      return null;
    }

    if (progress == null) {
      return null;
    }

    var dimonisFound = (await progress!.getProgress()).keys.toList();
    var notFound = dimonis!.where((dimoni) => !dimonisFound.contains(dimoni.id)).toList();

    if (notFound.isEmpty) {
      return null;
    }

    return notFound.first;
  }
}
