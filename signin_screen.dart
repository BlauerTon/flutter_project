import 'package:flutter/material.dart';

import 'color_utils.dart';
import 'signup_screen.dart';
import 'wid_gets.dart';

class SignInScreen extends StatefulWidget {

 const SignInScreen({Key? key}) :  super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors:[
      hexStringToColor("CB2B93"),
      hexStringToColor("9546C4"),
      hexStringToColor("5E61F4")],
    begin: Alignment.topCenter, end: Alignment.bottomCenter)),
    child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.2, 20, 0),
        child: Column(
          children: <Widget>[
            logoWidget("images/home1.jpeg"),
            SizedBox(
              height: 30,
            ),
            reusableTextField("Enter UserName", Icons.person_outline, false, _emailTextController),
            SizedBox(
              height: 20,
            ),
            reusableTextField("Enter Password", Icons.person_outline, false, _passwordTextController),
            SizedBox(
              height: 20,
            ),
            signInSignUpButton(context, true, () {}),
            signUpOption()
          ],
        ),
      ),
    ),
    ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  /*
  Image logoWidget(String imageName){
    return Image.asset(
      imageName,
      fit: BoxFit.fitWidth,
      width: 240,
      height: 240,
      color: Colors.white,
    );
  }

   */
}

