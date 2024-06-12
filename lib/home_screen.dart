import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

import 'signin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final LocalAuthentication auth;
  bool _supportState = false;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
          (bool isSupported) {
        setState(() {
          _supportState = isSupported;
        });
        if (isSupported) {
          _authenticate();
        }
      },
    );
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to access home controls',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticated = authenticated;
      });
      if (!authenticated) {
        _showAuthenticationFailedDialog();
      }
      print("Authenticated: $authenticated");
    } on PlatformException catch (e) {
      print(e);
      _showAuthenticationFailedDialog();
    }
  }

  void _showAuthenticationFailedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Authentication Failed'),
          content: Text('You could not be authenticated. Please try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /*
  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
    print("List of available biometrics: $availableBiometrics");

    if (!mounted) {
      return;
    }
  }

   */

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /*
            if (_supportState)
              const Text('This device is supported')
            else
              const Text('This device is not supported'),

             */
            const Divider(height: 100),
            ElevatedButton(
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
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => SignInScreen()),
                            );
                          },
                          child: Text('Logout'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
