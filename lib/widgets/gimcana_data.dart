import 'package:app_dimonis/models/progres.dart';
import 'package:app_dimonis/providers/playing_gimcama.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GimcamaData extends StatelessWidget {
  GimcamaData({super.key});

  @override
  Widget build(BuildContext context) {
    var playing = Provider.of<PlayingGimcanaProvider>(context, listen: true);
    var progress = Progress(gimcanaId: playing.currentGimcana!.id!);
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: SizedBox()),
          Text(
            "${playing.currentGimcana!.nom}",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),),
          Expanded(child: SizedBox()),
          FutureBuilder(
            future: Future.wait([progress.getMyPosition(), progress.getLeaderBoard()]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.data![0] == 0 || snapshot.data == null || snapshot.data![1] == 0) {
                return Text('Encara no has trobat cap dimoni');
              } else {
                List<String> leaderboardData = snapshot.data![1] as List<String>;
                return Text('Posició: ${snapshot.data![0]} / ${leaderboardData.length}');
              }
            },
          ),
          Expanded(child: SizedBox()),
          ElevatedButton(
            onPressed: () => playing.currentGimcana = null, 
            child: Text("Tornar a les gimcanes")),
          Expanded(child: SizedBox()),
      ]);
  }
}
