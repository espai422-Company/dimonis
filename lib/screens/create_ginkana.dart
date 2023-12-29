import 'package:app_dimonis/models/dimoni.dart';
import 'package:app_dimonis/models/gimcama.dart';
import 'package:app_dimonis/providers/dimonis_ginkana.dart';
import 'package:app_dimonis/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String nom = '';
DateTime dataInici = DateTime(2023, 12, 31, 0, 0);
DateTime dataFinal = DateTime(2024, 12, 31, 0, 0);
List<Dimoni> dimonis = [];

class CreateGinkana extends StatefulWidget {
  const CreateGinkana({super.key});

  @override
  State<CreateGinkana> createState() => _CreateGinkanaState();
}

class _CreateGinkanaState extends State<CreateGinkana> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideMenu(),
        appBar: AppBar(
          title: Text("Crea una gincana"),
        ),
        body: ListView(
          padding: EdgeInsets.all(25),
          children: [
            Container(
              height: 15,
            ),
            _nom('Nom de la gincana'),
            Container(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Data inici"),
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
            if (errors.isNotEmpty){
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      icon: const Icon(Icons.error_outline_outlined),
                      title: const Text('ERROR'),
                      content:
                          Text(errors.join('\n')),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
            } else{
              Gimcama gimcana = Gimcama(nom: nom, start: dataInici, end: dataFinal);
              dimonis.forEach((element) {
                gimcana.addDimoni(element, element.x, element.y);
              });
              gimcana.save();
              nom = '';
              dataInici = DateTime(2023, 12, 31, 0, 0);
              dataFinal = DateTime(2024, 12, 31, 0, 0);
              dimonis = [];
              Provider.of<TotalDimonisProvider>(context, listen: false).setDimoni(dimonis.length);
            }
          },
          child: Icon(Icons.save),
        ),
    );
  }
}

Widget _dimonis(context) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Dimonis"),
          Expanded(child: SizedBox()),
          Text("${Provider.of<TotalDimonisProvider>(context).totaldimonis}"),
          Expanded(child: SizedBox()),
          ElevatedButton(
              onPressed: () {
                dimonis = [];
                Provider.of<TotalDimonisProvider>(context, listen: false).setDimoni(dimonis.length);
              },
              child: Text("Buidar dimonis")),
        ],
      ),
      Container(
        height: 25,
      ),
      Container(
        height: 250,
        child: FutureBuilder<List<Dimoni>>(
          future: Dimoni.getDimonis(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Dimoni> dimonis = snapshot.data ?? [];
              return Container(
                height: 250,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: dimonis.length,
                    itemBuilder: (_, int index) => _Card(dimoni: dimonis[index], context)),
              );
            }
          },
        ),
      ),
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
              Dimoni dimoniTemporal = dimoni;
              Navigator.pushNamed(context, 'mapa_picker_dimoni', arguments: dimoniTemporal).then(
                (value) => {
                  if (value != null)
                    {
                      dimoniTemporal = value as Dimoni,
                      dimoni.x = dimoniTemporal.x,
                      dimoni.y = dimoniTemporal.y,
                      dimonis.removeWhere((d) => d.nom == dimoniTemporal.nom),
                      dimonis.add(dimoniTemporal),
                      Provider.of<TotalDimonisProvider>(context, listen: false).setDimoni(dimonis.length),
                    }
                },
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/LoadingDimonis-unscreen.gif'),
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
  return TextField(
    decoration: InputDecoration(
      hintText: text,
      labelText: text,
      icon: Icon(Icons.games_sharp),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
    onChanged: (value) {
      nom = value;
    },
  );
}

Future<DateTime?> _datePicker(context, primeradata) => showDatePicker(
    context: context,
    initialDate: dataInici,
    firstDate: primeradata,
    lastDate: DateTime(2030));

Future<TimeOfDay?> _timePicker(context) =>
    showTimePicker(context: context, initialTime: TimeOfDay(hour: dataInici.hour, minute: dataInici.minute));

DateTime _updateTime(DateTime date, TimeOfDay time) {
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

List<String> comprovarDades(){
  List<String> errors = [];

  if (dimonis.length < 3){
    errors.add("El minim de dimonis pera una gincana son ${dimonis.length}/3");
  }

  if (dataFinal.isBefore(dataInici)){
    errors.add("La data final de la gincana no pot ser menor a la data d'inici");
  }

  if (!RegExp(r'^(.{8,})$').hasMatch(nom)){
    errors.add("El nom de la gincana es massa curt ${nom.length}/8");
  }

  return errors;
}