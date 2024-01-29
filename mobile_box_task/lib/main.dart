import 'package:flutter/material.dart';
import 'package:mobile_box_task/provider/SocketProvider.dart';
import 'package:mobile_box_task/view/Home.dart';
import 'package:provider/provider.dart';

import 'helper/DrivingHelper.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => DrivingHelper()),
    ChangeNotifierProvider(create: (_) => SocketProvider()),
  ], child: const MBTApp()));
}

class MBTApp extends StatelessWidget {
  const MBTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DrivingHelper(),
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'DaytonaPro'),
        home: Scaffold(
          body: const Home(),
        ),
      ),
    );
  }
}
