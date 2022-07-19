import 'dart:ffi';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_app/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FirestoreMethods {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid, String username, String profImage) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl =
      await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Future<String> uploadPost(
  //     String description,
  //     Uint8List file,
  //     String uid,
  //     String username,
  //     String profImage,
  //
  //     ) async {
  //
  //   String res = "Error occured";
  //
  //   try {
  //     print("It started  posting (((((((((((((((((((((1)))))))))))))))))))))");
  //     String photoUrl = await StorageMethods().uploadImageToStorage("posts", file, true);
  //     print("It started  posting (((((((((((((((((((((2)))))))))))))))))))))");
  //     String postId = const Uuid().v1();
  //     print("It started  posting (((((((((((((((((((((3)))))))))))))))))))))");
  //     Post post = Post(
  //       description : description,
  //       uid: uid,
  //       username: username,
  //       postId: postId,
  //       datePublished: DateTime.now(),
  //       postUrl: photoUrl,
  //       profImage: profImage,
  //       likes: [],
  //     );
  //     print("It started  posting (((((((((((((((((((((4)))))))))))))))))))))");
  //     _firestore.collection('posts').doc(postId).set(post.toJson());
  //     print("It started  posting (((((((((((((((((((((5)))))))))))))))))))))");
  //     res = "success";
  //     print("It started  posting (((((((((((((((((((((6)))))))))))))))))))))");
  //   } catch(err) {
  //     res = err.toString();
  //   }
  //
  //   return res;
  // }
}