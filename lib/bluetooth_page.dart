import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothDeviceListScreen extends StatefulWidget {
  @override
  _BluetoothDeviceListScreenState createState() => _BluetoothDeviceListScreenState();
}

class _BluetoothDeviceListScreenState extends State<BluetoothDeviceListScreen> {
  List<BluetoothDiscoveryResult> _devices = [];
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
        BluetoothConnection connection = await BluetoothConnection.toAddress(device.address);
        print('Connected to the device');
        // Handle connection
      }
    } catch (e) {
      print('Error connecting to device: $e');
    }
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
            child: CircularProgressIndicator(color: Colors.white),
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
