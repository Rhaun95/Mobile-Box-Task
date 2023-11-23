import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors/sensors.dart';

class Driving extends StatefulWidget {
  const Driving({super.key});

  @override
  State<Driving> createState() => _DrivingState();
}

class _DrivingState extends State<Driving> {
  List<double> accelerometer = [0.0, 0.0, 0.0];
  List<double> gyroscope = [0.0, 0.0, 0.0];

  @override
  Widget build(BuildContext context) {
    // set the values of accelerometer and gyroscope
    accelerometerEvents.listen((AccelerometerEvent e) {
      setState(() {
        accelerometer = [
          double.parse(e.x.toStringAsFixed(3)),
          double.parse(e.y.toStringAsFixed(3)),
          double.parse(e.z.toStringAsFixed(3)),
        ];
      });
    });

    gyroscopeEvents.listen((GyroscopeEvent e) {
      setState(() {
        gyroscope = [
          double.parse(e.x.toStringAsFixed(3)),
          double.parse(e.y.toStringAsFixed(3)),
          double.parse(e.z.toStringAsFixed(3)),
        ];
      });
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          body: Stack(
            children: [
              Positioned(
                  left: 16,
                  bottom: 16,
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueGrey,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 4,
                      ),
                      child: const SizedBox(
                          width: 40,
                          height: 40,
                          child: Center(
                            child: Text('Break'),
                          )))),
              Positioned(
                  right: 16,
                  bottom: 16,
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueGrey,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 4,
                      ),
                      child: const SizedBox(
                          width: 40,
                          height: 40,
                          child: Center(
                            child: Text('Gas'),
                          )))),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "accelerometer: $accelerometer",
                      style: TextStyle(fontSize: 14, color: Colors.red),
                    ),
                    Text(
                      "gyroscope: $gyroscope",
                      style: TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
