import 'package:flutter/material.dart';

import 'customappbar.dart';

class ViewDevicesPage extends StatefulWidget {
  const ViewDevicesPage({super.key});

  @override
  State<ViewDevicesPage> createState() => _ViewDevicesPageState();
}

class _ViewDevicesPageState extends State<ViewDevicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomAppBar.getAppBar('View devices'));
  }
}
