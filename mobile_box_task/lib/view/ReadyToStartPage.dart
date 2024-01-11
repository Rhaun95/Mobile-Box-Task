import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_box_task/view/Driving.dart';
import 'package:mobile_box_task/view/Home.dart';
import 'package:mobile_box_task/widget/Button.dart';

class ReadyToStartPage extends StatelessWidget {
  const ReadyToStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Center(child: Text('Moblie Box Task')),
        ),
        body: Stack(
          children: [
            Positioned(
              left: 16,
              top: 16,
              child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Home()));
                },
                icon: const Icon(Icons.cancel_outlined, color: Colors.blue),
              ),
            ),
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Ready To Start Habibi?",
                    style: TextStyle(fontSize: 40, color: Colors.blue),
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
                                    builder: (context) => const Driving()));
                          },
                          text: "Start"),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
