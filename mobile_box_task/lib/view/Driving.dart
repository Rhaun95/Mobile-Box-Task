// ignore_for_file: library_prefixes, library_private_types_in_public_api

import 'dart:async';
import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_box_task/helper/DrivingHelper.dart';
import 'package:mobile_box_task/view/CompletePage.dart';
import 'package:mobile_box_task/view/ReadyToStartPage.dart';
import 'package:mobile_box_task/view/SliderPage.dart';
import 'package:provider/provider.dart';
import 'package:sensors/sensors.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:vibration/vibration.dart';

import '../provider/SocketProvider.dart';

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
  double speed = 0.0;
  bool isGasPressed = false;
  bool isBrakePressed = false;
  bool hasToClick = false;
  int count = 0;
  int countTimerOption = 0;
  late DrivingHelper drivinghelper;

  Timer? gasTimer;
  Timer? brakeTimer;

  Stopwatch stopwatchDuration = Stopwatch();
  Stopwatch stopwatchDRT = Stopwatch();

  @override
  void initState() {
    super.initState();
    drivinghelper = Provider.of<DrivingHelper>(context, listen: false);
    socket = Provider.of<SocketProvider>(context, listen: false).getSocket();
    startCountdown(3);
    setHasToClickAfterRandomTime();
    socket.emit("join room", DrivingHelper.roomName);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    stopwatchDuration.start();

    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        if (-10 <= boxPosition && boxPosition <= 10) {
          if (boxPosition < 0) {
            boxPosition = event.y.toDouble();
          } else {
            boxPosition = event.y.toDouble();
          }
        } else {
          boxPosition = 0;
        }

        socket.emit('boxPosition', {
          'roomName': DrivingHelper.roomName,
          'boxPosition': boxPosition,
        });
      });
    });

    socket.onConnect((_) {
      print('Connected to server');
    });
    socket.on('new number', (receivedSpeed) {
      setState(() {
        speed = receivedSpeed["speed"];
      });
    });

    // socket.onDisconnect((_) {
    //   print('Disconnected from server');
    // });

    //     socket.on('disconnect', (_) {
    //   print('Disconnected from server');
    // });
  }

  void startCountdown(int duration) {
    count = duration;
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        if (count > 0) {
          count--;
        } else {
          timer.cancel();
          _isReady = true;
          if (ReadyToStartPage.isChecked) startCountdownForTimer(4);
        }
      });
    });
  }

  //!Countdown
  void startCountdownForTimer(int duration) {
    _isReady = true;
    countTimerOption = duration;
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        if (countTimerOption > 0) {
          countTimerOption--;
        } else {
          drivinghelper.calculateDurationMean();

          disconnectFromFlutter();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CompletePage()));
          timer.cancel();
        }
      });
    });
  }

  void disconnectFromFlutter() {
    socket.emit('leaveRoom', {'roomName': DrivingHelper.roomName});
    speed = 0;
    socket.emit('disconnect');
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
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
      socket.emit("brake button state",
          {'roomName': DrivingHelper.roomName, 'isBrakePressed': true});
      socket.emit("brake button pressed",
          {'roomName': DrivingHelper.roomName, 'speed': speed});
    });
  }

  void increaseSpeed() {
    setState(() {
      socket.emit("gas button state",
          {'roomName': DrivingHelper.roomName, 'isGasPressed': true});
      socket.emit("gas button has been pressed", {
        'roomName': DrivingHelper.roomName,
        'speed': speed,
        'sliderValue': _sliderValue
      });
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
      socket.emit("slider change",
          {'roomName': DrivingHelper.roomName, 'sliderValue': _sliderValue});
    });
  }

  void noInput() {
    gasTimer!.cancel();
    brakeTimer!.cancel();
    socket.emit("gas button state",
        {'roomName': DrivingHelper.roomName, 'isGasPressed': false});
    socket.emit("brake button state",
        {'roomName': DrivingHelper.roomName, 'isBrakePressed': false});
  }

  @override
  Widget build(BuildContext context) {
    DrivingHelper drivingData = Provider.of<DrivingHelper>(context);

    return Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(builder: (context) {
          return Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF092735), Color(0xFF0F111A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                if (!_isReady)
                  Center(
                    child: Text(
                      '$count',
                      style: const TextStyle(fontSize: 60, color: Colors.blue),
                    ),
                  ),
                if (_isReady)
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        'Room Name: ${DrivingHelper.roomName}',
                        style:
                            const TextStyle(fontSize: 20, color: Colors.blue),
                      ),
                    ),
                  ),
                if (ReadyToStartPage.isChecked && _isReady)
                  Positioned(
                    top: 36,
                    left: MediaQuery.of(context).size.width * 0.49,
                    child: Text(
                      '$countTimerOption',
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
                            width: speed,
                            height: speed,
                            color: const Color(0xFF1d4ed8),
                          ),
                        ),
                        Center(
                          child: Text(
                            speed.toInt().toString() + ' Km/h',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_isReady && !ReadyToStartPage.isChecked)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: InkWell(
                      onTap: () {
                        drivingData.totalTime(stopwatchDuration);
                        drivingData.calculateDurationMean();
                        disconnectFromFlutter();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CompletePage(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                if (_isReady) //!äußere Begrenzung
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
                                  color: Colors.orange,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ), //!innere Begrenzung
                          Positioned(
                            left: 50,
                            top: 50,
                            child: Container(
                              width: 75.0,
                              height: 75.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.orange,
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
                        backgroundColor: Colors.blue,
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
          );
        }));
  }
}
