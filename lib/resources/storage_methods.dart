


import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';


class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;

  // adding image to firebase storage
  Future<String> uploadImageToStorage(String childName, Uint8List file, bool isPost) async {
    // creating location to our firebase storage

    Reference ref =
    _storage.ref().child(childName).child(_auth.currentUser!.uid);
    if(isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putData(
        file
    );

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // /// adding image to firebase storage
  // Future<String> uploadImageToStorage(String childName, Uint8List file, bool isPost) async {
  //   print("It started  posting ||||||||||||||||||||||  1  ///////////////////////////////");
  //   Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);
  //   print("It started  posting ||||||||||||||||||||||  2  ///////////////////////////////");
  //   UploadTask uploadTask = ref.putData(file);
  //   print("It started  posting ||||||||||||||||||||||  3  ///////////////////////////////");
  //   TaskSnapshot snap = await uploadTask;
  //   print("It started  posting ||||||||||||||||||||||  4  ///////////////////////////////");
  //   String downloadURL = await snap.ref.getDownloadURL();
  //   print("It started  posting ||||||||||||||||||||||  5  ///////////////////////////////");
  //   return downloadURL;
  //   // print("It started  posting ||||||||||||||||||||||  1  ///////////////////////////////");
  // }


}