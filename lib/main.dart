import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Landing Page',
      home: Scaffold(
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
                      MaterialPageRoute(
                          builder: (context) => ViewDevicesPage()),
                    );
                  },
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
      ),
    );
  }
}

class LogDevicePage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _LogDevicePageState createState() => _LogDevicePageState();
}

class _LogDevicePageState extends State<LogDevicePage> {
  late TextEditingController _w3wController;

  @override
  void initState() {
    super.initState();
    _w3wController = TextEditingController();
  }

  @override
  void dispose() {
    _w3wController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log a new device'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Log a new device',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'What3Words location:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _w3wController,
              decoration: InputDecoration(
                hintText: 'Enter What3Words location',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewDevicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Devices'),
      ),
      body: Center(
        child: Text(
          'View Devices',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class ApiDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Data'),
      ),
      body: Center(
        child: Text(
          'API Data',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
