import 'package:flutter/material.dart';

import 'logdevicepage.dart';
import 'viewdevicespage.dart';
import 'apidatapage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LandingPage());
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_new
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome to your IoT Device Manager',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor: Color.fromRGBO(2, 50, 82, 1),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 100,
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogDevicePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(2, 50, 82, 1),
                ),
                child: Text(
                  'Log a new device',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              height: 100,
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return ViewDevicesPage();
                    }),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(2, 50, 82, 1),
                ),
                child: Text(
                  'View Devices',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              height: 100,
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ApiDataPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(2, 50, 82, 1),
                ),
                child: Text(
                  'API data',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
