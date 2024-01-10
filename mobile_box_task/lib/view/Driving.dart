import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_box_task/view/CompletePage.dart';
import 'package:mobile_box_task/widget/Button.dart';
import 'package:sensors/sensors.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class Driving extends StatefulWidget {
  const Driving({Key? key}) : super(key: key);

  @override
  _DrivingState createState() => _DrivingState();
}

class _DrivingState extends State<Driving> {
  List<double> accelerometer = [0.0, 0.0, 0.0];
  List<double> gyroscope = [0.0, 0.0, 0.0];
  double boxPosition = 0;
  bool _isReady = false;
  int count = 3;
  late Timer _timer;
  late IO.Socket socket;
  int speed = 0;
  double accelerationFactor = 50.0;
  bool isGasPressed = false;
  bool isBrakePressed = false;

  @override
  void initState() {
    super.initState();
    startCountdown();
    socket = IO.io('http://localhost:3001', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        if (-10 <= boxPosition && boxPosition <= 10) {
          if (boxPosition < 0) {
            // boxPosition = (event.y).floor();
            boxPosition = event.y;
          } else {
            // boxPosition = (event.y).ceil();
            boxPosition = event.y;
          }
        } else {
          boxPosition = 0;
        }
        socket.emit('boxPosition', boxPosition);
      });
    });

    socket.onConnect((_) {
      print('Connected to server');
    });

    socket.onDisconnect((_) {
      print('Disconnected from server');
    });

    socket.connect();
  }

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
  void dispose() {
    _timer.cancel();
    socket.disconnect();
    super.dispose();
  }

  Timer? gasTimer;
  Timer? brakeTimer;

  void increaseSpeed() {
    if (speed <= 200) {
      speed += accelerationFactor.toInt();
      if (speed > 200) speed = 200;
      socket.emit("gas button has been pressed", speed);
      accelerationFactor *= 0.95;
      if (accelerationFactor < 1) accelerationFactor = 1;
      setState(() {});
    }
  }

  void decreaseSpeed() {
    if (speed >= 0) {
      speed -= accelerationFactor.toInt();
      if (speed < 0) speed = 0;
      socket.emit("brake button pressed", speed);
      accelerationFactor *= 0.95;
      if (accelerationFactor < 1) accelerationFactor = 1;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  style: const TextStyle(fontSize: 60, color: Colors.blue),
                ),
              ),
            if (_isReady)
              Positioned(
                left: 16,
                bottom: 16,
                child: GestureDetector(
                  onLongPressStart: (_) {
                    brakeTimer =
                        Timer.periodic(Duration(milliseconds: 1), (timer) {
                      decreaseSpeed();
                    });
                  },
                  onLongPressEnd: (_) {
                    brakeTimer?.cancel();
                    accelerationFactor = 50;
                  },
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
                    child: SizedBox(
                        width: 60,
                        height: 60,
                        child: Center(
                          child: Text("Brake"),
                        )),
                  ),
                ),
              ),
            if (_isReady)
              Positioned(
                right: 16,
                bottom: 16,
                child: GestureDetector(
                  onLongPressStart: (_) {
                    gasTimer =
                        Timer.periodic(Duration(milliseconds: 1), (timer) {
                      increaseSpeed();
                    });
                  },
                  onLongPressEnd: (_) {
                    gasTimer?.cancel();
                    accelerationFactor = 50;
                  },
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
                    child: SizedBox(
                        width: 60,
                        height: 60,
                        child: Center(
                          child: Text("Gas"),
                        )),
                  ),
                ),
              ),
            if (_isReady)
              Positioned(
                left: MediaQuery.of(context).size.width * 0.5 -
                    100 +
                    boxPosition * 30,
                top: MediaQuery.of(context).size.height * 0.5 - 100,
                child: Center(
                  child: Container(
                    width: 200.0,
                    height: 200.0,
                    color: Colors.blue,
                  ),
                ),
              ),
            if (_isReady)
              Positioned(
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: Container(
                          width: 250.0,
                          height: 250.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 50,
                        top: 50,
                        child: Container(
                          width: 150.0,
                          height: 150.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors
                                  .black, // Setzen Sie die Border-Color hier
                              width: 2.0, // Setzen Sie die Border-Width hier
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
