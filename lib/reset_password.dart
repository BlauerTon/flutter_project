import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'color_utils.dart';
import 'wid_gets.dart';



class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Reset Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                hexStringToColor("CB2B93"),
                hexStringToColor("9546C4"),
                hexStringToColor("5E61F4")
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter Email ", Icons.person_outline, false,
                        _emailTextController),
                    const SizedBox(
                      height: 20,
                    ),
                firebaseUIButton(context, "Reset Password", () {
                  FirebaseAuth.instance
                      .sendPasswordResetEmail(email: _emailTextController.text)
                      .then((value) {
                    DelightToastBar(
                      builder: (context) {
                        return const ToastCard(
                          leading: Icon(
                            Icons.notifications,
                            size: 32,
                          ),
                          title: Text(
                            "Password reset email sent!", // Adjust message accordingly
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
                  })
                      .catchError((error) {
                    DelightToastBar(
                      builder: (context) {
                        return const ToastCard(
                          leading: Icon(
                            Icons.notifications,
                            size: 32,
                          ),
                          title: Text(
                            "Invalid Email ",
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
                    ).show(
                      context,
                    );
                    print("Error sending password reset email: $error");
                  });
                })

                ],
                ),
              ))),
    );
  }
}