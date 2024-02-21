import 'package:app_dimonis/models/firebase/dimoni.dart';
import 'package:app_dimonis/models/firebase/firebase_gimcama.dart';
import 'package:app_dimonis/models/firebase/firebase_user.dart';
import 'package:app_dimonis/providers/dimonis_ginkana.dart';
import 'package:app_dimonis/providers/firebase_provider.dart';
import 'package:app_dimonis/providers/gimcana_provider.dart';
import 'package:app_dimonis/providers/ui_provider.dart';
import 'package:app_dimonis/widgets/side_menu.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String nom = '';
DateTime dataInici = DateTime.now();
DateTime dataFinal = DateTime.now();
Map<dynamic, dynamic> dimonis = {};

class CreateGinkana extends StatefulWidget {
  const CreateGinkana({super.key});

  @override
  State<CreateGinkana> createState() => _CreateGinkanaState();
}

class _CreateGinkanaState extends State<CreateGinkana> {
  @override
  Widget build(BuildContext context) {
    FirebaseGimana gimcana = ModalRoute.of(context)!.settings.arguments as FirebaseGimana;
    nom = gimcana.nom;
    dataInici = gimcana.start;
    dataFinal = gimcana.end;
    dimonis = gimcana.dimonis;
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: Text("Crea una gimcana"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.5),
        children: [
          Container(
            height: 15,
          ),
          _nom('Nom de la gimcana'),
          Container(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Data d\' inici"),
              Expanded(child: SizedBox()),
              ElevatedButton(
                  onPressed: () async {
                    final date = await _datePicker(context, DateTime(2023));
                    if (date == null) {
                      return;
                    }
                    final time = await _timePicker(context);
                    if (time == null) {
                      return;
                    }
                    setState(() {
                      dataInici = _updateTime(date, time);
                    });
                  },
                  child: Text(
                      "${dataInici.year}/${dataInici.month}/${dataInici.day} ${dataInici.hour.toString().padLeft(2, "0")}:${dataInici.minute.toString().padLeft(2, "0")}")),
            ],
          ),
          Container(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Data final"),
              Expanded(child: SizedBox()),
              ElevatedButton(
                  onPressed: () async {
                    final date = await _datePicker(context, dataInici);
                    if (date == null) {
                      return;
                    }
                    final time = await _timePicker(context);
                    if (time == null) {
                      return;
                    }
                    setState(() {
                      dataFinal = _updateTime(date, time);
                    });
                  },
                  child: Text(
                      "${dataFinal.year}/${dataFinal.month}/${dataFinal.day} ${dataFinal.hour.toString().padLeft(2, "0")}:${dataFinal.minute.toString().padLeft(2, "0")}")),
            ],
          ),
          Container(
            height: 25,
          ),
          _dimonis(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          List<String> errors = comprovarDades();
          if (errors.isNotEmpty) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.bottomSlide,
              title: 'ERROR',
              desc: errors.join('\n'),
              btnCancelOnPress: () {},
              btnCancelText: 'OK',
            ).show();
            // showDialog(
            //   barrierDismissible: false,
            //   context: context,
            //   builder: (context) {
            //     return AlertDialog(
            //       icon: const Icon(Icons.error_outline_outlined),
            //       title: const Text('ERROR'),
            //       content: Text(errors.join('\n')),
            //       actions: [
            //         TextButton(
            //           onPressed: () {
            //             Navigator.of(context).pop();
            //           },
            //           child: const Text('OK'),
            //         ),
            //       ],
            //     );
            //   },
            // );
          } else {
            FirebaseUser user =
                Provider.of<FireBaseProvider>(context, listen: false)
                    .usersProvider
                    .currentUser;
            
            gimcana.nom = nom;
            gimcana.start = dataInici;
            gimcana.end = dataFinal;
            gimcana.dimonis = dimonis;
            gimcana.propietari = user.id;

            if (gimcana.id == "") {
              Provider.of<FireBaseProvider>(context, listen: false).gimcanaProvider.saveGimcama(gimcana);
            } else {
              Provider.of<FireBaseProvider>(context, listen: false).gimcanaProvider.updateGimcama(gimcana);
            }
            


            nom = '';
            dataInici = DateTime.now();
            dataFinal = DateTime.now();
            dimonis = {};
            Provider.of<TotalDimonisProvider>(context, listen: false)
                .setDimoni(dimonis.length);

            Navigator.pushReplacementNamed(context, '/');
            Provider.of<UIProvider>(context, listen: false).selectMenuOpt = 2;
          }
        },
        child: Icon(Icons.save),
      ),
    );
  }
}

