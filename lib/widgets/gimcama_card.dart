import 'package:flutter/material.dart';

class GimcamaCard extends StatelessWidget {
  GimcamaCard({super.key});
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
    return ListView.builder(
      itemCount: _data.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(_data[index]['title']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Start Date: ${_data[index]['startDate']}'),
                Text('End Date: ${_data[index]['endDate']}'),
                Text('Number of Items: ${_data[index]['numItems']}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
