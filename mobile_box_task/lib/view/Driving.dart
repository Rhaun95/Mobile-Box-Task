import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mobile_box_task/view/CompletePage.dart';
import 'package:mobile_box_task/view/ReadyToStartPage.dart';
import 'package:sensors/sensors.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:vibration/vibration.dart';

class Driving extends StatefulWidget {
  const Driving({super.key});

  @override
  _DrivingState createState() => _DrivingState();
}

class _DrivingState extends State<Driving> {
  List<double> accelerometer = [0.0, 0.0, 0.0];
  List<double> gyroscope = [0.0, 0.0, 0.0];
  double boxPosition = 0;
  bool _isReady = false;
  late Timer _timer;
  late IO.Socket socket;
  double speed = 0;
  double accelerationFactor = 1;
  bool isGasPressed = false;
  bool isBrakePressed = false;
  bool hasToClick = false;
  int count = 0;

  @override
  void initState() {
    super.initState();
    startCountdown(3);
    setHasToClickAfterRandomTime();
    socket = IO.io('http://localhost:3001', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

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

    socket.onDisconnect((_) {
      print('Disconnected from server');
    });

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

  @override
  void dispose() {
    _timer.cancel();
    socket.disconnect();
    super.dispose();
  }

  Timer? gasTimer;
  Timer? brakeTimer;

  void increaseSpeed() {
    setState(() {
      socket.emit("gas button has been pressed", speed);
    });
  }

  void setHasToClickAfterRandomTime() {
    Timer.periodic(Duration(seconds: 3 + Random().nextInt(3)), (timer) {
      setState(() {
        hasToClick = true;
        Vibration.vibrate(duration: 100);
        timer.cancel();
      });
    });
  }

  void decreaseSpeed() {
    setState(() {
      socket.emit("brake button pressed", speed);
    });
  }

  void noGasPressed() {
    socket.emit("gas button state", false);
  }

  void gasPressed() {
    socket.emit("gas button state", true);
  }

  @override
  Widget build(BuildContext context) {
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
                        width: speed,
                        height: speed,
                        color: Colors.blue,
                        child: Center(
                          child: Text(
                            speed.toInt().toString(),
                            style: TextStyle(
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
                left: 16,
                bottom: 16,
                child: GestureDetector(
                  onLongPressStart: (_) {
                    brakeTimer = Timer.periodic(const Duration(milliseconds: 1),
                        (timer) {
                      decreaseSpeed();
                    });
                  },
                  onLongPressEnd: (_) {
                    brakeTimer?.cancel();
                    accelerationFactor = 1;
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
                    child: const SizedBox(
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
                    gasPressed();
                    gasTimer = Timer.periodic(const Duration(milliseconds: 1),
                        (timer) {
                      increaseSpeed();
                    });
                  },
                  onLongPressEnd: (_) {
                    gasTimer?.cancel();
                    accelerationFactor = 1;
                    noGasPressed();
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
                    child: const SizedBox(
                        width: 60,
                        height: 60,
                        child: Center(
                          child: Text("Gas"),
                        )),
                  ),
                ),
              ),
            if (_isReady && hasToClick)
              Positioned(
                right: 16,
                bottom: 100,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      hasToClick = false;
                      setHasToClickAfterRandomTime();
                    });
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
