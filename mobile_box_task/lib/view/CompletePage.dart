// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_box_task/main.dart';
import 'package:mobile_box_task/view/ReadyToStartPage.dart';
import 'package:mobile_box_task/view/showData.dart';
import 'package:mobile_box_task/widget/Button.dart';
import 'package:provider/provider.dart';

import '../helper/DrivingHelper.dart';

class CompletePage extends StatefulWidget {
  const CompletePage({super.key});

  @override
  _CompletePageState createState() => _CompletePageState();
}

class _CompletePageState extends State<CompletePage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DrivingHelper drivingData = Provider.of<DrivingHelper>(context);
    //print(drivingData.toJson());
    drivingData.convertDataToJsonAndsendTojson();

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF092735), Color(0xFF0F111A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Complete",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!ReadyToStartPage.isChecked)
                      Text(
                        "Total Time: ${drivingData.ed.getTotalElapsedTime()}",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    Text(
                      "Mistakes: ${drivingData.ed.getExceedsBoxFrame().length} ",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      "Max intensity misteakes: ${drivingData.ed.getMaxIntensityError()} ",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      "DRT pressed : ${drivingData.ed.getCountDRT()}",
                      style: const TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "DRT mean : ${drivingData.ed.getMeanDRT()}",
                      style: const TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Button(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MBTApp(),
                            ),
                          );
                        },
                        text: "Home",
                      ),
                      const SizedBox(height: 10),
                      Button(
                        onPressed: () => exit(0),
                        text: "Exit",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
