import 'package:flutter/material.dart';

import 'package:instagram_clone_app/screens/login_screen_ui.dart';
import 'package:provider/provider.dart';


import '../models/user.dart';
import '../providers/user_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


     final User user = Provider.of<UserProvider>(context).getUser;

    print("I am uin home screen");
     return  Scaffold(
      body: Center(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(user.username),
            IconButton(onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                return LoginScreen();
              }));
            }, icon: Icon(Icons.logout)),
          ],
        ),
      ),
    );
  }
}
