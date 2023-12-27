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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Text('Gimcama Screen'),
              Text('Gimcama Screen'),
            ],
          ),
        ),
      ),
    );
  }
}
