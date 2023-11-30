import 'package:flutter/material.dart';
import 'package:mobile_box_task/view/Driving.dart';
import 'package:mobile_box_task/widget/Button.dart';

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
            Text(
              'Dies ist eine Anweisung.',
              style: Theme.of(context).textTheme.headline4,
            ),
            Button(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Driving()));
                },
                text: "Continue")
          ],
        ),
      ),
    );
  }
}
