import 'package:flutter/material.dart';
import 'package:mobile_box_task/provider/SocketProvider.dart';
import 'package:mobile_box_task/view/Home.dart';
import 'package:provider/provider.dart';

import 'provider/DrivingData.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => DrivingData()),
    ChangeNotifierProvider(create: (_) => SocketProvider()),
  ], child: const MBTApp()));
}

class MBTApp extends StatelessWidget {
  const MBTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DrivingData(),
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Center(child: Text('Startseite Moblie Box Task')),
          ),
          body: const Home(),
        ),
      ),
    );
  }
}
