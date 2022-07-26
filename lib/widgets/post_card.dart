import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_app/providers/user_provider.dart';
import 'package:instagram_clone_app/screens/comment_screen.dart';
import 'package:instagram_clone_app/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../resources/firestore_methods.dart';
import '../utils/colors.dart';
import 'like_animation.dart';

class PostCard extends StatefulWidget {
    final snap;
    PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isFavorite = false;
  bool isLikeAnimating = false;
  int commentLength = 0;



  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {

    try {
      QuerySnapshot snap = await FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').get();
      commentLength = snap.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState((){

    });

  }

  @override
  Widget build(BuildContext context) {

    final User user = Provider.of<UserProvider>(context).getUser;

    // print(widget.snap.toString());

    return Container(
      color: mobileBackgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 6,vertical: 10),
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left : 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.snap['username'], style: TextStyle(fontWeight: FontWeight.bold, ),),
                    ],
                  ),
                ),

               ),
                IconButton(onPressed: (){
                  showDialog(context: context, builder: (context) => Dialog(
                    child: ListView(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shrinkWrap: true,
                      children: [
                        "Delete",
                      ].map((e) => InkWell(
                        onTap: () async {
                          FirestoreMethods().deletePost(widget.snap['postId']);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                           child: Text(e),
                        ),)).toList(),
                    ),
                  ));
                }, icon: Icon(Icons.more_vert, size: 20,)),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePostOfBigFavorite(
                widget.snap['postId'],
                user.uid,
                widget.snap['likes'],
              );
              setState((){
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: Image.network(widget.snap['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
            AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
                    ),
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),)
                // AnimatedOpacity(
                //   duration: Duration(milliseconds: 200),
                //   opacity: isLikeAnimating ? 1 : 0,
                //   child: LikeAnimation(
                //     child: const Icon(Icons.favorite, color: Colors.red, size: 100),
                //     isAnimating: isLikeAnimating,
                //     duration: const Duration(milliseconds: 600),
                //     onEnd: () {
                //       setState((){
                //         isLikeAnimating = false;
                //       });
                //     }),
                // )
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                  smallLike: true,
                  isAnimating: widget.snap['likes'].contains(user.uid),
                      child: IconButton(
                        onPressed: () async {
                          await FirestoreMethods().likePost(
                              widget.snap['postId'].toString(),
                              user.uid,
                              widget.snap['likes'],
                          );
                        },
                        icon: widget.snap['likes'].contains(user.uid)
                            ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                            : const Icon(
                          Icons.favorite_border,
                        ),
                      )),
              IconButton(
                  onPressed: (){

                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return  CommentScreen(
                        snap: widget.snap,
                      );
                }));
              }, icon: Icon(Icons.comment_outlined)),
              IconButton(onPressed: (){}, icon: Icon(Icons.send)),
              Expanded(child: Align( alignment: Alignment.centerRight, child: IconButton(onPressed: (){} , icon: Icon(Icons.bookmark_border),))),
            ],
          ),

          /// Description and Commments
          Container(
            padding: EdgeInsets.symmetric(horizontal: 1, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                DefaultTextStyle(
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(fontWeight: FontWeight.w800),
                    child : Text(widget.snap['likes'] == null ? "0 like" : "${widget.snap['likes'].length.toString() +" likes"}", style: Theme.of(context).textTheme.bodyText2,)),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 8),
                  child: RichText(
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(

                      style: const TextStyle(fontWeight: FontWeight.bold),
                      children: [

                        TextSpan(
                          text: widget.snap['username'],
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)
                        ),

                        TextSpan(
                            text: "  ${ widget.snap["description"]}",
                            style: TextStyle(color: Colors.white , fontSize: 12)
                        ),
                      ]
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    ///Head me towards comment screen
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return  CommentScreen(
                                            snap: widget.snap,
                                          );
                                    }));

                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Text("View All ${commentLength} comments", style: TextStyle(fontSize: 12, color: secondaryColor),),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 6),
                  child: Text( DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()).toString(), style: TextStyle(fontSize: 12, color: secondaryColor),),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}




