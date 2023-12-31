import 'package:app_dimonis/models/gimcama.dart';
import 'package:app_dimonis/providers/playing_gimcama.dart';
import 'package:app_dimonis/providers/ui_provider.dart';
import 'package:app_dimonis/widgets/gimcama_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GimcamaList extends StatelessWidget {
  GimcamaList({super.key});

  @override
  Widget build(BuildContext context) {
    final gimcames = Gimcama.getGimcames();
    return FutureBuilder<List<Gimcama>>(
        future: Gimcama.getGimcames(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    var gimcama = snapshot.data![index];
                    Provider.of<PlayingGimcanaProvider>(context, listen: false)
                        .currentGimcana = gimcama;
                    if (gimcama.isTimeToPlay()) {
                      Provider.of<UIProvider>(context, listen: false)
                          .selectMenuOpt = 0;
                    } else {
                      Provider.of<UIProvider>(context, listen: false)
                          .selectMenuOpt = 1;
                    }
                  },
                  child: GimcamaCard(gimcama: snapshot.data![index]),
                );
              },
            );
          }
        });
  }
}
