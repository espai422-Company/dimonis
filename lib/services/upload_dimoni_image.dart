import 'dart:io';

import 'package:app_dimonis/models/dimoni.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

Future<bool> uploadDimoni(Dimoni dimoniTemp, File image) async {
  try {
    final String nameFile = image.path.split('/').last;

    final uploadedImage = await uploadImage(image, nameFile);

    if (!uploadedImage) {
      return false;
    }

    dimoniTemp.image =
        'https://firebasestorage.googleapis.com/v0/b/appdimonis.appspot.com/o/$nameFile?alt=media&token=8eff69df-c8ce-4af1-b0d9-7021985158a5';

    dimoniTemp.save();

    return true;
  } catch (e) {
    return false;
  }
}
