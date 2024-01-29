import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_box_task/dataLoggin/evaluationData.dart';

class DrivingHelper extends ChangeNotifier {
  static late String roomName;

  EvaluationData ed = new EvaluationData();

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

  // brakeButtonPressed() {
  //   countBrake += 1;
  //   print("brake button pressed: ${countBrake}");
  //   // notifyListeners();
  // }

  // void gasButtonPressed() {
  //   countGas += 1;
  //   print("gas button pressed: ${countGas}");
  // }

  void drtButtonPressed(Stopwatch stopwatch) {
    stopwatch.stop();
    ed.getDrtTimes().add(stopwatch.elapsedMilliseconds);
    print('DRT pressed: ${ed.getCountDRT()}');
    ed.setCountDRT(ed.getCountDRT() + 1);
    print('DRT pressed: ${ed.getCountDRT()}');
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
    ed.setTotalElapsedTime(formatDuration(stopwatch.elapsed));
    ed.setMeanDRT(calculateDurationMean(ed.getDrtTimes()));
  }

  Future<void> convertDataToJsonAndsendTojson() async {
    List<dynamic> data = [
      ed.getCountDRT(),
      ed.getMeanDRT(),
      ed.getTotalElapsedTime()
    ];

    var json_data = {
      "countDRT": "dsad",
      "meanDRT": "ed.getMeanDRT()",
      "totalElapsedTime": "ed.getTotalElapsedTime()",
    };

    try {
      final file = File('../dataLoggin/DataToserver.json');
      await file.writeAsString(json.encode(json_data));
      print("Data written to file successfully.");
    } catch (e) {
      print("Error writing to file: $e");
    }

    // }
    // File('G:\\programm\\MBT\\bp2324-mobile-box-task\\mobile_box_task\\lib\\dataLoggin\\.json')
    //     .writeAsString(json.encode(json_data));
    print("ja wir kommen von hier vorbei");
  }
}
