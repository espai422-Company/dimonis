import 'package:app_dimonis/api/db_connection.dart';
import 'package:app_dimonis/models/firebase/dimoni.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';

class DimoniProvider {
  late List<Dimoni> _dimonis;

  void Function() notifyListeners;
  List<Dimoni> get dimonis => _dimonis;

  DimoniProvider(this._dimonis, this.notifyListeners);

  Dimoni getDimoniById(String id) =>
      _dimonis.firstWhere((element) => element.id == id);

  void saveDimoni(Dimoni dimoni) {
    final ref = getRef(dimoni);
    ref.set(dimoni.toMap());
    _dimonis.add(dimoni);
    notifyListeners();
  }

  void removeDimoni(Dimoni dimoni) {
    final ref = getRef(dimoni);
    ref.remove();
    _dimonis.removeWhere((element) => element.id == dimoni.id);
    notifyListeners();
  }

  void updateDimoni(Dimoni dimoni) {
    final ref = getRef(dimoni);
    ref.update(dimoni.toMap());
    _dimonis.removeWhere((element) => element.id == dimoni.id);
    _dimonis.add(dimoni);
    notifyListeners();
  }

  DatabaseReference getRef(Dimoni dimoni) =>
      SignleDBConn.getDatabase().ref('/dimonis/${dimoni.id}');

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
}