Widget _dimonis(context) {
  FireBaseProvider fireBaseProvider = Provider.of<FireBaseProvider>(context);
  var totaldimonis = Provider.of<TotalDimonisProvider>(context);
  totaldimonis.setDimoni(dimonis.length);
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Dimonis"),
          Expanded(child: SizedBox()),
          Text("${totaldimonis.totaldimonis}"),
          Expanded(child: SizedBox()),
          ElevatedButton(
              onPressed: () {
                dimonis = {};
                totaldimonis.setDimoni(dimonis.length);
                totaldimonis.notify();
              },
              child: Text("Buidar dimonis")),
        ],
      ),
      Container(
        height: 25,
      ),
      Container(
        height: 250,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: fireBaseProvider.dimoniProvider.dimonis.length,
            itemBuilder: (_, int index) => _Card(
                dimoni: fireBaseProvider.dimoniProvider.dimonis[index],
                context)),
      )
    ],
  );
}

class _Card extends StatelessWidget {
  final Dimoni dimoni;

  const _Card(context, {Key? key, required this.dimoni}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Map<Dimoni, dynamic> coordenades = {
                dimoni: dimonis[dimoni.id] ?? {'x': '0', 'y': '0'}
              };
              Navigator.pushNamed(context, 'mapa_picker_dimoni',
                      arguments: coordenades)
                  .then(
                (value) => {
                  if (value != null)
                    {
                      coordenades = value as Map<Dimoni, dynamic>,
                      dimonis.addAll({dimoni.id: coordenades[dimoni]}),
                      Provider.of<TotalDimonisProvider>(context, listen: false)
                          .setDimoni(dimonis.length),
                    }
                },
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder:
                    const AssetImage('assets/LoadingDimonis-unscreen.gif'),
                image: NetworkImage(dimoni.image),
                width: 130,
                height: 190,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            dimoni.nom,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

Widget _nom(String text) {
  return TextFormField(
    decoration: InputDecoration(
      hintText: text,
      labelText: text,
      icon: Icon(Icons.games_sharp),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
    initialValue: nom,
    onChanged: (value) {
      nom = value;
    },
    validator: (value) {
      if (value == null || value.length < 8 || value.length > 15)
        return 'El nom és obligatori';
    },
  );
}

Future<DateTime?> _datePicker(context, primeradata) => showDatePicker(
    context: context,
    initialDate: dataInici,
    firstDate: primeradata,
    lastDate: DateTime(2030));

Future<TimeOfDay?> _timePicker(context) => showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: dataInici.hour, minute: dataInici.minute));

DateTime _updateTime(DateTime date, TimeOfDay time) {
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

List<String> comprovarDades() {
  List<String> errors = [];

  if (dimonis.length < 3) {
    errors.add("El minim de dimonis pera una gincana son ${dimonis.length}/3");
  }

  if (dataFinal.isBefore(dataInici)) {
    errors
        .add("La data final de la gincana no pot ser menor a la data d'inici");
  }

  if (!RegExp(r'^(.{8,})$').hasMatch(nom)) {
    errors.add("El nom de la gincana es massa curt ${nom.length}/8");
  }

  if (nom.length > 15){
    errors.add("El nom de la gincana es massa llarg ${nom.length}/15");
  }

  return errors;
}
