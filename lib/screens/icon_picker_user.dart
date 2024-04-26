import 'dart:io';

import 'package:app_dimonis/providers/firebase_provider.dart';
import 'package:app_dimonis/services/select_image.dart';
import 'package:app_dimonis/services/upload_dimoni_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

File? image;

class ImagePickerScreen extends StatelessWidget {
  const ImagePickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Canvi d'icona"),
          backgroundColor: Colors.black,
        ),
        body: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          children: [
            GestureDetector(
              onTap: () async {
                final imagen = await getImageGallery();

                if (imagen != null) {
                  image = File(imagen.path);
                  Navigator.of(context).pop(uploadImageUser(context, image!));
                }
              },
              child: FadeInImage.assetNetwork(
                placeholder: "assets/LoadingDimonis-unscreen.gif",
                image:
                    "https://firebasestorage.googleapis.com/v0/b/appdimonis.appspot.com/o/Icons%2Fupload.png?alt=media&token=fd63afe7-b022-4fe4-96ec-5dc6675ad6a3",
                height: 100,
              ),
            ),
            for (var i = 0; i < 6; i++)
              GestureDetector(
                onTap: () {
                  FireBaseProvider firebase =
                      Provider.of<FireBaseProvider>(context, listen: false);
                  // firebase.usersProvider.setPhotoURL(
                  //     "https://firebasestorage.googleapis.com/v0/b/appdimonis.appspot.com/o/Icons%2Fdemon$i.png?alt=media&token=fd63afe7-b022-4fe4-96ec-5dc6675ad6a3");
                  Navigator.of(context).pop(
                      "https://firebasestorage.googleapis.com/v0/b/appdimonis.appspot.com/o/Icons%2Fdemon$i.png?alt=media&token=fd63afe7-b022-4fe4-96ec-5dc6675ad6a3");
                },
                child: FadeInImage.assetNetwork(
                  placeholder: "assets/LoadingDimonis-unscreen.gif",
                  image:
                      "https://firebasestorage.googleapis.com/v0/b/appdimonis.appspot.com/o/Icons%2Fdemon$i.png?alt=media&token=fd63afe7-b022-4fe4-96ec-5dc6675ad6a3",
                  height: 100,
                ),
              ),
          ],
        ));
  }
}
