import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mobile_box_task/view/CompletePage.dart';
import 'package:provider/provider.dart';
import 'package:sensors/sensors.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:vibration/vibration.dart';

class Driving extends StatefulWidget {
  const Driving({super.key});

  @override
  _DrivingState createState() => _DrivingState();
}

class DrivingData extends ChangeNotifier {
  //-------- Datenlogging--------------------------------
  int countGas = 0;
  int countBrake = 0;
  int countDRT = 0;
  late String totalElapsedTime;
  List<int> drtTimes = [];
  late String meanDRT;

  brakeButtonPressed() {
    countBrake += 1;
    print("brake button pressed: ${countBrake}");
    // notifyListeners();
  }

  void gasButtonPressed() {
    countGas += 1;
    print("gas button pressed: ${countGas}");
  }

  void drtButtonPressed(Stopwatch stopwatch) {
    stopwatch.stop();
    drtTimes.add(stopwatch.elapsedMilliseconds);
    print('DRT pressed: ${drtTimes}');
    countDRT += 1;
    print('DRT pressed: ${countDRT}');
  }

// calculate mean of milliSeconds(int) in form 0.00s(String)
  String calculateDurationMean(List<int> list) {
    if (list.isNotEmpty) {
      double meanDuration =
          list.reduce((value, element) => value + element) / list.length;

      String res = "${(meanDuration / 1000).toStringAsFixed(2)}s";
      return res;
    }
    return "0s";
  }

// calculate
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    String milliseconds = (duration.inMilliseconds % 1000).toString();

    return '$minutes:$seconds:$milliseconds';
  }

  void totalTime(Stopwatch stopwatch) {
    stopwatch.stop();
    print('Duration: ${stopwatch.elapsed}');
    totalElapsedTime = formatDuration(stopwatch.elapsed);
    meanDRT = calculateDurationMean(drtTimes);
  }

  //--------------------------------------------------------
}

class _DrivingState extends State<Driving> {
  double _sliderValue = 3.0;
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

  Timer? gasTimer;
  Timer? brakeTimer;

  Stopwatch stopwatchDuration = new Stopwatch();
  Stopwatch stopwatchDRT = new Stopwatch();

  @override
  void initState() {
    super.initState();
    startCountdown(3);
    setHasToClickAfterRandomTime();
    socket = IO.io('http://box-task-server:3001', <String, dynamic>{
      // IO.io('http://192.168.178.22:3001', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

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
    });
  }

  void noGasPressed() {
    socket.emit("gas button state", false);
  }

  void gasPressed() {
    socket.emit("gas button state", true);
    gasTimer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      increaseSpeed();
    });
  }

  void increaseSpeed() {
    setState(() {
      socket.emit("gas button has been pressed", speed);
    });
  }

  void brakePressed() {
    brakeTimer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      decreaseSpeed();
    });
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
            // if (_isReady)
            //   Positioned(
            //     left: 16,
            //     bottom: 16,
            //     child: GestureDetector(
            //       onLongPressStart: (_) {
            //         brakeTimer = Timer.periodic(const Duration(milliseconds: 1),
            //             (timer) {
            //           decreaseSpeed();
            //         });
            //       },
            //       onLongPressEnd: (_) {
            //         brakeTimer?.cancel();
            //         accelerationFactor = 1;
            //       },
            //       child: ElevatedButton(
            //         onPressed: () {},
            //         style: ElevatedButton.styleFrom(
            //           foregroundColor: Colors.white,
            //           backgroundColor: Colors.blueGrey,
            //           padding: const EdgeInsets.all(16),
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(8.0),
            //           ),
            //           elevation: 4,
            //         ),
            //         child: const SizedBox(
            //             width: 60,
            //             height: 60,
            //             child: Center(
            //               child: Text("Brake"),
            //             )),
            //       ),
            //     ),
            //   ),
            if (_isReady)
              Positioned(
                right: 16,
                bottom: 16,
                child: SliderWidget(
                  sliderValue: _sliderValue,
                  onSliderChanged: (value) {
                    setState(() {
                      _sliderValue = value;
                    });
                  },
                  onSliderChangeEnd: (value) {
                    if (_sliderValue != 3.0) {
                      setState(() {
                        _sliderValue = 3.0;
                      });
                      print('Selected Level: $_sliderValue');
                    }
                  },
                ),
              ),
            // Positioned(
            //   right: 16,
            //   bottom: 16,
            //   child: GestureDetector(
            //     onLongPressStart: (_) {
            //       gasPressed();
            //       gasTimer = Timer.periodic(const Duration(milliseconds: 1),
            //           (timer) {
            //         increaseSpeed();
            //       });
            //     },
            //     onLongPressEnd: (_) {
            //       gasTimer?.cancel();
            //       accelerationFactor = 1;
            //       noGasPressed();
            //     },
            //     child: ElevatedButton(
            //       onPressed: () {},
            //       style: ElevatedButton.styleFrom(
            //         foregroundColor: Colors.white,
            //         backgroundColor: Colors.blueGrey,
            //         padding: const EdgeInsets.all(16),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(8.0),
            //         ),
            //         elevation: 4,
            //       ),
            //       child: const SizedBox(
            //           width: 60,
            //           height: 60,
            //           child: Center(
            //             child: Text("Gas"),
            //           )),
            //     ),
            //   ),
            // ),

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
