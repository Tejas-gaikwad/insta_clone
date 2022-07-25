import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_app/resources/auth_methods.dart';
import 'package:instagram_clone_app/resources/firestore_methods.dart';
import 'package:instagram_clone_app/screens/login_screen_ui.dart';
import 'package:instagram_clone_app/utils/colors.dart';
import 'package:instagram_clone_app/utils/utils.dart';

import '../widgets/follow_buton.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
   ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followersLen = 0;
  int followingLen = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    setState((){
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
      var postSnap = await FirebaseFirestore.instance.collection("posts").where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();

      followersLen = userSnap['followers'].length;
      followingLen = userSnap['following'].length;

      isFollowing = userSnap.data()!['followers'].contains(FirebaseAuth.instance.currentUser!.uid);
      
      postLen = postSnap.docs.length; 
      userData = userSnap.data()!;
      setState((){

      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState((){
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return isLoading ? const Center(child: CircularProgressIndicator()) : Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(userData['username'].toString()),
        centerTitle: false,

      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 10, bottom: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(userData['photoUrl'].toString()),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildSateColumn(postLen, "Posts"),  
                              buildSateColumn(followersLen, "Followers"),
                              buildSateColumn(followingLen, "Following")
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FirebaseAuth.instance.currentUser!.uid == widget.uid ?  FollowButton(
                                function: () async {
                                  await AuthMethods().signOut();
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                                    return LoginScreen();
                                  }));
                                },
                                textColor: primaryColor,
                                text: 'Signout',
                                borderColor: Colors.grey,
                                backgroundColor: mobileBackgroundColor,
                              ) : isFollowing == true  ? FollowButton(
                                function: () async {
                                  await FirestoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, userData['uid']);
                                  setState((){
                                    isFollowing = false;
                                    followersLen--;
                                  });
                                },
                                textColor: Colors.black,
                                text: 'Unfollow',
                                borderColor: Colors.grey,
                                backgroundColor: Colors.white,
                              ) : FollowButton( 
                              function: () async {
                                await FirestoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, userData['uid']);
                                setState((){
                                  isFollowing = true;
                                  followersLen++;

                                });
                              },
                                   textColor: Colors.white,
                                    text: 'Follow',
                                    borderColor: Colors.grey,
                                    backgroundColor: Colors.blue,
                                  )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 15),
                  child: Text(userData['username'].toString(), style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 2),
                  child: Text(userData['bio']!.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              ],
            ),
          ),
          Divider(),

          Container(
            child: FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: widget.uid).get(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator(),);
                } else {
                  return GridView.builder(
                    shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                      DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];

                      return Container(
                        // color: Colors.white,
                        child: Image( 
                          image: NetworkImage(
                              snap['postUrl'].toString()
                          ),
                          fit: BoxFit.cover,
                        ),
                      );
                      }
                  );
                }
              },
            )
          )
        ],
      )
    );
  }
  Column buildSateColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(num.toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),),
        Container(
            margin: EdgeInsets.only(top: 10,),
            child: Text(label.toString(), style: TextStyle(color: Colors.grey, fontSize: 14),)),
      ],
    );

  }
}
