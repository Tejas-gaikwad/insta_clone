import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone_app/screens/profile_screen.dart';
import 'package:instagram_clone_app/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchTextController = TextEditingController();
  bool isShowUser = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        
        title: Container(
          // margin: EdgeInsets.symmetric(horizontal: 1, vertical: 6),
          decoration: BoxDecoration(
              color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(25.0)
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          child: Row( 
            children: [
              Expanded(
                child: TextFormField(
                  controller: _searchTextController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search for user",
                  ),
                  onChanged: (String _){

                    setState((){
                      isShowUser = true;
                    });
                  },
                  onFieldSubmitted: (String _){

                    setState((){
                      isShowUser = true;
                    });
                  },
                ),
              ),
              IconButton(
                  onPressed: (){
                    setState((){
                      _searchTextController.clear();
                      isShowUser = false;
                    });
                  },
                  icon: Icon(Icons.cancel,color: Colors.grey.shade600,)
              )
            ],
          ),
        ),
      ),
      body: isShowUser == true ? FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').where('username', isGreaterThanOrEqualTo: _searchTextController.text).get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if(!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );  
          }
          
          return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length ,
              itemBuilder: (context, index) {
                return ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.transparent)
                ), 
                  onPressed: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return ProfileScreen(uid: (snapshot.data! as dynamic).docs[index]['uid']);
                    }));
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          (snapshot.data! as dynamic).docs[index]['photoUrl']
                      ),
                    ),
                    title: Text((snapshot.data! as dynamic).docs[index]['username']),
                  ),
                );
          });
        }
      ) : Container(),
      // FutureBuilder(
      //     future: FirebaseFirestore.instance.collection('posts').get(),
      //     builder: (context, snapshot) {
      //         if(!snapshot.hasData) {
      //           return const Center(child:  CircularProgressIndicator());
      //         }
      //
      //         return StaggeredGridTile.
      //
      //         //   GridView.builder(
      //         //   itemCount: (snapshot.data! as dynamic).docs.length,
      //         //   itemBuilder: (context, index){
      //         //     return Image.network((snapshot.data!  as dynamic).docs[index]['postUrl']);
      //         //   },
      //         // );
      //
      // })
    );
  }
}
