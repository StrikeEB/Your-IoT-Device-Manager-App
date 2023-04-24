import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'customappbar.dart';

class ViewDevicesPage extends StatefulWidget {
  const ViewDevicesPage({super.key});

  @override
  State<ViewDevicesPage> createState() => _ViewDevicesPageState();
}

class _ViewDevicesPageState extends State<ViewDevicesPage> {
  @override
  Widget build(BuildContext context) {
    CollectionReference deviceCollection =
        FirebaseFirestore.instance.collection('Device');

    Future<void> getData() async {
      QuerySnapshot querySnapshot = await deviceCollection.get();

      final dataToSave = querySnapshot.docs.map((doc) => doc.data()).toList();
      print(dataToSave);
    }

    getData(); //

    return Scaffold(
      appBar: CustomAppBar.getAppBar('View devices'),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
