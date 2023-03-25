import 'package:flutter/material.dart';

class CustomAppBar {
  static AppBar getAppBar(String title) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      backgroundColor: Color.fromRGBO(2, 50, 82, 1),
    );
  }
}
