import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'util/smart_device_box.dart';
import 'bluetooth_page.dart';
import 'wid_gets.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final LocalAuthentication auth;
  bool _supportState = false;
  bool _isAuthenticated = false;

  @override
  void initState() {

    _initBluetooth();
    _getCurrentUser();


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


  final double horizontalPadding = 40;
  final double verticalPadding = 25;
  BluetoothConnection? connection;
  String username = "";

  List mySmartDevices = [
    ["Kitchen", "lib/icons/light-bulb.png", false],
    ["AC", "lib/icons/air-conditioner.png", false],
    ["TV", "lib/icons/smart-tv.png", false],
    ["Fan", "lib/icons/fan.png", false],
  ];

  /*
  @override
  void initState() {
    super.initState();
    _initBluetooth();
    _getCurrentUser();
  }

   */

  void _initBluetooth() async {
    // Initialize Bluetooth connection (assuming the device is already paired)
    String address = "98:D3:11:FD:35:8F";
    try {
      connection = await BluetoothConnection.toAddress(address);
      print('Connected to the device');
      connection!.input!.listen(_onDataReceived).onDone(() {
        print('Disconnected by remote request');
      });
    } catch (e) {
      print('Error connecting to device: $e');
    }
  }

  void _onDataReceived(Uint8List data) {
    String message = utf8.decode(data);
    print("Received message: $message");

    if (message.contains("** Warning!!!!   Fire detected!!! **")) {
      print("Fire detected message received!");
      DelightToastBar(
        builder: (context) {
          return const ToastCard(
            leading: Icon(
              Icons.local_fire_department_rounded,
              size: 32,
              color: Colors.white,
            ),
            title: Text(
              "Potential Fire Detected",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                backgroundColor: Colors.red,
                color: Colors.white,
              ),
            ),
          );
        },
        position: DelightSnackbarPosition.top,
        autoDismiss: true,
        snackbarDuration: Durations.extralong4,
      ).show(context);
    }
  }


  void sendMessage(String message) async {
    if (connection != null && connection!.isConnected) {
      connection!.output.add(Uint8List.fromList(utf8.encode(message)));
      await connection!.output.allSent;
      print('Sent message: $message');
    } else {
      print('No Bluetooth connection');
    }
  }

  void powerSwitchChanged(bool value, int index) {
    setState(() {
      mySmartDevices[index][2] = value;
    });

    if (mySmartDevices.every((device) => device[2] == true)) {
      DelightToastBar(
        builder: (context) {
          return const ToastCard(
            leading: Icon(
              Icons.electric_bolt_outlined,
              size: 32,
              color: Colors.black,
            ),
            title: Text(
              "Too many devices powered on. Consider saving power",
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
    }


    String command;
    switch (index) {
      case 0: // Kitchen
        command = value ? "K" : "N";
        break;
      case 1: // AC
        command = value ? "A" : "C";
        break;
      case 2: // TV
        command = value ? "T" : "V";
        break;
      case 3: // Fan
        command = value ? "F" : "M";
        break;
      default:
        command = "";
        break;
    }
    sendMessage(command);
  }

  void _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        username = user.displayName ?? "User";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      drawer: NavDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BluetoothDeviceListScreen()),
                        );
                      },
                      child: Image.asset(
                        'lib/icons/menu.png',
                        height: 45,
                        color: Colors.grey[800],
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        return GestureDetector(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: Icon(
                            Icons.person,
                            size: 45,
                            color: Colors.grey[800],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome Home",
                      style: TextStyle(fontSize: 20, color: Colors.grey.shade800),
                    ),
                    Text(
                      username,
                      style: GoogleFonts.bebasNeue(fontSize: 72),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 204, 204, 204),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Text(
                  "Smart Devices",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.grey.shade800),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: mySmartDevices.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1 / 1.3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    return SmartDeviceBox(
                      smartDeviceName: mySmartDevices[index][0],
                      iconPath: mySmartDevices[index][1],
                      powerOn: mySmartDevices[index][2],
                      onChanged: (value) => powerSwitchChanged(value, index),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
