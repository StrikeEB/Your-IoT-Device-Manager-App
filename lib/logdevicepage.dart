import 'package:flutter/material.dart';

import 'customappbar.dart';

class LogDevicePage extends StatefulWidget {
  const LogDevicePage({super.key});

  @override
  State<LogDevicePage> createState() => _LogDevicePageState();
}

class _LogDevicePageState extends State<LogDevicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomAppBar.getAppBar('Log a new device'));
  }
}
