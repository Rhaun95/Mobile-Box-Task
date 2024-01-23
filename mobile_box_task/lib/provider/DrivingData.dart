import 'dart:math';

import 'package:flutter/material.dart';

String generateRandomString() {
  const String characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
  Random random = Random();
  String randomString = '';

  for (int i = 0; i < 7; i++) {
    int randomIndex = random.nextInt(characters.length);
    randomString += characters[randomIndex];
  }

  return randomString;
}

class DrivingData extends ChangeNotifier {
  int countGas = 0;
  int countBrake = 0;
  int countDRT = 0;
  late String totalElapsedTime;
  List<int> drtTimes = [];
  late String meanDRT;

  static String roomName = generateRandomString();

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
}
