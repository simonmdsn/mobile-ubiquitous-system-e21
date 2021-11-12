import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_and_ubiquitous_systems/assignment_1/location_and_sensor_data_screen.dart';
import 'package:mobile_and_ubiquitous_systems/assignment_3/commercial_activity_recognition_screen.dart';
import 'package:mobile_and_ubiquitous_systems/assignment_4/architectural_prototype_qas_screen.dart';

var screens = [
  ScreenData(
      LocationAndSensorDataScreen(
        title: "Assignment 1 (location / sensor data)",
      ),
      "Assignment 1 (location / sensor data)"),
  ScreenData(
      CommercialActivityRecognitionScreen(
        title: "Assignment 3 Activity Recog.",
      ),
      "Assignment 3 Activity Recog."),
  ScreenData(
      ApQasScreen(
        title: 'Assignment 4 Prototype',
      ),
      'Assignment 4 Prototype'),
];

class PickScreen extends StatelessWidget {
  const PickScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mobile and Ubiquitous, E21"),
      ),
      body: ListView.builder(
        itemBuilder: _buildRouteList,
        itemCount: screens.length,
        padding: EdgeInsets.all(12.0),
      ),
    );
  }

  Widget _buildRouteList(context, i) {
    var screenData = screens[i];
    return Card(
      child: ListTile(
        title: Text(screenData.screenName),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => screenData.screen,
          ),
        ),
      ),
    );
  }
}

class ScreenData {
  final Widget screen;
  final String screenName;

  ScreenData(this.screen, this.screenName);
}
