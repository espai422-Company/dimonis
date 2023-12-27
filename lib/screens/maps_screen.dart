import 'package:app_dimonis/providers/playing_gimcama.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapsScreen extends StatelessWidget {
  const MapsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var currentGimcama =
        Provider.of<PlayinGimcamaProvider>(context).currentGimcama;
    return Center(child: Text('MAPS, current gimcama ${currentGimcama?.nom}'));
  }
}
