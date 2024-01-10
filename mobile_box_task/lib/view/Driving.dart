import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Driving extends StatefulWidget {
  const Driving({Key? key}) : super(key: key);

  @override
  _DrivingState createState() => _DrivingState();
}

class _DrivingState extends State<Driving> {
  late Timer _timer;
  late IO.Socket socket;
  int speed = 0;
  int count = 3;
  double accelerationFactor = 50.0;
  bool isGasPressed = false;
  bool isBrakePressed = false;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    startCountdown();
    socket = IO.io('http://localhost:3001', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
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
          ],
        ),
      ),
    );
  }
}
