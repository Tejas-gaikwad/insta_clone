import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_app/providers/user_provider.dart';
import 'package:instagram_clone_app/responsive/mobileScreen.dart';
import 'package:instagram_clone_app/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone_app/responsive/webScreen.dart';
import 'package:instagram_clone_app/screens/homescreen.dart';
import 'package:instagram_clone_app/screens/login_screen_ui.dart';
import 'package:instagram_clone_app/screens/returnscreen.dart';
import 'package:instagram_clone_app/screens/sign_up.dart';
import 'package:instagram_clone_app/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCBtNViRv_2WGovjXSvW3rvtHJubHU_NlA",
          appId: "1:845781537810:web:f9788f3030a8985d6b34cb",
          messagingSenderId: "845781537810",
          projectId: "instagramcloneap",
          storageBucket: "instagramcloneap.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor
        ),
        // home: const ResponsiveLayout(
        //     mobileScreenLayout: MobileScreenLayout(),
        //     webScreenLayout: WebScreenLayout())
        // home: LoginScreen(),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.hasData ) {
                // print("homescreen");
                // HomeScreen();
                // print(" i am in homescreen");
               return  ResponsiveLayout(
                        mobileScreenLayout: MobileScreenLayout(),
                        webScreenLayout: WebScreenLayout(),
                );
              } else if(snapshot.hasError) {
                print("error is there");
                return  Center(child: Text("${snapshot.error}"),
                );
              }
            }
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            return const  LoginScreen(

            );
          },
        ),
      ),
    );
  }
}
