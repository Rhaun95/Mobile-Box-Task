import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_box_task/provider/DrivingData.dart';
import 'package:mobile_box_task/view/InstructionPage.dart';
import 'package:mobile_box_task/widget/Button.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    print('YOUR ROOM: ${DrivingData.roomName}');

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Center(
        child: SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button(
                  onPressed: () {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                      DeviceOrientation.portraitDown,
                    ]);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InstructionPage()));
                  },
                  text: "Start")
            ],
          ),
        ),
      ),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Button(onPressed: () => exit(0), text: "Exit")]),
    ]);
  }
}
