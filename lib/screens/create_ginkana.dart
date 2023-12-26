import 'package:app_dimonis/api/db_connection.dart';
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
          _nom('Nom de la gincana'),
          // _dataHora(context),
        
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => {}, child: Icon(Icons.save),),
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

