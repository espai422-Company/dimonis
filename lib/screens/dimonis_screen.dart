import 'package:app_dimonis/auth.dart';
import 'package:app_dimonis/providers/playing_gimcama.dart';
import 'package:app_dimonis/screens/create_ginkana.dart';
import 'package:flutter/material.dart';
import 'package:app_dimonis/api/db_connection.dart';
import 'package:app_dimonis/models/dimoni.dart';
import 'package:app_dimonis/models/gimcama.dart';
import 'package:app_dimonis/models/progres.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class DimonisScreen extends StatelessWidget {
  const DimonisScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    var playing = Provider.of<PlayingGimcanaProvider>(context, listen: true);

    return Scaffold(
      body: Builder(
        builder: (context) {
          if (playing.currentGimcana == null) {
            return Center(
              child: Text('No t\'has unit a cap gincana'),
            );
          }

          if (playing.dimonis == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

          return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: playing.dimonis!.length ?? 0,
                itemBuilder: (_, int index) =>
                    _Card(dimoni: playing.dimonis![index], context),
              );
            },
          )
    );
  }
}

class _Card extends StatelessWidget {
  final Dimoni dimoni;

  const _Card(context, {Key? key, required this.dimoni}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
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
          Expanded(child: SizedBox()),
          Text(
            dimoni.nom,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}