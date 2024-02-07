import 'package:app_dimonis/models/firebase/firebase_gimcama.dart';
import 'package:app_dimonis/providers/progress_provider.dart';
import 'package:app_dimonis/models/state/gimcama.dart';
import 'package:app_dimonis/providers/firebase_provider.dart';
import 'package:app_dimonis/providers/gimcana_provider.dart';
import 'package:app_dimonis/providers/playing_gimcama.dart';
import 'package:app_dimonis/providers/ui_provider.dart';
import 'package:app_dimonis/widgets/gimcama_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GimcamaList extends StatelessWidget {
  final String selectedOption;

  const GimcamaList({required this.selectedOption, super.key});

  @override
  Widget build(BuildContext context) {
    
    List<Gimcama> gimcanes = Provider.of<FireBaseProvider>(context, listen: false).gimcanaProvider.gimcanes;
    List<Gimcama> filter = gimcanes;

    if (selectedOption == 'Totes') {
      filter = gimcanes;
    } else if (selectedOption == 'Proximes') {
      filter = gimcanes.where((gimcama) => gimcama.start.isAfter(DateTime.now())).toList();
    } else if (selectedOption == 'Actuals') {
      filter = gimcanes.where((gimcama) => gimcama.isTimeToPlay()).toList();
    } else if (selectedOption == 'Anteriors') {
      filter = gimcanes.where((gimcama) => gimcama.end.isBefore(DateTime.now())).toList();
    }

    return ListView.builder(
      itemCount: filter.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            var gimcama = filter[index];
            ProgressProvider progress = Provider.of<FireBaseProvider>(context, listen: false).progressProvider;
            // Provider.of<PlayingGimcanaProvider>(context, listen: false)
            //     .currentGimcana = gimcama;
            if (gimcama.isTimeToPlay()) {
              progress.setCurrentProgress(gimcama.id);
              Provider.of<UIProvider>(context, listen: false)
                  .selectMenuOpt = 0;
            } else {
              Provider.of<UIProvider>(context, listen: false)
                  .selectMenuOpt = 1;
            }
          },
          child: GimcamaCard(gimcama: filter[index]),
        );
      },
    );
        
  }
}
