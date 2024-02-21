import 'dart:async';

import 'package:app_dimonis/api/db_connection.dart';
import 'package:app_dimonis/models/firebase/firebase_user.dart';
import 'package:app_dimonis/models/models.dart';
import 'package:app_dimonis/models/state/gimcama.dart';
import 'package:app_dimonis/models/state/progress.dart';
import 'package:app_dimonis/providers/dimoni_provider.dart';
import 'package:app_dimonis/providers/firebase_provider.dart';
import 'package:app_dimonis/providers/gimcana_provider.dart';
import 'package:app_dimonis/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProgressProvider {
  static const _path = '/progress';

  DimoniProvider dimoniProvider;
  GimcanaProvider gimcanaProvider;
  UsersProvider usersProvider;

  StreamSubscription<DatabaseEvent>? progressListener;
  Map<FirebaseUser, Progress> _progressMap = {};
  String? uid;
  String? gimcanaId;
  void Function() notifyListeners;
  Map<FirebaseUser, Duration> timeToComplete = {};

  ProgressProvider(
      {required this.dimoniProvider,
      required this.gimcanaProvider,
      required this.usersProvider,
      required this.notifyListeners}) {
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
        sortPodium();
        sortByCaptures();
        saveTimes();
        notifyListeners();
      }
    });
  }

  // use this parse to create the leaderboard
  Progress parseProgress(Map<dynamic, dynamic> progressMap, String gimcanaId) {
    List<Discover> discovers = [];
    progressMap.forEach((key, value) {
      discovers
          .add(Discover(dimoniProvider.getDimoniById(key.toString()), value));
    });

    return Progress(gimcanaProvider.getGimcanaById(gimcanaId), discovers);
  }

  Progress getProgressOfCurrentUser() {
    if (uid == null) {
      throw Exception('User not logged in');
    }

    return _progressMap[usersProvider.getUserById(uid!)] ??
        Progress(gimcanaProvider.getGimcanaById(gimcanaId!), []);
  }

  void addDiscover(Dimoni dimoni) {
    if (uid == null) {
      throw Exception('User not logged in');
    }

    var ref = SignleDBConn.getDatabase().ref('$_path/$gimcanaId/$uid');
    ref.set({dimoni.id: DateTime.now().toString()});
  }

  get progressMap => _progressMap;

  void unSubscribe() {
    if (progressListener != null) {
      progressListener!.cancel();
    }
    gimcanaId = null;
    progressMap.clear();
    timeToComplete = {};
    notifyListeners();
  }

  void sortByCaptures() {
    List<Progress> progresses = _progressMap.values.toList();
    List<FirebaseUser> users = _progressMap.keys.toList();
    for (int i = 0; i < progresses.length - 1; i++) {
      if (progresses[i].discovers.length < progresses[i + 1].discovers.length) {
        Progress temp = progresses[i];
        progresses[i] = progresses[i + 1];
        progresses[i + 1] = temp;

        FirebaseUser tempUser = users[i];
        users[i] = users[i + 1];
        users[i + 1] = tempUser;
      } else if (progresses[i].discovers.length ==
          progresses[i + 1].discovers.length) {
        progresses[i].discovers.sort((a, b) => a.time.compareTo(b.time));
        progresses[i + 1].discovers.sort((a, b) => a.time.compareTo(b.time));

        if (DateTime.parse(progresses[i].discovers[0].time).difference(
                DateTime.parse(progresses[i]
                    .discovers[progresses[i].discovers.length - 1]
                    .time)) <
            DateTime.parse(progresses[i + 1].discovers[0].time).difference(
                DateTime.parse(progresses[i + 1]
                    .discovers[progresses[i + 1].discovers.length - 1]
                    .time))) {
          Progress temp = progresses[i];
          progresses[i] = progresses[i + 1];
          progresses[i + 1] = temp;

          FirebaseUser tempUser = users[i];
          users[i] = users[i + 1];
          users[i + 1] = tempUser;
        }
      }
    }
    _progressMap = Map.fromIterables(users, progresses);
  }

  void saveTimes() {
    Gimcama gimcana = gimcanaProvider.getGimcanaById(gimcanaId!);
    _progressMap.forEach((key, value) {
      if (value.discovers.length == gimcana.ubications.length &&
          timeToComplete[key] == null) {
        DateTime firstCapture = DateTime.parse(value.discovers[0].time);
        DateTime lastCapture =
            DateTime.parse(value.discovers[value.discovers.length - 1].time);
        timeToComplete[key] = firstCapture.difference(lastCapture);
      }
    });
  }

  void sortPodium() {
    List<FirebaseUser> users = timeToComplete.keys.toList();
    List<Duration> times = timeToComplete.values.toList();

    for (int i = 0; i < times.length - 1; i++) {
      if (times[i].compareTo(times[i + 1]) < 0) {
        Duration temp = times[i];
        times[i] = times[i + 1];
        times[i + 1] = temp;

        FirebaseUser tempUser = users[i];
        users[i] = users[i + 1];
        users[i + 1] = tempUser;
      }
    }
  }
}
