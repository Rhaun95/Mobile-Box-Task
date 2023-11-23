import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_box_task/view/Driving.dart';

class Home extends StatelessWidget {
  // goToMBT(BuildContext context) {
  //   Navigator.push(context, MaterialPageRoute(builder: (context) => Driving()));
  // }

  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Driving()));
                  },
                  child: Text("Start"))
            ],
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(onPressed: () => exit(0), child: const Text("Exit"))
        ]),
      ]),
    );
  }
}
