import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_box_task/main.dart';
import 'package:mobile_box_task/view/ReadyToStartPage.dart';
import 'package:mobile_box_task/widget/Button.dart';
import 'package:provider/provider.dart';

import '../provider/DrivingData.dart';

class CompletePage extends StatelessWidget {
  const CompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    DrivingData drivingData = Provider.of<DrivingData>(context);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Center(child: Text('Moblie Box Task')),
        ),
        body: Center(
          child: Column(
            children: [
              const Text(
                "Complete",
                style: TextStyle(fontSize: 40, color: Colors.blue),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "mistakes: ${drivingData.countGas} ",
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  ),
                  const SizedBox(width: 10),
                  if (!ReadyToStartPage.isChecked)
                    Text(
                      "Total Time: ${drivingData.totalElapsedTime}",
                      style: TextStyle(fontSize: 15, color: Colors.blue),
                    ),
                  if (ReadyToStartPage.isChecked)
                    Text(
                      "Total Time: 01:20:000",
                      style: TextStyle(fontSize: 15, color: Colors.blue),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "DRT pressed : ${drivingData.countDRT}",
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "DRT mean : ${drivingData.meanDRT}",
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button(
                      onPressed: () {
                        //Change the orientation back to portrait
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                          DeviceOrientation.portraitDown,
                        ]);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MBTApp()));
                      },
                      text: "Home"),
                  const SizedBox(width: 50),
                  Button(onPressed: () => exit(0), text: "Exit"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
