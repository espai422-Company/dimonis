import 'package:app_dimonis/models/firebase/firebase_gimcama.dart';
import 'package:app_dimonis/providers/progress_provider.dart';
import 'package:app_dimonis/models/state/gimcama.dart';
import 'package:app_dimonis/providers/firebase_provider.dart';
import 'package:app_dimonis/providers/ui_provider.dart';
import 'package:app_dimonis/widgets/gimcama_card.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GimcamaList extends StatelessWidget {
  final String selectedOption;

  const GimcamaList({required this.selectedOption, super.key});

  @override
  Widget build(BuildContext context) {
    List<Gimcama> gimcanes =
        Provider.of<FireBaseProvider>(context, listen: false)
            .gimcanaProvider
            .gimcanes;
    List<Gimcama> filter = gimcanes;

    if (selectedOption == 'Totes') {
      filter = gimcanes;
    } else if (selectedOption == 'Proximes') {
      filter = gimcanes
          .where((gimcama) => gimcama.start.isAfter(DateTime.now()))
          .toList();
    } else if (selectedOption == 'Actuals') {
      filter = gimcanes.where((gimcama) => gimcama.isTimeToPlay()).toList();
    } else if (selectedOption == 'Anteriors') {
      filter = gimcanes
          .where((gimcama) => gimcama.end.isBefore(DateTime.now()))
          .toList();
    }

    return RefreshIndicator(
      onRefresh: () async {
        (_) => Provider.of<FireBaseProvider>(context, listen: false)
            .gimcanaProvider
            .reload();
      },
      child: ListWheelScrollView(
        itemExtent: 150,
        children: List.generate(
          filter.length,
          (index) => GestureDetector(
            onTap: () {
              var gimcama = filter[index];
              ProgressProvider progress =
                  Provider.of<FireBaseProvider>(context, listen: false)
                      .progressProvider;
              if (gimcama.isTimeToPlay()) {
                progress.setCurrentProgress(gimcama.id);
                Provider.of<UIProvider>(context, listen: false).selectMenuOpt =
                    0;
              } else {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  buttonsBorderRadius: const BorderRadius.all(
                    Radius.circular(2),
                  ),
                  dismissOnTouchOutside: true,
                  dismissOnBackKeyPress: false,
                  animType: AnimType.topSlide,
                  title: AppLocalizations.of(context)!.cannotPlayTitle,
                  desc: AppLocalizations.of(context)!.cannotPlayDesc,
                  btnCancelOnPress: () {},
                  btnCancelText: 'OK',
                ).show();
              }
            },
            onLongPress: () {
              var gimcama = filter[index];
              if (gimcama.start.isAfter(DateTime.now()) &&
                  gimcama.propietari ==
                      Provider.of<FireBaseProvider>(context, listen: false)
                          .usersProvider
                          .currentUser
                          .id) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  buttonsBorderRadius: const BorderRadius.all(
                    Radius.circular(2),
                  ),
                  dismissOnTouchOutside: true,
                  dismissOnBackKeyPress: false,
                  headerAnimationLoop: false,
                  animType: AnimType.topSlide,
                  title: AppLocalizations.of(context)!.editScavengerHuntTitle,
                  desc:
                      '${AppLocalizations.of(context)!.editScavengerHuntDesc} ${gimcama.nom}?',
                  showCloseIcon: true,
                  btnCancelOnPress: () => {},
                  btnOkOnPress: () {
                    Map<dynamic, dynamic> dimonis = {};
                    gimcama.ubications.forEach((element) {
                      dimonis.addAll({
                        element.dimoni.id: {
                          'x': element.x,
                          'y': element.y,
                        }
                      });
                    });
                    Navigator.pushReplacementNamed(context, 'crear_gimcana',
                        arguments: FirebaseGimana(
                            nom: gimcama.nom,
                            start: gimcama.start,
                            end: gimcama.end,
                            dimonis: dimonis,
                            propietari: gimcama.propietari,
                            id: gimcama.id));
                  },
                ).show();
              }
            },
            child: GimcamaCard(gimcama: filter[index]),
          ),
        ),
      ),
    );
  }
}
