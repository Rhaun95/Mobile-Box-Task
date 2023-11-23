import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors/sensors.dart';

class Driving extends StatefulWidget {
  const Driving({super.key});

  @override
  State<Driving> createState() => _DrivingState();
}

class _DrivingState extends State<Driving> {
  late List accelerometer;
  late List gyroscope;

  @override
  Widget build(BuildContext context) {
    // set the values of accelerometer and gyroscope
    accelerometerEvents.listen((AccelerometerEvent e) {
      setState(() {
        accelerometer = <double>[e.x, e.y, e.z];
      });
    });

    gyroscopeEvents.listen((GyroscopeEvent e) {
      setState(() {
        gyroscope = <double>[e.x, e.y, e.z];
      });
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              accelerometer.toString(),
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
            Text(
              gyroscope.toString(),
              style: TextStyle(fontSize: 20, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
