import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_box_task/dataLoggin/evaluationData.dart';

class DrivingHelper extends ChangeNotifier {
  static late String roomName;

  EvaluationData ed = new EvaluationData();

  String generateRandomString() {
    const String characters = '0123456789';
    Random random = Random();
    String randomString = '';

    for (int i = 0; i < 6; i++) {
      int randomIndex = random.nextInt(characters.length);
      randomString += characters[randomIndex];
    }

    return randomString;
  }

  void drtButtonPressed(Stopwatch stopwatch) {
    stopwatch.stop();
    ed.getDrtTimes().add(stopwatch.elapsedMilliseconds);
    print('DRT pressed: ${ed.getCountDRT()}');
    ed.setCountDRT(ed.getCountDRT() + 1);
    print('DRT pressed: ${ed.getCountDRT()}');
  }

// calculate mean of milliSeconds(int) in form 0.00s(String)
  void calculateDurationMean() {
    if (ed.getDrtTimes().isNotEmpty) {
      double meanDuration =
          ed.getDrtTimes().reduce((value, element) => value + element) /
              ed.getDrtTimes().length;

      String res = "${(meanDuration / 1000).toStringAsFixed(2)}s";
      ed.setMeanDRT(res);
    } else {
      ed.setMeanDRT("0s");
    }
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
  }

  Future<void> convertDataToJsonAndsendTojson() async {
    List<dynamic> data = [
      roomName,
      ed.getCountDRT(),
      ed.getMeanDRT(),
      ed.getTotalElapsedTime(),
      ed.getMaxIntensityError(),
      ed.getDrtTimes(),
    ];

    var json_data = {
      "RaumCode": data[0],
      "countDRT": data[1],
      "meanDRT": data[2],
      "totalElapsedTime": data[3],
      "maxIntensityError": data[4],
      "drtTimes": data[5],
    };

    try {
      final file = File(
          'G:\\programm\\MBT\\bp2324-mobile-box-task\\mobile_box_task\\assets\\data.json');
      await file.writeAsString(json.encode(json_data));
      print("Data written to file successfully.");
    } catch (e) {
      print("Error writing to file: $e");
    }

    print("ja wir kommen von hier vorbei habibi");
  }

  // Map<String, dynamic> toJson() => {
  //       'countDRT': (ed.getCountDRT()).toString(),
  //       'meanDRT': ed.getMeanDRT(),
  //       'elapsedTime': ed.getTotalElapsedTime(),
  //     };

//   void _generateJsonFile(String username) {
//   if (username != null) {
//     Map<String, dynamic> userJson = {"name": username};
//     String jsonString = jsonEncode(userJson);

//     File file = File("user_data.json");
//     file.writeAsStringSync(jsonString);

//     print('JSON-Datei erstellt: ${file.path}');
//   } else {
//     print('Unerwarteter Fehler: Der Benutzername ist null.');
//   }
// }
}
