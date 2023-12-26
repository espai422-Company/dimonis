import 'package:app_dimonis/api/db_connection.dart';
import 'package:app_dimonis/models/dimoni.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;

// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as dtPicker;

class CreateGinkana extends StatelessWidget {
  const CreateGinkana({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crea una gincana"),
      ),
      body: Column(
        children: [
          Container(
            height: 25,
          ),
          _nom('Nom de la gincana'),
          Container(
            height: 25,
          ),
          // _dataHora(context),
          Container(
            height: 25,
          ),
          _dimonis(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        child: Icon(Icons.save),
      ),
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

  const _Card({Key? key, required this.dimoni}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'mapa_picker_dimoni',
                arguments: dimoni),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
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

// Widget _card(Dimoni d) {
//     return Card(
//       elevation: 10,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
//       child: Column(
//         children: [
//           ListTile(
//             leading: Image(image: NetworkImage(d.image)),
//             title: Text(d.nom),
//             subtitle: Text(d.description),

//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               TextButton(onPressed: (){}, child: const Text('Coloca')),
//             ],
//           )
//         ],
//       ),
//     );
//   }

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
  );
}

// Widget _dataHora(context) {
//   DateTime selectedDate = DateTime.now();

//   return TextButton(
//     onPressed: () async {
//       DateTime? pickedDate = await dtPicker.DatePicker.showDatePicker(
//         context,
//         showTitleActions: true,
//         minTime: DateTime(2023, 3, 5), 
//         maxTime: DateTime(2030, 6, 7),
//         theme: dtPicker.DatePickerTheme(
//           headerColor: Color.fromARGB(255, 255, 0, 0),
//           backgroundColor: const Color.fromARGB(255, 0, 0, 0),
//           itemStyle: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//           doneStyle: const TextStyle(color: Colors.white, fontSize: 16),
//         ),
//         onChanged: (date) {
//           print('change $date in time zone ' +
//               date.timeZoneOffset.inHours.toString());
//         },
//         onConfirm: (date) {
//           print('confirm $date');
//         },
//         currentTime: selectedDate,
//         locale: dtPicker.LocaleType.en,
//       );

//       if (pickedDate != null && pickedDate != selectedDate) {
//         selectedDate = pickedDate;
//       }

//       dtPicker.DatePicker.showTimePicker(
//         context,
//         showTitleActions: true,
//         currentTime: selectedDate,
//         theme: dtPicker.DatePickerTheme(
//           headerColor: Colors.orange,
//           backgroundColor: Colors.blue,
//           itemStyle: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//           doneStyle: const TextStyle(color: Colors.white, fontSize: 16),
//         ),
//         locale: dtPicker.LocaleType.es,
//       );
//     },
//     child: Text(
//       'Selecciona una data',
//       style: TextStyle(color: Colors.blue),
//     ),
//   );
// }

