import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_app/providers/user_provider.dart';
import 'package:instagram_clone_app/resources/firestore_methods.dart';
import 'package:instagram_clone_app/resources/storage_methods.dart';

import 'package:provider/provider.dart';

import '../models/user.dart';
import '../utils/utils.dart';



class Add_Post extends StatefulWidget {
  const Add_Post({Key? key}) : super(key: key);

  @override
  State<Add_Post> createState() => _Add_PostState();
}

class _Add_PostState extends State<Add_Post> {

   final TextEditingController _descriptionController = TextEditingController();

  Uint8List? _file;

  _selectImage(BuildContext context) async {
    return showDialog( context : context, builder: (context) {
        return SimpleDialog(
          title: Text("Create a Post"),
          children: [
            SimpleDialogOption(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Text("Take a Photo"),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await   pickImage(ImageSource.camera);

                setState((){
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Text("Choose from gallery"),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState((){
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Cancel"),
                ],
              ),
              onPressed: () => {
                Navigator.of(context).pop(),
              },
            ),
          ],
        );
      }
    );
  }

  void _postImage(
      String uid,
      String username,
      String profileImage,
      ) async {
            try {
              print("Started");
              String res = await FirestoreMethods().uploadPost(
                  _descriptionController.text,
                  _file!,
                  uid,
                  username,
                  profileImage,
              );
              print("finish ");

              if(res == 'success') {
                showSnackBar("Posted!", context);
              }else {
                showSnackBar(res.toString(), context);
              }
            } catch(e) {
              showSnackBar(e.toString(), context);
            }
        }

  // _postImagToFirebase() async {
  //   print(" It is starting }{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{");
  //
  //   final file = _file;
  //
  //   print("got the file ");
  //   String  photoUrl = await StorageMethods().uploadImageToStorage(
  //     "Posts",
  //     file!,
  //     true,
  //   );
  //   print("put the file ");
  //
  //   print(photoUrl.toString() + "}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{");
  //
  // }

  @override
  Widget build(BuildContext context) {

    final User user = Provider.of<UserProvider>(context).getUser;

    return _file == null ? Center(
      child: IconButton(
        icon: Icon(Icons.add_box_outlined),
        onPressed: () {
          return _selectImage(context);
        },
      ),
    ) :
     Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){},
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          TextButton(
              onPressed: (){
                _postImage(
                  user.uid,
                  user.username,
                  user.photoUrl,
                );
              },
              child: Text("POST", style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, color: Colors.blueAccent),))
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text("Add post"),
      ),
      body: Column(
        children: [
          SizedBox(height: 24,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child:  TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: "Write a caption...",
                    border: InputBorder.none,
                  ),
                  maxLines: 8,

                ),
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: AspectRatio(
                  aspectRatio: 487/451,
                  child: Container(
                    decoration:  BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                        image: MemoryImage(_file!),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
