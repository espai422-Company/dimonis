import 'package:app_dimonis/auth.dart';
import 'package:flutter/material.dart';
import 'package:app_dimonis/api/db_connection.dart';
import 'package:app_dimonis/models/dimoni.dart';
import 'package:app_dimonis/models/gimcama.dart';
import 'package:app_dimonis/models/progres.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DimonisScreen extends StatelessWidget {
  const DimonisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Auth();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              if (1 == 2) Text('Ets admin'),
              Text('Dimonis Screen'),
              FutureBuilder(
                future: auth.isAdmin(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data) {
                      return Text('Ets admin');
                    } else {
                      return Text('No ets admin');
                    }
                  } else {
                    return Text('No tens data');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
