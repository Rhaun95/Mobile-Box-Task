import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_box_task/view/CompletePage.dart';
import 'package:mobile_box_task/widget/Button.dart';
import 'package:sensors/sensors.dart';

class Driving extends StatefulWidget {
  const Driving({Key? key}) : super(key: key);

  @override
  State<Driving> createState() => _DrivingState();
}

class _DrivingState extends State<Driving> {
  List<double> accelerometer = [0.0, 0.0, 0.0];
  List<double> gyroscope = [0.0, 0.0, 0.0];
  bool _isReady = false;
  int count = 3;
  late Timer _timer;

  void startCountdown() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        if (count > 0) {
          count--;
        } else {
          _isReady = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel(); // Stopp den Timer, wenn das Widget entsorgt wird
    super.dispose();
  }

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
            if (!_isReady)
              Center(
                child: Text(
                  '$count',
                  style: const TextStyle(fontSize: 30, color: Colors.blue),
                ),
              ),
            if (_isReady)
              Stack(
                children: [
                  Positioned(
                    left: 16,
                    top: 16,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CompeletPage()));
                      },
                      icon:
                          const Icon(Icons.cancel_outlined, color: Colors.blue),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: Button(
                      onPressed: () {},
                      text: "Break",
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Button(
                      onPressed: () {},
                      text: "Gas",
                    ),
                  ),
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
          ],
        ),
      ),
    );
  }
}
