import 'dart:async';

import 'package:app_dimonis/models/firebase/dimoni.dart';
import 'package:app_dimonis/models/firebase/firebase_progress.dart';
import 'package:app_dimonis/models/firebase/firebase_user.dart';
import 'package:app_dimonis/models/state/progress.dart';
import 'package:app_dimonis/providers/firebase_provider.dart';
import 'package:app_dimonis/providers/playing_gimcama.dart';
import 'package:app_dimonis/providers/progress_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GimcamaData extends StatelessWidget {
  GimcamaData({super.key});


  @override
  Widget build(BuildContext context) {
    var progressProvider = Provider.of<FireBaseProvider>(context, listen: true).progressProvider;
    Map<FirebaseUser,Progress> progress = progressProvider.progressMap;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          height: 300,
          width: 300,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: progressProvider.progressMap.length,
            itemBuilder: (context, index) {
              var user = progressProvider.progressMap.keys.elementAt(index);
              var progress = progressProvider.progressMap[user]!;
              dynamic count;

              count = getTime(progressProvider, user, progress);

              return ListTile(
                  title: Text("${index + 1} ${user.displayName}"),
                  subtitle: count,
                  trailing: Text(progress.discovers.length.toString()),
                );
            },
          ),
        ),
        Expanded(child: SizedBox()),
        ElevatedButton(
            onPressed: () => progressProvider.unSubscribe(),
            child: Text("Tornar a les gimcanes")),
        Expanded(child: SizedBox()),
      ]),
    );
  }

  getTime(ProgressProvider progressProvider, user, progress) {
    if (progressProvider.timeToComplete[user] == null) {
      DateTime primeraCaptura = DateTime.parse(progress.discovers[0].time);
      Duration difference = primeraCaptura.difference(DateTime.now());
    
      int days = difference.inDays * -1;
      int hours = difference.inHours.remainder(24) * -1;
      int minutes = difference.inMinutes.remainder(60) * -1;
      int seconds = difference.inSeconds.remainder(60) * -1;
    
      return CountUp(days: days, hours: hours, minutes: minutes, seconds: seconds);
      
    } else {
      Duration difference = progressProvider.timeToComplete[user]!;
    
      int days = difference.inDays * -1;
      int hours = difference.inHours.remainder(24) * -1;
      int minutes = difference.inMinutes.remainder(60) * -1;
      int seconds = difference.inSeconds.remainder(60) * -1;
    
      return Text("Completat en ${days}d ${hours}h ${minutes}m ${seconds}s");
    }
  }
}

class CountUp extends StatefulWidget {
  const CountUp({
    super.key,
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  @override
  State<CountUp> createState() => _CountUpState();
}

class _CountUpState extends State<CountUp> {
  late Timer _timer;
  late int _currentSeconds;

  @override
  void initState() {
    super.initState();
    _currentSeconds = widget.seconds;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentSeconds++;
        if (_currentSeconds >= 60) {
          _currentSeconds = 0;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "${widget.days}d ${widget.hours}h ${widget.minutes}m $_currentSeconds s",
    );
  }
}
