import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_app/resources/storage_methods.dart';
import 'package:instagram_clone_app/models/user.dart' as model;

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }


  Future<String> signUpUsers({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occures";
    try{
      if(email.isNotEmpty || password.isNotEmpty ||   username.isNotEmpty || bio.isNotEmpty
      || file != null
      ){
        ///register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        print("${cred.user!.uid}  UID of user ");

        String photoUrl = await StorageMethods().uploadImageToStorage("profilePics", file, false);

        model.User user = model.User(
          bio: bio,
          email: email,
          followers: [],
          following: [],
          photoUrl: photoUrl,
          uid: cred.user!.uid,
          username: username,
        );


        ///add user to firebase
        await _firestore.collection("users").doc(cred.user!.uid).set(user.toJson());
        res = "success";
      }
    }catch(err){
      res  = err.toString();
    }
    return res;
  }



  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";

    try{
      if(email.isNotEmpty || password.isNotEmpty)  {

        await _auth.signInWithEmailAndPassword(email: email, password: password);

        res = "success";
      }
    }catch (err) {
      res = err.toString();
    }

    return res;
  }

}
