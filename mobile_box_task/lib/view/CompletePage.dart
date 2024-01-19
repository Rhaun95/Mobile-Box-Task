import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_box_task/main.dart';
import 'package:mobile_box_task/view/Driving.dart';
import 'package:mobile_box_task/widget/Button.dart';
import 'package:provider/provider.dart';

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
              Text(
                "Gas pressed: ${drivingData.countGas} ",
                style: TextStyle(fontSize: 15, color: Colors.blue),
              ),
              Text(
                "Brake pressed : ${drivingData.countBrake}",
                style: TextStyle(fontSize: 15, color: Colors.blue),
              ),
              Text(
                "DRT pressed : ${drivingData.countDRT}",
                style: TextStyle(fontSize: 15, color: Colors.blue),
              ),
              Text(
                "Total Time: ${drivingData.elapsedTime.inMinutes.toString().padLeft(2, '0')}:${(drivingData.elapsedTime.inSeconds % 60).toString().padLeft(2, '0')}",
                style: TextStyle(fontSize: 15, color: Colors.blue),
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
