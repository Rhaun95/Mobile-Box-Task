import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_box_task/view/ReadyToStartPage.dart';
import 'package:mobile_box_task/widget/Button.dart';
import 'package:mobile_box_task/widget/AnimatedPhone.dart';

class InstructionPage extends StatelessWidget {
  const InstructionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Instruction Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Text(
                    'In the following you are going to go through the mobile Box Task. Please try to keep the blue box inside of the outer border and dont let it get smaller then the inner border, which is displayed in the web-interface. To achieve this, you can tilt your smartphone to the left or right to steer the box along the x-axis. By pushing the buttons in the bottom corners you can either accelerate or brake and make the box larger or smaller.',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Now please hold your smartphone horizontally to begin with the Mobile Box Task.',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // const SizedBox(width: 350, height: 200, child: Placeholder()),
                  Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 100, // Adjust width as needed
                        height: 100, // Adjust height as needed
                        child: AnimatedPhone(),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Button(
                    onPressed: () {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.landscapeLeft,
                        DeviceOrientation.landscapeRight,
                      ]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReadyToStartPage(),
                        ),
                      );
                    },
                    text: "Continue",
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
