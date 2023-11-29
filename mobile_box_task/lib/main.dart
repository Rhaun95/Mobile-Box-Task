import 'package:flutter/material.dart';
import 'package:mobile_box_task/view/Home.dart';

void main() {
  runApp(MBTApp());
}

class MBTApp extends StatelessWidget {
  const MBTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Center(child: Text('Startseite Moblie Box Task')),
        ),
        body: const Home(),
      ),
    );
  }
}
