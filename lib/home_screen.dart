import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'signin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Logout"),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Confirm Logout'),
                  content: Text('Are you sure you want to logout?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        // Logout successful, show toast and navigate
                        DelightToastBar(
                          builder: (context) {
                            return const ToastCard(
                              leading: Icon(
                                Icons.notifications,
                                size: 32,
                              ),
                              title: Text(
                                "You have been logged out",
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
                        print("Signed Out");
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => SignInScreen()));
                      },
                      child: Text('Logout'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
