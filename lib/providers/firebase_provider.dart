import 'dart:async';

import 'package:app_dimonis/api/db_connection.dart';
import 'package:app_dimonis/models/firebase/firebase_gimcama.dart';
import 'package:app_dimonis/models/state/progress.dart';
import 'package:app_dimonis/providers/dimoni_provider.dart';
import 'package:app_dimonis/providers/gimcana_provider.dart';
import 'package:app_dimonis/providers/progress_provider.dart';
import 'package:app_dimonis/providers/user_provider.dart';
import 'package:app_dimonis/screens/create_ginkana.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

class FireBaseProvider extends ChangeNotifier {
  String? uid;
  bool loaded = false;

  late DimoniProvider dimoniProvider;
  late GimcanaProvider gimcanaProvider;
  late ProgressProvider progressProvider;
  late UsersProvider usersProvider;

  FireBaseProvider(int tsts) {
    print('FireBaseProvider');
    FirebaseAuth.instance.authStateChanges().listen((user) => uid = user?.uid);
    _initialize();
  }

  _initialize() async {
    dimoniProvider =
        DimoniProvider(await DimoniProvider.getDimonis(), notifyListeners);

    usersProvider = UsersProvider(
        users: await UsersProvider.getUsers(),
        notifyListeners: notifyListeners);

    final firebaseGimames = await GimcanaProvider.getGimcames();
    final gimcames = GimcanaProvider.mapFirebaseGimcanaToGimcana(
        firebaseGimames, dimoniProvider);

    gimcanaProvider =
        GimcanaProvider(gimcames, dimoniProvider, notifyListeners);

    progressProvider = ProgressProvider(
        dimoniProvider: dimoniProvider,
        gimcanaProvider: gimcanaProvider,
        usersProvider: usersProvider,
        notifyListeners: notifyListeners);

    loaded = true;
    notifyListeners();
    print('All loaded');
  }
}
