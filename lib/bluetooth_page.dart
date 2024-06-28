import 'dart:typed_data';

import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothDeviceListScreen extends StatefulWidget {
  @override
  _BluetoothDeviceListScreenState createState() => _BluetoothDeviceListScreenState();
}

class _BluetoothDeviceListScreenState extends State<BluetoothDeviceListScreen> {
  List<BluetoothDiscoveryResult> _devices = [];
  late BluetoothConnection _connection;
  bool _isDiscovering = false;

  @override
  void initState() {
    super.initState();
    _startDiscovery();
  }

  void _startDiscovery() async {
    if (await Permission.location.request().isGranted) {
      setState(() {
        _isDiscovering = true;
        _devices.clear();
      });

      try {
        FlutterBluetoothSerial.instance.startDiscovery().listen((result) {
          setState(() {
            _devices.add(result);
          });
        }).onDone(() {
          setState(() {
            _isDiscovering = false;
          });
        });
      } catch (e) {
        print('Error starting discovery: $e');
        setState(() {
          _isDiscovering = false;
        });
      }
    } else {
      print('Location permission not granted');
    }
  }

  void _connectToDevice(BluetoothDevice device) async {
    try {
      if (device != null) {
        _connection = await BluetoothConnection.toAddress(device.address);
        print('Connected to the device');

        DelightToastBar(
          builder: (context) {
            return const ToastCard(
              leading: Icon(
                Icons.bluetooth,
                size: 32,
                color: Colors.black12,
              ),
              title: Text(
                "Connected to the device",
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

        _connection.input?.listen((Uint8List data) {
          String incomingMessage = String.fromCharCodes(data);
          print('Data incoming: $incomingMessage');

          if (incomingMessage.contains('** Warning!!!!   Fire detected!!! **')) {
            _showFireNotification();
          }
        }).onDone(() {
          print('Disconnected by remote request');
        });
      }
    } catch (e) {
      print('Error connecting to device: $e');
    }
  }

  void _showFireNotification() {
    DelightToastBar(
      builder: (context) {
        return const ToastCard(
          leading: Icon(
            Icons.warning,
            size: 32,
            color: Colors.red,
          ),
          title: Text(
            "Fire detected!",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Devices'),
        actions: [
          _isDiscovering
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(color: Colors.black),
          )
              : IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _startDiscovery();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _devices.length,
        itemBuilder: (context, index) {
          BluetoothDiscoveryResult result = _devices[index];
          BluetoothDevice device = result.device;
          return ListTile(
            title: Text(device.name ?? 'Unknown Device'),
            subtitle: Text(device.address),
            trailing: ElevatedButton(
              onPressed: () => _connectToDevice(device),
              child: Text('Connect'),
            ),
          );
        },
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterBluetoothSerial.instance.requestEnable();
  runApp(MaterialApp(
    home: BluetoothDeviceListScreen(),
  ));
}
