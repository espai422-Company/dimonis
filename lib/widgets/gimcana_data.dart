import 'dart:async';

import 'package:app_dimonis/preferences/preferences.dart';
import 'package:app_dimonis/providers/firebase_provider.dart';
import 'package:app_dimonis/providers/progress_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class GimcamaData extends StatelessWidget {
  const GimcamaData({super.key});

  @override
  Widget build(BuildContext context) {
    var progressProvider =
        Provider.of<FireBaseProvider>(context, listen: true).progressProvider;
    // Map<FirebaseUser,Progress> progress = progressProvider.progressMap;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        // SizedBox(
        //   height: 300,
        //   child:
        SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: progressProvider.progressMap.length,
              itemBuilder: (context, index) {
                var user = progressProvider.progressMap.keys.elementAt(index);
                var progress = progressProvider.progressMap[user]!;
                Widget count;

                count = getTime(progressProvider, user, progress, context);

                return Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      color: index == 0
                          ? const Color.fromARGB(137, 216, 187, 26)
                          : (index == 1
                              ? const Color.fromARGB(127, 205, 206, 205)
                              : (index == 2
                                  ? const Color.fromARGB(123, 187, 121, 0)
                                  : Preferences.isDarkMode
                                      ? const Color.fromARGB(137, 255, 124, 124)
                                      : const Color.fromARGB(
                                          155, 255, 127, 127))),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: index == 0
                            ? 5
                            : (index == 1 ? 4 : (index == 2 ? 3 : 3)),
                        color: index == 0
                            ? const Color.fromARGB(255, 216, 188, 26)
                            : (index == 1
                                ? const Color.fromARGB(255, 205, 206, 205)
                                : (index == 2
                                    ? const Color.fromARGB(255, 187, 121, 0)
                                    : const Color.fromARGB(0, 255, 255, 255))),
                      )),
                  child: ListTile(
                    leading: index == 0
                        ? Image.asset(
                            alignment: Alignment.centerLeft,
                            "assets/fotos_clasificacio/Oro.png",
                            width: 40,
                          )
                        : (index == 1
                            ? Image.asset(
                                alignment: Alignment.centerLeft,
                                "assets/fotos_clasificacio/Plata.png",
                                width: 40,
                              )
                            : (index == 2
                                ? Image.asset(
                                    alignment: Alignment.centerLeft,
                                    "assets/fotos_clasificacio/Bronze.png",
                                    width: 40,
                                  )
                                : Container(
                                    alignment: Alignment.centerLeft,
                                    width: 40,
                                    child: Text('${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.red, // Color rojo
                                          fontSize: 24, // Tamaño de fuente
                                          fontWeight:
                                              FontWeight.bold, // Negrita
                                          fontStyle:
                                              FontStyle.italic, // Cursiva
                                          decorationColor: Colors
                                              .redAccent, // Color de subrayado
                                          decorationThickness:
                                              2, // Grosor del subrayado
                                          shadows: [
                                            Shadow(
                                              color: Colors.black,
                                              blurRadius: 2,
                                              offset: Offset(1, 1),
                                            ),
                                          ], // Sombra
                                        )),
                                  ))),
                    title: Text(user.displayName),
                    subtitle: count,
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!.dimonis),
                        Text("${progress.discovers.length}"),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // ),
        FloatingActionButton(
            onPressed: () => progressProvider.unSubscribe(),
            child: const Icon(Icons.exit_to_app)),
      ]),
    );
  }

  getTime(
      ProgressProvider progressProvider, user, progress, BuildContext context) {
    if (progressProvider.timeToComplete[user] == null) {
      DateTime primeraCaptura = DateTime.parse(progress.discovers[0].time);
      Duration difference = primeraCaptura.difference(DateTime.now());

      int days = difference.inDays * -1;
      int hours = difference.inHours.remainder(24) * -1;
      int minutes = difference.inMinutes.remainder(60) * -1;
      int seconds = difference.inSeconds.remainder(60) * -1;

      return CountUp(
          days: days, hours: hours, minutes: minutes, seconds: seconds);
    } else {
      Duration difference = progressProvider.timeToComplete[user]!;

      int days = difference.inDays * -1;
      int hours = difference.inHours.remainder(24) * -1;
      int minutes = difference.inMinutes.remainder(60) * -1;
      int seconds = difference.inSeconds.remainder(60) * -1;

      return Text(
          "${AppLocalizations.of(context)!.completed} \n ${days}d ${hours}h ${minutes}m ${seconds}s");
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
