import 'dart:io';

import 'package:app_dimonis/models/dimoni.dart';
import 'package:app_dimonis/services/select_image.dart';
import 'package:app_dimonis/services/upload_dimoni_image.dart';
import 'package:app_dimonis/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CrearDimoni extends StatefulWidget {
  const CrearDimoni({super.key});

  @override
  State<CrearDimoni> createState() => _CrearDimoniState();
}

class _CrearDimoniState extends State<CrearDimoni> {
  File? imagen_to_upload;
  final TextEditingController _controllerNom = TextEditingController();
  final TextEditingController _controllerDescripcio = TextEditingController();
  String _nom = '';
  String _descripcio = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Dimoni'),
        backgroundColor: Colors.black,
      ),
      drawer: const SideMenu(),
      body: Padding(
        padding: const EdgeInsetsDirectional.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _controllerNom,
                autofocus: false,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Nom del Dimoni',
                  helperText: 'Posi el nom complet',
                  suffixIcon: const Icon(Icons.accessibility),
                  icon: const Icon(Icons.person_4_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onChanged: (String value) {
                  setState(() {
                    _nom = value;
                  });
                },
              ),
              const Divider(),
              TextField(
                controller: _controllerDescripcio,
                autofocus: false,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Descripcio del Dimoni',
                  helperText: 'Posi la descripcio',
                  suffixIcon: const Icon(Icons.description_outlined),
                  icon: const Icon(Icons.person_4_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onChanged: (String value) {
                  setState(() {
                    _descripcio = value;
                  });
                },
              ),
              const Divider(),
              ElevatedButton(
                onPressed: () async {
                  final imagen = await getImageGallery();
                  setState(() {
                    imagen_to_upload = File(imagen!.path);
                  });
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.image_outlined),
                    Text('Seleccionar Imagen'),
                  ],
                ),
              ),
              const Divider(),
              imagen_to_upload != null
                  ? SizedBox(
                      height: 300,
                      child: Image.file(
                        imagen_to_upload!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      height: 300,
                      color: Colors.blue,
                    )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (imagen_to_upload != null && _nom != '' && _descripcio != '') {
            Dimoni dimoniTemp = Dimoni(
                nom: _nom, image: '', description: _descripcio, x: '0', y: '0');

            final uploadedDimoni =
                await uploadDimoni(dimoniTemp, imagen_to_upload!);

            if (uploadedDimoni) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Dimoni pujat correctament.'),
                ),
              );
              tornarDefault();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('ERROR al pujar el dimoni.'),
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Rellene todos los campos anteriores.'),
              ),
            );
          }
        },
        child: const Icon(Icons.save),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void tornarDefault() {
    setState(() {
      _controllerNom.clear();
      _controllerDescripcio.clear();
      _nom = '';
      _descripcio = '';
      imagen_to_upload = null;
    });
  }
}
