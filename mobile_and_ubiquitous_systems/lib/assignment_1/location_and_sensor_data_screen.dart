import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:sensors_plus/sensors_plus.dart';

class LocationAndSensorDataScreen extends StatefulWidget {
  final String title;

  const LocationAndSensorDataScreen({Key? key, required this.title})
      : super(key: key);

  @override
  _LocationAndSensorDataScreenState createState() =>
      _LocationAndSensorDataScreenState(title);
}

class _LocationAndSensorDataScreenState
    extends State<LocationAndSensorDataScreen> {
  final String title;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  var location = Location();
  LocationData? _locationData;
  List<double>? _accelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _magnetometerValues;

  _LocationAndSensorDataScreenState(this.title);

  @override
  void initState() {
    super.initState();
    listen();
  }

  listen() {
    _streamSubscriptions.addAll([
      location.onLocationChanged.listen((event) {
        setState(() {
          _locationData = event;
        });
      }),
      accelerometerEvents.listen((event) {
        setState(() {
          _accelerometerValues = <double>[event.x, event.y, event.z];
        });
      }),
      gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          setState(() {
            _gyroscopeValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
      magnetometerEvents.listen(
        (MagnetometerEvent event) {
          setState(() {
            _magnetometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _dataCard(
            Text(_locationData != null
                ? "lat: " +
                    _locationData!.latitude.toString() +
                    " lng: " +
                    _locationData!.longitude.toString() +
                    "\n" +
                    "altitude: " +
                    _locationData!.altitude.toString()
                : "Location not found yet"),
          ),
          _dataCard(Text(_accelerometerValues != null
              ? "Accelerometer: $_accelerometerValues"
              : "Not found")),
          _dataCard(Text(_gyroscopeValues != null
              ? "Gyroscope: $_gyroscopeValues"
              : "Not found")),
          _dataCard(Text(_magnetometerValues != null
              ? "Magnetometer: $_magnetometerValues"
              : "Not found"))
        ],
      ),
    );
  }

  Widget _dataCard(Text text) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 80),
      child: Card(
        child: Center(
          child: text,
        ),
      ),
    );
  }
}
