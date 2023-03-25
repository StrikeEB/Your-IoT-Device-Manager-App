import 'package:flutter/material.dart';

import 'customappbar.dart';

class LogDevicePage extends StatefulWidget {
  const LogDevicePage({Key? key}) : super(key: key);

  @override
  State<LogDevicePage> createState() => _LogDevicePageState();
}

class _LogDevicePageState extends State<LogDevicePage> {
  final TextEditingController _what3WordsController = TextEditingController();
  final TextEditingController _longController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.getAppBar('Log a new device'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _what3WordsController,
              decoration: InputDecoration(labelText: 'What3Words:'),
            ),
            TextFormField(
              controller: _longController,
              decoration: InputDecoration(labelText: 'Long:'),
            ),
            TextFormField(
              controller: _latController,
              decoration: InputDecoration(labelText: 'Lat:'),
            ),
            TextFormField(
              controller: _streetController,
              decoration: InputDecoration(labelText: 'Street:'),
            ),
            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'City:'),
            ),
            TextFormField(
              controller: _postcodeController,
              decoration: InputDecoration(labelText: 'Postcode:'),
            ),
            TextFormField(
              controller: _dateTimeController,
              decoration: InputDecoration(labelText: 'Date Time:'),
            ),
          ],
        ),
      ),
    );
  }
}
