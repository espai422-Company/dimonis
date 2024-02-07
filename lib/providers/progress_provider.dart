import 'dart:async';

import 'package:app_dimonis/api/db_connection.dart';
import 'package:app_dimonis/models/firebase/firebase_user.dart';
import 'package:app_dimonis/models/models.dart';
import 'package:app_dimonis/models/state/gimcama.dart';
import 'package:app_dimonis/models/state/progress.dart';
import 'package:app_dimonis/providers/dimoni_provider.dart';
import 'package:app_dimonis/providers/gimcana_provider.dart';
import 'package:app_dimonis/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProgressProvider extends ChangeNotifier {
  static const _path = '/progress';

  DimoniProvider dimoniProvider;
  GimcanaProvider gimcanaProvider;
  UsersProvider usersProvider;

  StreamSubscription<DatabaseEvent>? progressListener;
  Map<FirebaseUser, Progress> _progressMap = {};
  String? uid;
  String? gimcanaId;

  ProgressProvider(
      {required this.dimoniProvider,
      required this.gimcanaProvider,
      required this.usersProvider}) {
    // allow app to change bettween users and accounts
    FirebaseAuth.instance.authStateChanges().listen((user) => uid = user?.uid);
  }

  void setCurrentProgress(String gimcanaId) {
    this.gimcanaId = gimcanaId;
    if (progressListener != null) {
      progressListener!.cancel();
    }

    var ref = SignleDBConn.getDatabase().ref('$_path/$gimcanaId/');

    progressListener = ref.onValue.listen((event) {
      var snapshot = event.snapshot;
      if (snapshot.exists) {
        final progressMap = snapshot.value as Map;
        progressMap.forEach((key, value) {
          try {
            // test if user exists
            final user = usersProvider.getUserById(key);
          } catch (e) {
            // reload user provider
            usersProvider.reload();
          }

          _progressMap[usersProvider.getUserById(key)] =
              parseProgress(value, gimcanaId);
        });
        notifyListeners();
      }
    });
  }

  // use this parse to create the leaderboard
  Progress parseProgress(Map<dynamic, dynamic> progressMap, String gimcanaId) {
    List<Discover> discovers = [];
    progressMap.forEach((key, value) {
      discovers.add(Discover(
          dimoniProvider.getDimoniById(key.toString()), DateTime.parse(value)));
    });

    return Progress(gimcanaProvider.getGimcanaById(gimcanaId), discovers);
  }

  Progress getProgressOfCurrentUser() {
    if (uid == null) {
      throw Exception('User not logged in');
    }
    
    return _progressMap[uid]!;
  }

  void addDiscover(Dimoni dimoni) {
    if (uid == null) {
      throw Exception('User not logged in');
    }

    var ref = SignleDBConn.getDatabase().ref('$_path/$gimcanaId/$uid');
    ref.set({dimoni.id: DateTime.now().toString()});
  }

  get progressMap => _progressMap;
}
