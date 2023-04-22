import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what3words/what3words.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'customappbar.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
//create an instance of what3wordsv3 and pass your API key
  var api = What3WordsV3('QQVQ4KZ6');
  runApp(LogDevicePage());
}

class LogDevicePage extends StatefulWidget {
  @override
  State<LogDevicePage> createState() => _LogDevicePageState();
}

class _LogDevicePageState extends State<LogDevicePage> {
  final storage = FirebaseStorage.instance;
  final controllerWhat3Words = TextEditingController();
  final controllerDeviceID = TextEditingController();
  final controllerDeviceMake = TextEditingController();
  final controllerDeviceModel = TextEditingController();
  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    final messenger = ScaffoldMessenger.of(context);
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Future.delayed(const Duration(seconds: 5));
      messenger.showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await Future.delayed(const Duration(seconds: 5));
        messenger.showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      await Future.delayed(const Duration(seconds: 5));
      messenger.showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {});
      await _getAddressFromLatLng(_currentPosition!);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      final placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppBar.getAppBar('Log a new device'),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            const SizedBox(height: 32),
            TextField(
              controller: controllerDeviceID,
              decoration: decoration('Device number'),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controllerDeviceMake,
              decoration: decoration('Device make'),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controllerDeviceModel,
              decoration: decoration('Device model'),
            ),
            const SizedBox(height: 24),
            Text(
              'Latitude: ${_currentPosition?.latitude ?? ""}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Text(
              'Longitude: ${_currentPosition?.longitude ?? ""}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Text(
              'Address: ${_currentAddress ?? ""}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(2, 50, 82, 1),
                ),
                onPressed: _getCurrentPosition,
                child: const Text("Get Current Location")),
            const SizedBox(height: 32),
            TextField(
              controller: controllerWhat3Words,
              decoration: decoration('What3Words'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(2, 50, 82, 1),
                ),
                onPressed: _getCurrentPosition,
                child: const Text("Get What3Words")),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(2, 50, 82, 1),
              ),
              onPressed: () {
                final device = Device(
                  what3Words: controllerWhat3Words.text,
                  deviceid: controllerDeviceID.text,
                  devicemake: controllerDeviceMake.text,
                  devicemodel: controllerDeviceModel.text,
                );

                Navigator.pop(context);

                Map<String, String> dataToSave = {
                  'id': controllerDeviceID.text,
                  'What3Words': controllerWhat3Words.text,
                  'Device number': controllerDeviceID.text,
                  'Device make': controllerDeviceMake.text,
                  'Device model': controllerDeviceModel.text,
                };

//add data to the database
                FirebaseFirestore.instance.collection("Device").add(dataToSave);
              },
              child: Text('Submit'),
            )
          ],
        ),
      );

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      );
}

class Device {
  String id;
  final String what3Words;
  final String deviceid;
  final String devicemake;
  final String devicemodel;

  Device({
    this.id = '',
    required this.what3Words,
    required this.deviceid,
    required this.devicemake,
    required this.devicemodel,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'What3Words': what3Words,
        'Device number': deviceid,
        'Device make': devicemake,
        'Device model': devicemodel,
      };
}
