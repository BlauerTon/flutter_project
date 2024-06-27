import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'util/smart_device_box.dart';
import 'bluetooth_page.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double horizontalPadding = 40;
  final double verticalPadding = 25;
  BluetoothConnection? connection;

  List mySmartDevices = [
    ["Kitchen", "lib/icons/light-bulb.png", false],
    ["AC", "lib/icons/air-conditioner.png", false],
    ["TV", "lib/icons/smart-tv.png", false],
    ["Fan", "lib/icons/fan.png", false],
  ];

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  void _initBluetooth() async {
    // Initialize Bluetooth connection (assuming the device is already paired)
    // You need to replace the address with the MAC address of your HC-05 module
    String address = "98:D3:11:FD:35:8F"; // Replace with the MAC address of your HC-05
    try {
      connection = await BluetoothConnection.toAddress(address);
      print('Connected to the device');
    } catch (e) {
      print('Error connecting to device: $e');
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
        command = value ? "F" : "N";
        break;
      default:
        command = "";
        break;
    }
    sendMessage(command);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
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
                    Icon(
                      Icons.person,
                      size: 45,
                      color: Colors.grey[800],
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
                      "Welcome Home,",
                      style: TextStyle(fontSize: 20, color: Colors.grey.shade800),
                    ),
                    Text(
                      'Ray Bands',
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
                    color: Colors.grey.shade800,
                  ),
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
