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
  State<Driving> createState() => _DrivingState();
}

class _DrivingState extends State<Driving> {
  List<double> accelerometer = [0.0, 0.0, 0.0];
  List<double> gyroscope = [0.0, 0.0, 0.0];
  double boxPosition = 0;
  bool _isReady = false;
  int count = 3;
  late Timer _timer;
  late IO.Socket socket;

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

    socket.on('connect', (_) {
      print('connect');
      socket.emit('message', 'hello');
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
    _timer.cancel(); // Stopp den Timer, wenn das Widget entsorgt wird
    socket.disconnect();
    super.dispose();
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
                      onPressed: () {
                        socket.emit('brake button pressed', 'hello');
                      },
                      text: "Break",
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Button(
                      onPressed: () {
                        socket.emit('gas button has been pressed', 'hello');
                      },
                      text: "Gas",
                    ),
                  ),
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
                                  width:
                                      2.0, // Setzen Sie die Border-Width hier
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
          ],
        ),
      ),
    );
  }
}
