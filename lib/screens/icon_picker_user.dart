import 'dart:io';

import 'package:app_dimonis/providers/firebase_provider.dart';
import 'package:app_dimonis/services/select_image.dart';
import 'package:app_dimonis/services/upload_dimoni_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ImagePickerScreen extends StatelessWidget {
  const ImagePickerScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: imageExists(
          'https://firebasestorage.googleapis.com/v0/b/appdimonis.appspot.com/o/Icons%2F${FirebaseAuth.instance.currentUser!.uid}.png?alt=media&token=fd63afe7-b022-4fe4-96ec-5dc6675ad6a3'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final bool imageExists = snapshot.data ?? false;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Canvi d'icona"),
            backgroundColor: Colors.black,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final imagen = await getImageGallery();

              if (imagen != null) {
                final imageFile = File(imagen.path);
                final result = await uploadImageUser(context, imageFile);
                Navigator.of(context).pop(result);
              }
            },
            child: const Icon(Icons.upload),
          ),
          body: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemCount: 6, // Cambiar al número correcto de imágenes a mostrar
            itemBuilder: (context, index) {
              if (index == 0 && imageExists) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(
                        "https://firebasestorage.googleapis.com/v0/b/appdimonis.appspot.com/o/Icons%2F${FirebaseAuth.instance.currentUser!.uid}.png?alt=media&token=fd63afe7-b022-4fe4-96ec-5dc6675ad6a3");
                  },
                  child: FadeInImage.assetNetwork(
                    placeholder: "assets/LoadingDimonis-unscreen.gif",
                    image:
                        "https://firebasestorage.googleapis.com/v0/b/appdimonis.appspot.com/o/Icons%2F${FirebaseAuth.instance.currentUser!.uid}.png?alt=media&token=fd63afe7-b022-4fe4-96ec-5dc6675ad6a3?timestamp=${DateTime.now().millisecondsSinceEpoch}",
                    height: 100,
                  ),
                );
              }

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(
                      "https://firebasestorage.googleapis.com/v0/b/appdimonis.appspot.com/o/Icons%2Fdemon$index.png?alt=media&token=fd63afe7-b022-4fe4-96ec-5dc6675ad6a3");
                },
                child: FadeInImage.assetNetwork(
                  placeholder: "assets/LoadingDimonis-unscreen.gif",
                  image:
                      "https://firebasestorage.googleapis.com/v0/b/appdimonis.appspot.com/o/Icons%2Fdemon$index.png?alt=media&token=fd63afe7-b022-4fe4-96ec-5dc6675ad6a3",
                  height: 100,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<bool> imageExists(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
