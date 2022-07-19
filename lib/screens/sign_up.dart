import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_app/resources/auth_methods.dart';
import 'package:instagram_clone_app/responsive/mobileScreen.dart';
import 'package:instagram_clone_app/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone_app/responsive/webScreen.dart';


import '../utils/utils.dart';
import '../widgets/text_field_input.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
   Uint8List? _image;
   bool _isLoading = false;

  @override
  void dispose(){
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async{
    Uint8List img = await pickImage(ImageSource.gallery);
    setState((){
      _image = img;
    });
  }

  void signUpUser() async {
    setState((){
      _isLoading = true;
    });
        String res = await AuthMethods().signUpUsers(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!,
    );

    setState((){
      _isLoading = true;
    });

  if(res != 'success'){
    showSnackBar(res, context);
  }else{
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      return ResponsiveLayout(mobileScreenLayout: MobileScreenLayout(), webScreenLayout: WebScreenLayout());
    }));
  }

  print(res.toString());

}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: true,
        body: SafeArea(
            child: Container(
              alignment: Alignment.center,
              constraints: BoxConstraints.expand(),
              // color: Colors.red,
              // height: MediaQuery.of(context).size.height / 2,
              padding: EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(child: Container(), flex: 2),
                    SvgPicture.asset(
                      "assets/ic_instagram.svg",
                      color: Colors.white ,
                      height: 65,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height* 0.06,),
                    Stack(
                      children: [
                       _image != null ?
                           CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            )
                           : CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage("https://thumbs.dreamstime.com/b/creative-illustration-default-avatar-profile-placeholder-isolated-background-art-design-grey-photo-blank-template-mockup-144847501.jpg"),
                        ),
                        Positioned(
                            right: 0,
                            bottom: 0,
                            child: IconButton(
                              onPressed: selectImage,
                              icon: Icon(Icons.add_a_photo, color: Colors.white),
                        ))
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height* 0.02,),
                    TextFieldInput(
                      textEditingController: _usernameController,
                      textInputType: TextInputType.text,
                      hintText: 'Enter Username',
                      isPass: false,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height* 0.02,),
                    TextFieldInput(
                      textEditingController: _bioController,
                      textInputType: TextInputType.text,
                      hintText: 'Enter Bio',
                      isPass: false,
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
                      onTap: signUpUser,
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
                        child: _isLoading ? const Center(child: CircularProgressIndicator(
                          color: Colors.white,
                        ),) : Text("Sign-Up"),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height* 0.02,),
                    Flexible(child: Container(), flex: 1),

                  ],
                ),
              ),
            )
        )
    );
  }
}
