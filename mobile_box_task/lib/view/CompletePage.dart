import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_box_task/main.dart';
import 'package:mobile_box_task/view/ReadyToStartPage.dart';
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
    print(drivingData.toJson());

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
                    "mistakes: ${drivingData.ed.getExceedsBoxFrame().length} ",
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  ),
                  const SizedBox(width: 10),
                  if (ReadyToStartPage.isChecked)
                    Text(
                      "Total Time: 01:20:000",
                      style: TextStyle(fontSize: 15, color: Colors.blue),
                    ),
                  if (!ReadyToStartPage.isChecked)
                    Text(
                      "Total Time: ${drivingData.ed.getTotalElapsedTime()}",
                      style: TextStyle(fontSize: 15, color: Colors.blue),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "DRT pressed : ${drivingData.ed.getCountDRT()}",
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "DRT mean : ${drivingData.ed.getMeanDRT()}",
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
