import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone_app/screens/login_screen_ui.dart';
import 'package:instagram_clone_app/screens/profile_screen.dart';

import '../widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  
  FirebaseFirestore _firestore = FirebaseFirestore.instance;



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: SvgPicture.asset("assets/ic_instagram.svg", color: Colors.white, width: 100),
        actions: [
          IconButton(onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return LoginScreen();
          }));}, icon: Icon(Icons.logout)),
          IconButton(onPressed: (){}, icon: Icon(Icons.message)),
        ],
      ),
      body: StreamBuilder(

        stream: _firestore.collection('posts').snapshots(),

        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {

         if(snapshot.connectionState == ConnectionState.waiting) {
           return const Center(
             child: CircularProgressIndicator(),
           );

         }

          return ListView.builder(

              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) =>
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return ProfileScreen(uid: (snapshot.data! as dynamic).docs[index]['uid']);
                      }));
                    },
                    child: PostCard(
                      snap : snapshot.data!.docs[index].data(),
                    ),
                  ),
                 // Container(
                 //        child: Text(snapshot.data!.docs[0].data().toString()),
                 //      )
          );
        },
      )
    );
  }
}
