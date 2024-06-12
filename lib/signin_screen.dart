import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'color_utils.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'reset_password.dart';
import 'wid_gets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  Future<void> signInUser(BuildContext context) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
      );

      final user = userCredential.user;

      if (user != null) {
        await user.reload();
        if (user.emailVerified) {
          DelightToastBar(
            builder: (context) {
              return const ToastCard(
                leading: Icon(
                  Icons.notifications,
                  size: 32,
                ),
                title: Text(
                  "Login successful",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              );
            },
            position: DelightSnackbarPosition.top,
            autoDismiss: true,
            snackbarDuration: Durations.extralong4,
          ).show(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          await FirebaseAuth.instance.signOut();
          DelightToastBar(
            builder: (context) {
              return const ToastCard(
                leading: Icon(
                  Icons.notifications,
                  size: 32,
                ),
                title: Text(
                  "Please verify your email first",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              );
            },
            position: DelightSnackbarPosition.top,
            autoDismiss: true,
            snackbarDuration: Durations.extralong4,
          ).show(context);
        }
      } else {
        DelightToastBar(
          builder: (context) {
            return const ToastCard(
              leading: Icon(
                Icons.error,
                size: 32,
                color: Colors.red,
              ),
              title: Text(
                "Error signing in",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            );
          },
          position: DelightSnackbarPosition.top,
          autoDismiss: true,
          snackbarDuration: Durations.extralong4,
        ).show(context);
      }
    } on FirebaseAuthException catch (error) {
      DelightToastBar(
        builder: (context) {
          return const ToastCard(
            leading: Icon(
              Icons.error,
              size: 32,
              color: Colors.red,
            ),
            title: Text(
              "Invalid Email or Password",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          );
        },
        position: DelightSnackbarPosition.top,
        autoDismiss: true,
        snackbarDuration: Durations.extralong4,
      ).show(context);
      print("Error ${error.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61F4")
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                reusableTextField(
                  "Enter Email ",
                  Icons.person_outline,
                  false,
                  _emailTextController,
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                  "Enter Password",
                  Icons.lock_outlined,
                  true,
                  _passwordTextController,
                ),
                const SizedBox(
                  height: 20,
                ),
                signInSignUpButton(context, true, () => signInUser(context)),
                signUpOption(),
                forgetPassword(context)
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
        const Text("Don't have an account?", style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPassword())),
      ),
    );
  }
}

