import 'package:app_dimonis/models/progres.dart';
import 'package:app_dimonis/widgets/gimcama_list.dart';
import 'package:app_dimonis/widgets/gimcana_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_dimonis/providers/playing_gimcama.dart';

class GimcamaScreen extends StatelessWidget {
  const GimcamaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var playing = Provider.of<PlayingGimcanaProvider>(context, listen: true);
    
    if (playing.currentGimcana == null) {
      return Center(child: GimcamaList());
    } else {
      return Center(child: GimcamaData());
    }
  }
}
