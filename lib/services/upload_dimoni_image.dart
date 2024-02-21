import 'dart:io';

import 'package:app_dimonis/models/firebase/dimoni.dart';
import 'package:app_dimonis/providers/firebase_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

Future<bool> uploadImage(File image, String nomImage) async {
  Reference ref = storage.ref().child(nomImage);

  final UploadTask uploadTask = ref.putFile(image);

  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);

  if (snapshot.state == TaskState.success) {
    return true;
  } else {
    return false;
  }
}

Future<bool> uploadDimoni(
    BuildContext context, Dimoni dimoniTemp, File image) async {
  try {
    final String nameFile = image.path.split('/').last;

    final uploadedImage = await uploadImage(image, nameFile);

    if (!uploadedImage) {
      return false;
    }

    dimoniTemp.image =
        'https://firebasestorage.googleapis.com/v0/b/appdimonis.appspot.com/o/$nameFile?alt=media&token=3281b52e-0cbd-409f-9b96-f3e054e3ac2e';

    var dimoniProvider =
        Provider.of<FireBaseProvider>(context, listen: false).dimoniProvider;
    dimoniProvider.saveDimoni(dimoniTemp);

    return true;
  } catch (e) {
    return false;
  }
}
