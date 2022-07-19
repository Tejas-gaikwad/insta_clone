import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone_app/resources/auth_methods.dart';
import 'package:instagram_clone_app/screens/sign_up.dart';
import 'package:instagram_clone_app/utils/utils.dart';

import '../responsive/mobileScreen.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/webScreen.dart';
import '../widgets/text_field_input.dart';
import 'homescreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose(){
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState((){
      _isLoading = true;
    });
    String res = await  AuthMethods().loginUser(email: _emailController.text, password: _passwordController.text);
    if(res == 'success'){
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      //   return HomeScreen();
      // }));
        // print("successfully login");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return ResponsiveLayout(mobileScreenLayout: MobileScreenLayout(), webScreenLayout: WebScreenLayout());
      }));
    }else {
      showSnackBar(res, context);
    }
    setState((){
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
              alignment: Alignment.center ,
                constraints: BoxConstraints.expand(),
                padding: EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(child: Container(),flex: 2),
                      ///svg image
                      SvgPicture.asset(
                          "assets/ic_instagram.svg",
                          color: Colors.white ,
                          height: 65,
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height* 0.02,),
                      TextFieldInput(
                        textEditingController: _emailController,
                        textInputType: TextInputType.emailAddress,
                        hintText: 'Enter Email',
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height* 0.02,),
                      TextFieldInput(
                        textEditingController: _passwordController,
                        textInputType: TextInputType.text,
                        hintText: 'Enter Password',
                        isPass: true,
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height* 0.02,),
                      InkWell(
                        onTap: loginUser,
                        child: Container(
                          decoration: const ShapeDecoration(
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4))
                              )
                          ),
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: _isLoading == true ? Center(
                            child: CircularProgressIndicator(

                              color: Colors.white,
                              strokeWidth: 3.0
                            ),
                          ) : Text("Log-In"),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height* 0.02,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text("Don't have an account?", style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return SignUp();
                              }));
                            },
                            child: Container(

                              child: Text("Sign Up", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ],
                      ),
                      Flexible(child: Container(), flex: 2),
                    ],
                  ),
                ),
        )
        )
   );
  }
}
