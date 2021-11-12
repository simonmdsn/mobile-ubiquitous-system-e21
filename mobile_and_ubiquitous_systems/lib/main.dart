import 'package:flutter/material.dart';
import 'package:mobile_and_ubiquitous_systems/pick_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile and Ubiquitous Systems',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PickScreen(),
    );
  }
}
