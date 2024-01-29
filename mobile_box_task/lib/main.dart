import 'package:flutter/material.dart';
import 'package:mobile_box_task/view/Home.dart';
import 'package:provider/provider.dart';

import 'MO/DrivingHelper.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => DrivingHelper()),
  ], child: const MBTApp()));
}

class MBTApp extends StatelessWidget {
  const MBTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DrivingHelper(),
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
