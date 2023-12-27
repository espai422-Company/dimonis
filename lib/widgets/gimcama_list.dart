import 'package:app_dimonis/models/gimcama.dart';
import 'package:app_dimonis/widgets/gimcama_card.dart';
import 'package:flutter/material.dart';

class GimcamaList extends StatelessWidget {
  GimcamaList({super.key});
  final List<Map<String, dynamic>> _data = [
    {
      'title': 'Card 1 Title',
      'startDate': '2023-01-01',
      'endDate': '2023-01-15',
      'numItems': 10,
    },
    {
      'title': 'Card 2 Title',
      'startDate': '2023-02-05',
      'endDate': '2023-02-20',
      'numItems': 8,
    },
    // Add more data for additional cards as needed
  ];

  @override
  Widget build(BuildContext context) {
    final gimcames = Gimcama.getGimcames();
    return FutureBuilder<List<Gimcama>>(
        future: Gimcama.getGimcames(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return GimcamaCard(gimcama: snapshot.data![index]);
              },
            );
          }
        });
  }
}