//
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// // import 'package:instagram_clone_flutter/providers/user_provider.dart';
// // import 'package:instagram_clone_flutter/resources/firestore_methods.dart';
// // import 'package:instagram_clone_flutter/screens/comments_screen.dart';
// // import 'package:instagram_clone_flutter/utils/colors.dart';
// // import 'package:instagram_clone_flutter/utils/global_variable.dart';
// // import 'package:instagram_clone_flutter/utils/utils.dart';
// // import 'package:instagram_clone_flutter/widgets/like_animation.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// import '../models/user.dart';
// import '../providers/user_provider.dart';
// import '../utils/colors.dart';
// import '../utils/dimensions.dart';
// import '../utils/utils.dart';
// import 'like_animation.dart';
//
// class PostCard extends StatefulWidget {
//   final snap;
//   const PostCard({
//     Key? key,
//     required this.snap,
//   }) : super(key: key);
//
//   @override
//   State<PostCard> createState() => _PostCardState();
// }
//
// class _PostCardState extends State<PostCard> {
//   int commentLen = 0;
//   bool isLikeAnimating = false;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchCommentLen();
//   }
//
//   fetchCommentLen() async {
//     try {
//       QuerySnapshot snap = await FirebaseFirestore.instance
//           .collection('posts')
//           .doc(widget.snap['postId'])
//           .collection('comments')
//           .get();
//       commentLen = snap.docs.length;
//     } catch (err) {
//       // showSnackBar(
//       //   // context,
//       //   // err.toString(),
//       // );
//     }
//     setState(() {});
//   }
//
//   deletePost(String postId) async {
//     try {
//       // await FireStoreMethods().deletePost(postId);
//     } catch (err) {
//       // showSnackBar(
//       //   context,
//       //   err.toString(),
//       // );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final User user = Provider.of<UserProvider>(context).getUser;
//     // final model.User user = Provider.of<UserProvider>(context).getUser;
//     final width = MediaQuery.of(context).size.width;
//
//     return Container(
//       // boundary needed for web
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: width > webScreenSize ? secondaryColor : mobileBackgroundColor,
//         ),
//         color: mobileBackgroundColor,
//       ),
//       padding: const EdgeInsets.symmetric(
//         vertical: 10,
//       ),
//       child: Column(
//         children: [
//           // HEADER SECTION OF THE POST
//           Container(
//             padding: const EdgeInsets.symmetric(
//               vertical: 4,
//               horizontal: 16,
//             ).copyWith(right: 0),
//             child: Row(
//               children: <Widget>[
//                 CircleAvatar(
//                   radius: 16,
//                   backgroundImage: NetworkImage(
//                     widget.snap['profImage'].toString(),
//                   ),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                       left: 8,
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           widget.snap['username'].toString(),
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 widget.snap['uid'].toString() == user.uid
//                     ? IconButton(
//                   onPressed: () {
//                     showDialog(
//                       useRootNavigator: false,
//                       context: context,
//                       builder: (context) {
//                         return Dialog(
//                           child: ListView(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 16),
//                               shrinkWrap: true,
//                               children: [
//                                 'Delete',
//                               ]
//                                   .map(
//                                     (e) => InkWell(
//                                     child: Container(
//                                       padding:
//                                       const EdgeInsets.symmetric(
//                                           vertical: 12,
//                                           horizontal: 16),
//                                       child: Text(e),
//                                     ),
//                                     onTap: () {
//                                       deletePost(
//                                         widget.snap['postId']
//                                             .toString(),
//                                       );
//                                       // remove the dialog box
//                                       Navigator.of(context).pop();
//                                     }),
//                               )
//                                   .toList()),
//                         );
//                       },
//                     );
//                   },
//                   icon: const Icon(Icons.more_vert),
//                 )
//                     : Container(),
//               ],
//             ),
//           ),
//           // IMAGE SECTION OF THE POST
//           GestureDetector(
//             onDoubleTap: () {
//               // FireStoreMethods().likePost(
//               //   widget.snap['postId'].toString(),
//               //   user.uid,
//               //   widget.snap['likes'],
//               // );
//               setState(() {
//                 isLikeAnimating = true;
//               });
//             },
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.35,
//                   width: double.infinity,
//                   child: Image.network(
//                     widget.snap['postUrl'].toString(),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 AnimatedOpacity(
//                   duration: const Duration(milliseconds: 200),
//                   opacity: isLikeAnimating ? 1 : 0,
//                   child: LikeAnimation(
//                     isAnimating: isLikeAnimating,
//                     child: const Icon(
//                       Icons.favorite,
//                       color: Colors.white,
//                       size: 100,
//                     ),
//                     duration: const Duration(
//                       milliseconds: 400,
//                     ),
//                     onEnd: () {
//                       setState(() {
//                         isLikeAnimating = false;
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // LIKE, COMMENT SECTION OF THE POST
//           Row(
//             children: <Widget>[
//               LikeAnimation(
//                 isAnimating: widget.snap['likes'].contains(user.uid),
//                 smallLike: true,
//                 child: IconButton(
//                     icon: widget.snap['likes'].contains(user.uid)
//                         ? const Icon(
//                       Icons.favorite,
//                       color: Colors.red,
//                     )
//                         : const Icon(
//                       Icons.favorite_border,
//                     ),
//                     onPressed: () {}
//                   // => FireStoreMethods().likePost(
//                   //   widget.snap['postId'].toString(),
//                   //   user.uid,
//                   //   widget.snap['likes'],
//                   // ),
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(
//                   Icons.comment_outlined,
//                 ),
//                 onPressed: (){},
//                 // onPressed: () => Navigator.of(context).push(
//                 //   MaterialPageRoute(
//                 //     builder: (context) => CommentsScreen(
//                 //       postId: widget.snap['postId'].toString(),
//                 //     ),
//                 //   ),
//                 // ),
//               ),
//               IconButton(
//                   icon: const Icon(
//                     Icons.send,
//                   ),
//                   onPressed: () {}),
//               Expanded(
//                   child: Align(
//                     alignment: Alignment.bottomRight,
//                     child: IconButton(
//                         icon: const Icon(Icons.bookmark_border), onPressed: () {}),
//                   ))
//             ],
//           ),
//           //DESCRIPTION AND NUMBER OF COMMENTS
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 DefaultTextStyle(
//                     style: Theme.of(context)
//                         .textTheme
//                         .subtitle2!
//                         .copyWith(fontWeight: FontWeight.w800),
//                     child: Text(
//                       '${widget.snap['likes'].length} likes',
//                       style: Theme.of(context).textTheme.bodyText2,
//                     )),
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.only(
//                     top: 8,
//                   ),
//                   child: RichText(
//                     text: TextSpan(
//                       style: const TextStyle(color: primaryColor),
//                       children: [
//                         TextSpan(
//                           text: widget.snap['username'].toString(),
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         TextSpan(
//                           text: ' ${widget.snap['description']}',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 InkWell(
//                   child: Container(
//                     child: Text(
//                       'View all $commentLen comments',
//                       style: const TextStyle(
//                         fontSize: 16,
//                         color: secondaryColor,
//                       ),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 4),
//                   ),
//                   onTap: () =>
//                   //     Navigator.of(context).push(
//                   //   // MaterialPageRoute(
//                   //   //   // builder: (context) => CommentsScreen(
//                   //   //   //   postId: widget.snap['postId'].toString(),
//                   //   //   // ),
//                   //   // ),
//                   // ),
//                   // ),
//                   Container(
//                     child: Text(
//                       DateFormat.yMMMd()
//                           .format(widget.snap['datePublished'].toDate()),
//                       style: const TextStyle(
//                         color: secondaryColor,
//                       ),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 4),
//                   ),)
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
