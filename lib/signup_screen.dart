import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'color_utils.dart';
import 'home_screen.dart';
import 'wid_gets.dart';
import 'signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  bool _isPasswordVisible = false;

  String? _validatePassword(String password) {
    final passwordRegex = RegExp(
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$');
    if (password.isEmpty) {
      return "Password cannot be empty";
    } else if (!passwordRegex.hasMatch(password)) {
      return "Password must be at least 8 characters long, include a letter, a symbol, and a digit";
    }
    return null;
  }

  Widget reusableTextField(String hintText, IconData icon, bool isPasswordType,
      TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: isPasswordType ? !_isPasswordVisible : false,
      enableSuggestions: !isPasswordType,
      autocorrect: !isPasswordType,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white.withOpacity(0.9)),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.white70,
        ),
        suffixIcon: isPasswordType
            ? IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white70,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        )
            : null,
        labelText: hintText,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white.withOpacity(0.3),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
      ),
      keyboardType: isPasswordType
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
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
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter UserName",
                  Icons.person_outline, false, _userNameTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter Email",
                  Icons.person_outline, false, _emailTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter Password",
                  Icons.lock_outlined, true, _passwordTextController,
                ),
                const SizedBox(height: 20),
                signInSignUpButton(
                  context,
                  false,
                      () async {
                    final password = _passwordTextController.text;
                    final passwordError = _validatePassword(password);

                    if (passwordError != null) {
                      DelightToastBar(
                        builder: (context) {
                          return ToastCard(
                            leading: Icon(
                              Icons.error,
                              size: 32,
                              color: Colors.red,
                            ),
                            title: Text(
                              passwordError,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          );
                        },
                        position: DelightSnackbarPosition.top,
                        autoDismiss: false,
                        snackbarDuration: Durations.extralong4,
                      ).show(context);
                      return;
                    }
                    try {
                      final userCredential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: password,
                      );
                      final user = userCredential.user;
                      if (user != null) {
                        await user.updateDisplayName(_userNameTextController.text);
                        await user.sendEmailVerification();
                        DelightToastBar(
                          builder: (context) {
                            return const ToastCard(
                              leading: Icon(
                                Icons.notifications,
                                size: 32,
                              ),
                              title: Text(
                                "Check email for verification",
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
                        print("Verification email sent!");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()),
                        );
                      } else {
                        print("Error creating user or retrieving user object");
                      }
                    } on FirebaseAuthException catch (error) {
                      if (error.code == 'email-already-in-use') {
                        DelightToastBar(
                          builder: (context) {
                            return ToastCard(
                              leading: Icon(
                                Icons.error,
                                size: 32,
                                color: Colors.red,
                              ),
                              title: Text(
                                "An account with this email already exists",
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
                      } else {
                        print("Error creating account: ${error.message}");
                        DelightToastBar(
                          builder: (context) {
                            return const ToastCard(
                              leading: Icon(
                                Icons.notifications,
                                size: 32,
                              ),
                              title: Text(
                                "Error in creating account",
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
                    } catch (error) {
                      print("Error: ${error.toString()}");
                      DelightToastBar(
                        builder: (context) {
                          return const ToastCard(
                            leading: Icon(
                              Icons.notifications,
                              size: 32,
                            ),
                            title: Text(
                              "Error in creating account",
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
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
