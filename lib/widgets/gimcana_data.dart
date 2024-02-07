import 'package:app_dimonis/models/firebase/dimoni.dart';
import 'package:app_dimonis/models/firebase/firebase_progress.dart';
import 'package:app_dimonis/providers/playing_gimcama.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GimcamaData extends StatelessWidget {
  GimcamaData({super.key});

  @override
  Widget build(BuildContext context) {
    var playing = Provider.of<PlayingGimcanaProvider>(context, listen: true);
    var progress = FirebaseProgress(gimcanaId: playing.currentGimcana!.id!);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(child: SizedBox()),
        Text(
          "${playing.currentGimcana!.nom}",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(child: SizedBox()),
        FutureBuilder(
          future: Future.wait(
              [progress.getMyPosition(), progress.getLeaderBoard()]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data![0] == 0 ||
                snapshot.data == null ||
                snapshot.data![1] == 0) {
              return Text('Encara no has trobat cap dimoni');
            } else {
              List<String> leaderboardData = snapshot.data![1] as List<String>;
              return Text(
                  'Posició: ${snapshot.data![0]} / ${leaderboardData.length}');
            }
          },
        ),
        // FutureBuilder(
        //   future: Future.wait(
        //       [progress.getProgress(), playing.currentGimcana!.getDimonis()]
        //       ),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return CircularProgressIndicator();
        //     } else if (snapshot.hasError) {
        //       return Text('Error: ${snapshot.error}');
        //     } else if (snapshot.data == null || snapshot.data![0] == 0) {
        //       return Text('Comença a capturar dimonis');
        //     } else {
        //       var _trobats = snapshot.data![0] as Map<String, DateTime>;
        //       var _dimonisTotals = snapshot.data![1] as List<Dimoni>;
        //       return Text(
        //           'Dimonis trobats: ${_trobats.length} / ${_dimonisTotals.length}');
        //     }
        //   },
        // ),
        Expanded(child: SizedBox()),
        ElevatedButton(
            onPressed: () => playing.currentGimcana = null,
            child: Text("Tornar a les gimcanes")),
        Expanded(child: SizedBox()),
      ]),
    );
  }
}
