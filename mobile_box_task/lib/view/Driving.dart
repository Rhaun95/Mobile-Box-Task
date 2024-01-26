// ignore_for_file: library_prefixes, library_private_types_in_public_api

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_box_task/provider/DrivingData.dart';
import 'package:mobile_box_task/view/CompletePage.dart';
import 'package:mobile_box_task/view/ReadyToStartPage.dart';
import 'package:mobile_box_task/view/SliderPage.dart';
import 'package:provider/provider.dart';
import 'package:sensors/sensors.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:vibration/vibration.dart';

class Driving extends StatefulWidget {
  const Driving({super.key});

  @override
  _DrivingState createState() => _DrivingState();
}

class _DrivingState extends State<Driving> {
  double _sliderValue = 0;
  List<double> accelerometer = [0.0, 0.0, 0.0];
  List<double> gyroscope = [0.0, 0.0, 0.0];
  double boxPosition = 0;
  bool _isReady = false;
  late Timer _timer;
  late IO.Socket socket;
  double speed = 0;
  bool isGasPressed = false;
  bool isBrakePressed = false;
  bool hasToClick = false;
  int count = 0;

  Timer? gasTimer;
  Timer? brakeTimer;

  Stopwatch stopwatchDuration = Stopwatch();
  Stopwatch stopwatchDRT = Stopwatch();

  // late String roomName;

  @override
  void initState() {
    super.initState();
    startCountdown(3);
    setHasToClickAfterRandomTime();
    socket = IO.io('http://box-task.imis.uni-luebeck.de', <String, dynamic>{
      // socket = IO.io('http://box-task.imis.uni-luebeck.de', <String, dynamic>{
      // socket = IO.io('http://192.168.1.15:3001', <String, dynamic>{
      // socket = IO.io('http://192.168.178.22:3001', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.emit("join room", DrivingData.roomName);

    stopwatchDuration.start();

    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        if (-10 <= boxPosition && boxPosition <= 10) {
          if (boxPosition < 0) {
            boxPosition = event.y;
          } else {
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

    // socket.onDisconnect((_) {
    //   print('Disconnected from server');
    // });

    //     socket.on('disconnect', (_) {
    //   print('Disconnected from server');
    // });

    socket.on('new number', (receivedSpeed) {
      setState(() {
        speed = receivedSpeed.toDouble();
      });
    });

    socket.connect();
  }

  void startCountdown(int duration) {
    count = duration;
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        if (count > 0) {
          count--;
        } else {
          if (ReadyToStartPage.isChecked) {
            if (_isReady) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CompletePage()));
            } else {
              startCountdown(4);
            }
          }
          timer.cancel();
          _isReady = true;
        }
      });
    });
  }

  void disconnectFromFlutter() {
    // send the leave event to server
    socket.emit('leaveRoom', {'roomName': DrivingData.roomName});

    // client disconnect
    socket.emit('disconnect');
    // socket.disconnect();
  }

  @override
  void dispose() {
    disconnectFromFlutter();
    socket.disconnect();

    _timer.cancel();
    super.dispose();
  }

  void setHasToClickAfterRandomTime() {
    Timer.periodic(Duration(seconds: 3 + Random().nextInt(3)), (timer) {
      setState(() {
        hasToClick = true;
        Vibration.vibrate(duration: 100);
        timer.cancel();
        stopwatchDRT.start();
      });
    });
  }

  void drtPressed() {
    setState(() {
      hasToClick = false;
      setHasToClickAfterRandomTime();
    });
  }

  void decreaseSpeed() {
    setState(() {
      socket.emit("brake button pressed", speed);
      socket.emit("brake button state", true);
    });
  }

  void increaseSpeed() {
    setState(() {
      socket.emit("gas button has been pressed", speed);
      socket.emit("gas button state", true);
    });
  }

  void gasPressed() {
    setState(() {
      gasTimer?.cancel();
      gasTimer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
        increaseSpeed();
      });
    });
  }

  // void increaseSpeed() {}

  void brakePressed() {
    setState(() {
      brakeTimer?.cancel();
      brakeTimer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
        decreaseSpeed();
      });
    });
  }

  void updateSliderState() {
    setState(() {
      socket.emit("slider change", _sliderValue);
    });
  }

  void noInput() {
    gasTimer!.cancel();
    brakeTimer!.cancel();
    socket.emit("gas button state", false);
    socket.emit("brake button state", false);
  }

  @override
  Widget build(BuildContext context) {
    DrivingData drivingData = Provider.of<DrivingData>(context);

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
                  top: 20,
                  left: 60,
                  child: Text(
                    'Room Name: ${DrivingData.roomName}',
                    style: const TextStyle(fontSize: 20, color: Colors.blue),
                  )),
            if (ReadyToStartPage.isChecked)
              Positioned(
                top: 16,
                left: MediaQuery.of(context).size.width * 0.49,
                child: Text(
                  '$count',
                  style: const TextStyle(fontSize: 40, color: Colors.blue),
                ),
              ),
            if (_isReady)
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: MediaQuery.of(context).size.width * 0.5 -
                          speed / 2 +
                          boxPosition * 50,
                      child: Container(
                        width: min(speed, 0.0),
                        height: min(speed, 0.0),
                        color: Colors.blue,
                        child: Center(
                          child: Text(
                            speed.toInt().toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (_isReady)
              if (!ReadyToStartPage.isChecked)
                Positioned(
                  left: 16,
                  top: 16,
                  child: IconButton(
                    onPressed: () {
                      drivingData.totalTime(stopwatchDuration);
                      disconnectFromFlutter();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CompletePage()));
                    },
                    icon: const Icon(Icons.cancel_outlined, color: Colors.blue),
                  ),
                ),
            if (_isReady)
              Positioned(
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: Container(
                          width: 175.0,
                          height: 175.0,
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
                          width: 75.0,
                          height: 75.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_isReady)
              Positioned(
                right: 16,
                bottom: 16,
                child: SliderWidget(
                  sliderValue: _sliderValue,
                  onSliderChanged: (value) {
                    setState(() {
                      _sliderValue = value;
                      if (_sliderValue > 0) {
                        gasPressed();
                        updateSliderState();
                      } else if (_sliderValue < 0) {
                        brakePressed();
                        updateSliderState();
                      } else if (_sliderValue == 0) {
                        noInput();
                        updateSliderState();
                      }
                    });
                  },
                  onSliderChangeEnd: (value) {
                    _sliderValue = value;
                    setState(() {
                      _sliderValue = 0.0;
                      updateSliderState();
                      noInput();
                    });
                  },
                ),
              ),
            if (_isReady && hasToClick)
              Positioned(
                left: 16,
                bottom: 16,
                child: ElevatedButton(
                  onPressed: () {
                    drtPressed();
                    drivingData.drtButtonPressed(stopwatchDRT);
                  },
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
                      width: 60,
                      height: 60,
                      child: Center(
                        child: Text("DRT"),
                      )),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
