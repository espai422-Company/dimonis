import 'package:app_dimonis/models/firebase/firebase_progress.dart';
import 'package:app_dimonis/models/state/gimcama.dart';
import 'package:app_dimonis/providers/firebase_provider.dart';
import 'package:app_dimonis/providers/progress_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GimcamaCard extends StatelessWidget {
  final Gimcama gimcama;
  const GimcamaCard({super.key, required this.gimcama});

  @override
  Widget build(BuildContext context) {
    var color = gimcama.isTimeToPlay() ? Colors.green : Colors.grey;
    // var progress = FirebaseProgress(gimcanaId: gimcama.id!);
    // ProgressProvider progress = Provider.of<FireBaseProvider>(context, listen: false).progressProvider;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Border radius of the card
      ),
      margin: EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          color: color,
          child: ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            title: Text(gimcama.nom),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Start Date: ${DateFormat('yyyy-MM-dd HH:mm').format(gimcama.start)}'),
                Text('End Date: ${DateFormat('yyyy-MM-dd HH:mm').format(gimcama.end)}'),
                Text('Dimonis a trobar: ${gimcama.ubications.length}'),
              ],
            ),
            // trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
      ),
    );
  }
}
