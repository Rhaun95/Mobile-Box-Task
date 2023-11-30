import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_box_task/view/InstructionPage.dart';
import 'package:mobile_box_task/widget/Button.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Center(
        child: SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button(
                  onPressed: () {
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
