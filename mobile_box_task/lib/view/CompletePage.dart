import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_box_task/view/Home.dart';
import 'package:mobile_box_task/widget/Button.dart';

class CompeletPage extends StatelessWidget {
  const CompeletPage({super.key});

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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home()));
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
