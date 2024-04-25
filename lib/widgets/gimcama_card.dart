import 'package:app_dimonis/models/state/gimcama.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GimcamaCard extends StatelessWidget {
  final Gimcama gimcama;
  const GimcamaCard({super.key, required this.gimcama});

  @override
Widget build(BuildContext context) {
  var color = gimcama.isTimeToPlay() ? const Color.fromARGB(255, 202, 46, 46) : Colors.grey;

  return Card(
    elevation: 10,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: color,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        title: Text(
          gimcama.nom.toUpperCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Inici: ${DateFormat('yyyy-MM-dd HH:mm').format(gimcama.start)}',
              style: const TextStyle(color: Colors.black),
            ),
            Text(
              'Final: ${DateFormat('yyyy-MM-dd HH:mm').format(gimcama.end)}',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.location_on,
                  color: Colors.black,
                  size: 16,
                ),
                const SizedBox(width: 4), 
                Text(
                  'Dimonis a trobar: ${gimcama.ubications.length}',
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}


}
