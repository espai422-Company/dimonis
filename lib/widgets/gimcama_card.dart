import 'package:app_dimonis/models/gimcama.dart';
import 'package:flutter/material.dart';

class GimcamaCard extends StatelessWidget {
  final Gimcama gimcama;
  const GimcamaCard({super.key, required this.gimcama});

  @override
  Widget build(BuildContext context) {
    var color = gimcama.isTimeToPlay() ? Colors.green : Colors.grey;
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Container(
        color: color,
        child: ListTile(
          title: Text(gimcama.nom),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Start Date: ${gimcama.start}'),
              Text('End Date: ${gimcama.end}'),
              FutureBuilder(
                future: gimcama.getDimonis(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Text('Dimonis a trobar: ${snapshot.data!.length}');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
