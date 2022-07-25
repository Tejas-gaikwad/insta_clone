
import 'package:flutter/material.dart';
import 'package:instagram_clone_app/utils/colors.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/global_variables.dart';


class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {

  int _page = 0 ;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    // getUsername();
    pageController = PageController();
  }

  void dispose() {
    pageController.dispose();
    super.dispose();

  }

  // void getUsername() async {
  //   DocumentSnapshot snap = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //
  //   // print(snap.data());
  //
  //   setState((){
  //     username = (snap.data() as Map<String, dynamic>)['username'];
  //   });
  //
  //
  // }


   void navigationTapped(int page) {
    pageController.jumpToPage(page);
         // pageController.jumpToPage(2?);
 }

 void  onPageChanged(int page) {
    setState((){
      _page = page;
    });
 }

  @override
  Widget build(BuildContext context) {

      // User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: SafeArea(
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          children: homeScreenItems,


          onPageChanged: onPageChanged,
        ),
      ),


      bottomNavigationBar: BottomNavigationBar(
        onTap: navigationTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: mobileBackgroundColor,
        // onTap: navigationTapped(_page),
        items: [
          BottomNavigationBarItem(

              icon: Icon(Icons.home_filled,  color: _page == 0 ? Colors.white : Colors.grey),
              label: '',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search,  color: _page == 1 ? Colors.white : Colors.grey),
              label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined,  color: _page == 2 ? Colors.white : Colors.grey),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_add,  color: _page == 3 ? Colors.white : Colors.grey),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,  color: _page == 4 ? Colors.white : Colors.grey),
            label: '',
          ),
        ],
      ),
    );
  }
}
