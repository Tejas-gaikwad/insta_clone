import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_app/resources/firestore_methods.dart';
import 'package:instagram_clone_app/utils/colors.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/utils.dart';
import '../widgets/comment_card.dart';

class CommentScreen extends StatefulWidget {
  final snap;
   CommentScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {

  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }



  @override
  Widget build(BuildContext context)  {

    final User user = Provider.of<UserProvider>(context).getUser;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Comment"),
        centerTitle: false,

      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy(
              'datePublished',
              descending: true, )
            .snapshots(),
        builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(  
                itemCount: (snapshot.data! as dynamic).docs.length,
                itemBuilder: (context, index) {
              return CommentCard(
                postId: widget.snap['postId'],
                snap : (snapshot.data! as dynamic).docs[index].data(),
              );
            });
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: EdgeInsets.only(left: 16,  right: 8),
          child: Row(
            children:  [
              CircleAvatar(
                radius: 18,
                backgroundImage : NetworkImage(user.photoUrl),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 8),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "Comment here...",
                      hintStyle: TextStyle(fontSize : 14,),
                      border: InputBorder.none
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FirestoreMethods().postComment(
                    widget.snap['postId'],
                    user.uid,
                    _commentController.text,
                    user.username,
                    user.photoUrl,
                    // widget.postId,
                    //
                    // uid,
                    // name,
                    // profilePic,
                    //
                    // user.photoUrl,
                    // user.username,
                    // user.uid,
                  );
                  setState((){
                    _commentController.text = "";
                  });

                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text("POST", style:  TextStyle(fontSize : 16, color: blueColor)),
                ),
              )
            ],
          ),
        ),

      ),
    );

  }
}
