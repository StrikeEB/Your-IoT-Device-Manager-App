import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'customappbar.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(LogDevicePage());
}

class LogDevicePage extends StatefulWidget {
  @override
  State<LogDevicePage> createState() => _LogDevicePageState();
}

class _LogDevicePageState extends State<LogDevicePage> {
  final controllerWhat3Words = TextEditingController();
  final controllerLong = TextEditingController();
  final controllerLat = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppBar.getAppBar('Log a new device'),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextField(
              controller: controllerWhat3Words,
              decoration: decoration('What3Words'),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controllerLong,
              decoration: decoration('Long'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controllerLat,
              decoration: decoration('Lat'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            const SizedBox(height: 32),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                final device = Device(
                  what3Words: controllerWhat3Words.text,
                  long: int.parse(controllerLong.text),
                  lat: int.parse(controllerLat.text),
                );

                createDevice(device);

                Navigator.pop(context);
              },
            )
          ],
        ),
      );

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      );

  Future createDevice(Device device) async {
    final docDevice =
        FirebaseFirestore.instance.collection('Device').doc('my-id');
    device.id = docDevice.id;

    final json = device.toJson();
    await docDevice.set(json);
  }
}

class Device {
  String id;
  final String what3Words;
  final int long;
  final int lat;

  Device({
    this.id = '',
    required this.what3Words,
    required this.long,
    required this.lat,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'What3Words': what3Words,
        'Long': long,
        'Lat': lat,
      };
}
