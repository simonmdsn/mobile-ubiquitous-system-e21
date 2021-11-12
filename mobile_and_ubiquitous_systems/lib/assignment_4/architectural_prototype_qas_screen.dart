import 'dart:async';
import 'dart:io';

import 'package:battery/battery.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';

class ApQasScreen extends StatefulWidget {
  const ApQasScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _ApQasScreenState createState() => _ApQasScreenState();
}

class _ApQasScreenState extends State<ApQasScreen> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  late File pollingFile;
  late File listeningFile;

  String pollingText = "Start polling";
  String listeningText = "Start listening";

  Location? location;
  Battery? battery;

  bool polling = false;
  bool listening = false;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    initFile();
    location = Location();
    battery = Battery();
  }

  void initFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    pollingFile = File('${directory.path}/polling.txt');
    listeningFile = File('${directory.path}/listening.txt');
  }

  void writeToFile(String text, File file) async {
    await file.writeAsString(text, mode: FileMode.append);
  }

  startListen() {
    _streamSubscriptions.add(location!.onLocationChanged.listen((loc) async {
      var batteryLevel = await battery!.batteryLevel;
      writeToFile('${new DateTime.now().toIso8601String()};$batteryLevel;$loc\n',
          listeningFile);
    }));
  }

  startPolling() {
    timer = Timer.periodic(Duration(milliseconds: 100), (timer) async {
      var loc = await location!.getLocation();
      var batteryLevel = await battery!.batteryLevel;
      writeToFile('${new DateTime.now().toIso8601String()};$batteryLevel;$loc\n',
          pollingFile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                if (!polling) {
                  startListen();
                  setState(() {
                    listeningText = 'Stop listening';
                  });
                }
                if (listening) {
                  _streamSubscriptions.first.cancel();
                  setState(() {
                    listeningText = 'Start listening';
                  });
                }
                listening = !listening;
              },
              child: Text(listeningText),
            ),
            SizedBox(
              height: 150,
            ),
            TextButton(
              onPressed: () {
                if (!listening) {
                  startPolling();
                  setState(() {
                    pollingText = 'Stop polling';
                  });
                }
                if (polling) {
                  timer!.cancel();
                  setState(() {
                    pollingText = 'Start polling';
                  });
                }
                polling = !polling;
              },
              child: Text(pollingText),
            ),
          ],
        ),
      ),
    );
  }
}
