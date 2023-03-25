import 'package:flutter/material.dart';

class LogDevicePage extends StatefulWidget {
  const LogDevicePage({super.key});

  @override
  State<LogDevicePage> createState() => _LogDevicePageState();
}

class _LogDevicePageState extends State<LogDevicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Log a new device")));
  }
}
