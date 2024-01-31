import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_box_task/helper/DrivingHelper.dart';
import 'package:mobile_box_task/view/Driving.dart';
import 'package:mobile_box_task/view/Home.dart';
import 'package:mobile_box_task/widget/Button.dart';
import 'package:provider/provider.dart';

class ReadyToStartPage extends StatefulWidget {
  const ReadyToStartPage({Key? key}) : super(key: key);
  static bool isChecked = false;

  @override
  State<ReadyToStartPage> createState() => _ReadyToStartPageState();
}

class _ReadyToStartPageState extends State<ReadyToStartPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('YOUR ROOM: ${DrivingHelper.roomName}');

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF092735), Color(0xFF0F111A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF06B6D4),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          const Text(
                            'Lobby',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          buildTimerSlider(),
                        ],
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(32),
                              child: Text(
                                "Enter the generated code into the input field on the web interface to connect the Mobile Box Task to it.",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                '${DrivingHelper.roomName}',
                                style: const TextStyle(
                                    fontSize: 40, color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: double.infinity,
                          child: Button(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Driving(),
                                ),
                              );
                            },
                            text: "Continue",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTimerSlider() {
    return Column(
      children: [
        const Positioned(
          right: 15,
          top: 55,
          child: Text(
            "Use Timer",
            style: TextStyle(fontSize: 15, color: Colors.white),
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
      ],
    );
  }
}
