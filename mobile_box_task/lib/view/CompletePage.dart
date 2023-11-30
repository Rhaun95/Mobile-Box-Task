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
                "Compelet",
                style: TextStyle(fontSize: 24, color: Colors.blue),
              ),
              const SizedBox(height: 40),
              const Text(
                "Was hast du bis jetzt gemacht oder so ",
                style: TextStyle(fontSize: 14, color: Colors.blue),
              ),
              const SizedBox(height: 10),
              Button(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Home()));
                  },
                  text: "Back To Home Page"),
              const SizedBox(height: 10),
              Button(onPressed: () => exit(0), text: "Exit"),
            ],
          ),
        ),
      ),
    );
  }
}
