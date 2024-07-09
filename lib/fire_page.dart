import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth Devices',
      home: FireAlertPage(),
    );
  }
}

class FireAlertPage extends StatefulWidget {
  @override
  _FireAlertPageState createState() => _FireAlertPageState();
}

class _FireAlertPageState extends State<FireAlertPage> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  BluetoothConnection? connection;
  bool isConnected = false;
  List<BluetoothDevice> devicesList = [];
  BluetoothDevice? selectedDevice;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _getPairedDevices();
  }

  void _initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _getPairedDevices() async {
    try {
      List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance.getBondedDevices();
      setState(() {
        devicesList = devices;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _connectToDevice(BluetoothDevice device) async {
    try {
      await BluetoothConnection.toAddress(device.address).then((_connection) {
        connection = _connection;
        setState(() {
          isConnected = true;
          selectedDevice = device;
        });
        _listenToBluetooth();
      }).catchError((error) {
        print('Cannot connect, exception occurred');
        print(error);
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _listenToBluetooth() {
    connection?.input?.listen((data) {
      String message = String.fromCharCodes(data).trim();
      if (message.contains('A')) {
        _showNotification("Fire detected!");
      }
    }).onDone(() {
      print('Disconnected by remote request');
      setState(() {
        isConnected = false;
      });
    });
  }

  Future<void> _showNotification(String message) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'fire_alert_channel',
      'Fire Alerts',
      channelDescription: 'Channel for fire alert notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Fire Alert',
      message,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fire Alert System'),
      ),
      body: isConnected
          ? Center(child: Text('Connected to ${selectedDevice?.name}'))
          : ListView.builder(
        itemCount: devicesList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(devicesList[index].name ?? 'Unknown Device'),
            subtitle: Text(devicesList[index].address),
            trailing: ElevatedButton(
              onPressed: () => _connectToDevice(devicesList[index]),
              child: Text('Connect'),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    if (isConnected) {
      connection?.dispose();
    }
    super.dispose();
  }
}
