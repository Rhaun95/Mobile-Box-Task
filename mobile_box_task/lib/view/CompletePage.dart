import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_box_task/main.dart';
import 'package:mobile_box_task/widget/Button.dart';

class CompletePage extends StatelessWidget {
  const CompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Center(child: Text('Moblie Box Task')),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Complete",
                style: TextStyle(fontSize: 40, color: Colors.blue),
              ),
              const SizedBox(height: 20),
              Text(
                "Querfehler: 123 ",
                style: TextStyle(fontSize: 24, color: Colors.blue),
              ),
              Text(
                "Längsfehler: 21",
                style: TextStyle(fontSize: 24, color: Colors.blue),
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
                      text: "Back To Home Page"),
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
