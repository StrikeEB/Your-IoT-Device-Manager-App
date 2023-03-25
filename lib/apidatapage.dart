import 'package:flutter/material.dart';

import 'customappbar.dart';

class ApiDataPage extends StatefulWidget {
  const ApiDataPage({super.key});

  @override
  State<ApiDataPage> createState() => _ApiDataPageState();
}

class _ApiDataPageState extends State<ApiDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomAppBar.getAppBar('API Data'));
  }
}
