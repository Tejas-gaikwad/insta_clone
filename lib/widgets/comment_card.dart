import 'package:flutter/material.dart';
import 'package:instagram_clone_app/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';

class CommentCard extends StatefulWidget {
  final postId;
  final snap;
   CommentCard({Key? key, required this.snap, this.postId}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {

    final User user = Provider.of<UserProvider>(context).getUser;

    // print(widget.snap.toString() + "+++++++++++++++++++++++++++++++++++++++++++++++++++");

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                widget.snap['profilePic']
            ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      maxLines: 3,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${widget.snap['name'] }",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )
                          ),
                          TextSpan(
                              text: "  ${widget.snap['text']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )
                          ),
                        ]
                      )
                  ),
                  Padding(padding: EdgeInsets.only(top: 4),
                    child: Text(DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()), style: TextStyle(fontSize: 12 , color: Colors.grey, fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
          InkWell(
            onTap: () async {
              await FirestoreMethods().likeComment(
                  widget.postId.toString(),
                  user.uid,
                  widget.snap['commentLikes'].toString(),
                  widget.snap['commentId'].toString(),
              );
            },
            child: widget.snap['commentLikes']?.contains(user.uid) == true
                ?Icon(Icons.favorite, color: Colors.red, size: 16) :
            Icon(Icons.favorite_border, size: 16)

          )
        ],
      ),
    );
  }
}
