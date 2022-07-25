import 'dart:ffi';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_app/resources/storage_methods.dart';
import 'package:instagram_clone_app/utils/utils.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FirestoreMethods {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid, String username, String profImage) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl = await StorageMethods().uploadImageToStorage('posts', file, true);
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

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if(likes.contains(uid)) {
        _firestore.collection('posts').doc(postId).update({
          'likes' : FieldValue.arrayRemove([uid])
        });

      } else {
        _firestore.collection('posts').doc(postId).update({
          'likes' : FieldValue.arrayUnion([uid])
        });
      }
    } catch(e) {
      print(e.toString());
    }
  }
  Future<void> likePostOfBigFavorite(String postId, String uid, List likes) async {
    try {
      if(likes.contains(uid)) {
        // _firestore.collection('posts').doc(postId).update({
        //   'likes' : FieldValue.arrayUnion([uid])
        // });

      } else {
        _firestore.collection('posts').doc(postId).update({
          'likes' : FieldValue.arrayUnion([uid])
        });
      }
    } catch(e) {
      print(e.toString());
    }
  }

  Future<void> likeComment(String postId, String uid, commentLikes, String commentId, ) async {

    // final snapshot = await FirebaseFirestore.instance
    //     .collection('posts')
    //     .doc(postId)
    //     .collection('comments')
    //     .orderBy(
    //       'datePublished',
    //       descending: true, )
    //     .;
    //
    // print(snapshot.docs.length.toString() + "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");

    // final snapshot = await FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').doc(commentLikes).collection("commentLikes").get();
    try {
      if(commentLikes.contains(uid)) {

        _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).update({
          'commentLikes' : FieldValue.arrayRemove([uid]),

        });
        // _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
        //     'commentLikes' : FieldValue.arrayRemove([uid]),
        //     'commentLikes' : [],
        // });
      }
      else {
        _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).update({
          'commentLikes' : FieldValue.arrayUnion([uid]),
          // 'commentLikes' : uid,
        });

        // _firestore.collection('posts').doc(postId).collection('comments').doc(commentLikes).update({
        //       'commentLikes' : FieldValue.arrayUnion([uid])
        //      // 'commentLikes' : uid,
        // });
      }
    }
    catch (e) {
    }

  }

  Future<void> postComment (String postId, String uid, String text, String name, String profile) async {

    try {
      if(text.isNotEmpty) {
        String commentId = Uuid().v1();
        await _firestore.collection('posts').doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
                'profilePic': profile,
                'name': name,
                'uid': uid,
                'text': text,
                'commentId': commentId,
                'datePublished': DateTime.now(),

        });
      }
    } catch(e) {
      print(e.toString());
    }



  }

  Future<void> deletePost (String postId) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(
      String uid,
      String followId) async {
        try{
          DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
          List following = (snap.data()! as dynamic)['following'];
          

          if(following.contains(followId)){
            await _firestore.collection('users').doc(followId).update({
              'followers' : FieldValue.arrayRemove([uid])
            });

            await _firestore.collection('users').doc(uid).update({
              'following' : FieldValue.arrayRemove([followId])
            });
          } else {
            await _firestore.collection('users').doc(followId).update({
              'followers' : FieldValue.arrayUnion([uid])
            });

            await _firestore.collection('users').doc(uid).update({
              'following' : FieldValue.arrayUnion([followId])
            });
          }
          


        } catch(e) {
          print(e.toString());
    }
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