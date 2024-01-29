import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_box_task/provider/DrivingData.dart';
import 'package:mobile_box_task/view/Driving.dart';
import 'package:mobile_box_task/view/Home.dart';
import 'package:mobile_box_task/widget/Button.dart';
import 'package:provider/provider.dart';

class ReadyToStartPage extends StatefulWidget {
  const ReadyToStartPage({super.key});
  static bool isChecked = false;

  @override
  State<ReadyToStartPage> createState() => _ReadyToStartPageState();
}

class _ReadyToStartPageState extends State<ReadyToStartPage> {
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
            const Positioned(
              right: 15,
              top: 55,
              child: Text(
                "with Timer",
                style: TextStyle(fontSize: 15, color: Colors.blue),
              ),
            ),
            Positioned(
              right: 16,
              top: 16,
              child: CupertinoSwitch(
                activeColor: Colors.blue,
                value: ReadyToStartPage.isChecked,
                onChanged: (value) {
                  setState(() {
                    ReadyToStartPage.isChecked = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Write the Code in browser and press the button to start",
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                  SizedBox(height: 30),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      '${DrivingData.roomName}',
                      style: TextStyle(fontSize: 40, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Button(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Driving(),
                              ),
                            );
                          },
                          text: "Start",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
