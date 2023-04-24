import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:what3words/what3words.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

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
  final storage = FirebaseStorage.instance;
  final controllerWhat3Words = TextEditingController();
  final controllerDeviceID = TextEditingController();
  final controllerDeviceMake = TextEditingController();
  final controllerDeviceModel = TextEditingController();
  final controllerLongitude = TextEditingController();
  final controllerLatitude = TextEditingController();
  final controllerAddress = TextEditingController();
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

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      controllerLongitude.text = position.longitude.toString();
      controllerLatitude.text = position.latitude.toString();
    });
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
            TextField(
              controller: controllerLongitude,
              decoration: decoration('Longitude'),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controllerLatitude,
              decoration: decoration('Latitude'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(2, 50, 82, 1),
                ),
                onPressed: _getCurrentLocation,
                child: const Text("Get coordinates")),
            const SizedBox(height: 24),
            TextField(
              controller: TextEditingController(text: _currentAddress),
              decoration: decoration('Address'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(2, 50, 82, 1),
                ),
                onPressed: _getCurrentPosition,
                child: const Text("Get address based on coordinates")),
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
                onPressed: () {
                  void main() async {
                    // For all requests a what3words API key is needed
                    var api = What3WordsV3('QQVQ4KZ6');

                    // Get the user's location
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);

                    // Convert the coordinates to a 3 word address
                    var words = await api
                        .convertTo3wa(
                            Coordinates(position.longitude, position.latitude))
                        .language('en')
                        .execute();

                    if (words.isSuccessful()) {
                      var what3words = words.data()?.toJson();
                      print('Words: ${words.data()?.toJson()}');
                    } else {
                      var error = words.error();

                      if (error == What3WordsError.BAD_COORDINATES) {
                        // The coordinates provided were bad
                        print('BadCoordinates: ${error!.message}');
                      } else if (error == What3WordsError.BAD_LANGUAGE) {
                        // The language provided was bad
                        print('BadLanguage: ${error!.message}');
                      } else if (error ==
                          What3WordsError.INTERNAL_SERVER_ERROR) {
                        // Server Error
                        print('InternalServerError: ${error!.message}');
                      } else if (error == What3WordsError.NETWORK_ERROR) {
                        // Network Error
                        print('NetworkError: ${error!.message}');
                      } else {
                        print('${error!.code} : ${error.message}');
                      }
                    }
                  }
                },
                child: const Text("Get What3Words")),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(2, 50, 82, 1),
              ),
              onPressed: () {
                dataToSave = {
                  'id': controllerDeviceID.text,
                  'What3Words': controllerWhat3Words.text,
                  'Device number': controllerDeviceID.text,
                  'Device make': controllerDeviceMake.text,
                  'Device model': controllerDeviceModel.text,
                  'Longitude': controllerLongitude.text,
                  'Latitude': controllerLatitude.text,
                };
                final device = Device(
                    what3Words: controllerWhat3Words.text,
                    deviceid: controllerDeviceID.text,
                    devicemake: controllerDeviceMake.text,
                    devicemodel: controllerDeviceModel.text,
                    longitude: controllerLongitude.text,
                    latitude: controllerLatitude.text);

                Navigator.pop(context);

//add data to the database
                FirebaseFirestore.instance.collection("Device").add(dataToSave);
              },
              child: Text('Save the device'),
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
  final String longitude;
  final String latitude;

  Device(
      {this.id = '',
      required this.what3Words,
      required this.deviceid,
      required this.devicemake,
      required this.devicemodel,
      required this.longitude,
      required this.latitude});
}

Map<String, dynamic> dataToSave = {
  'id': '',
  'What3Words': '',
  'Device number': '',
  'Device make': '',
  'Device model': '',
  'Longitude': '',
  'Latitude': '',
};
