import 'package:app_dimonis/api/db_connection.dart';
import 'package:app_dimonis/models/dimoni.dart';
import 'package:app_dimonis/widgets/side_menu.dart';
import 'package:flutter/material.dart';

String nom = '';
DateTime dataInici = DateTime(2023, 12, 31, 0, 0);
DateTime dataFinal = DateTime(2024, 12, 31, 0, 0);

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
      body: Column(
        children: [
          Container(height: 25,),
          _nom('Nom de la gincana'),
          Container(height: 25,),
          Row(children: [
            Expanded(child: SizedBox()),
            Text("Data inici"),
            Expanded(child: SizedBox()),
            ElevatedButton(
            onPressed: () async {
              final date = await _datePicker(context);
              if (date == null){
                return;
              }
              final time = await _timePicker(context);
              if (time == null){
                return;
              }
              setState(() {
                dataInici = _updateTime(date, time);
              });
            }, 
            child: Text("${dataInici.year}/${dataInici.month}/${dataInici.day} ${dataInici.hour.toString().padLeft(2, "0")}:${dataInici.minute.toString().padLeft(2, "0")}")),
            Expanded(child: SizedBox()),
          ],),
          Container(height: 25,),
          Row(children: [
            Expanded(child: SizedBox()),
            Text("Data final"),
            Expanded(child: SizedBox()),
            ElevatedButton(
            onPressed: () async {
              final date = await _datePicker(context);
              if (date == null){
                return;
              }
              final time = await _timePicker(context);
              if (time == null){
                return;
              }
              setState(() {
                dataFinal = _updateTime(date, time);
              });
            }, 
            child: Text("${dataInici.year}/${dataInici.month}/${dataInici.day} ${dataInici.hour.toString().padLeft(2, "0")}:${dataInici.minute.toString().padLeft(2, "0")}")),
            Expanded(child: SizedBox()),
          ],),
          Container(height: 25,),
          _dimonis(),
          
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => {}, child: Icon(Icons.save),),
    );
  }
}

Widget _dimonis() {
  return FutureBuilder<List<Dimoni>>(
    future: DBConnection().readDimonisFromDatabase(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        List<Dimoni> dimonis = snapshot.data ?? [];
        return Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dimonis.length,
                itemBuilder: (_, int index) => _Card(dimoni: dimonis[index])),
          );
      }
    },
  );
}

class _Card extends StatelessWidget {

  final Dimoni dimoni;

  const _Card({
    Key? key,
    required this.dimoni
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            // onTap: () => print(dimoni.x),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: AssetImage('assets/LoadingDimonis.gif'),
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
            dimoni.nom ,
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
    onChanged: (value)  {
      nom = value;
    },
  );
}

Future<DateTime?> _datePicker(context) =>
  showDatePicker(
    context: context, 
    initialDate: dataInici, 
    firstDate: DateTime(2023), 
    lastDate: DateTime(2030));

Future<TimeOfDay?> _timePicker(context) =>
  showTimePicker(
    context: context, 
    initialTime: TimeOfDay(hour: dataInici.hour, minute: dataInici.minute));

DateTime _updateTime(DateTime date, TimeOfDay time){
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}