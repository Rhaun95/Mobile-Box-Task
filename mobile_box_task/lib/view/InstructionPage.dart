import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_box_task/view/ReadyToStartPage.dart';
import 'package:mobile_box_task/widget/Button.dart';

class RotatingOrangePhone extends StatefulWidget {
  const RotatingOrangePhone({Key? key}) : super(key: key);

  @override
  _RotatingOrangePhoneState createState() => _RotatingOrangePhoneState();
}

class _RotatingOrangePhoneState extends State<RotatingOrangePhone>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(const Duration(seconds: 1), () {
            _controller.reverse();
          });
        }
      });
    _controller.repeat();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: -0.25).animate(_controller),
      child: const Icon(
        Icons.phone_android,
        color: Colors.orange,
        size: 150,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class InstructionPage extends StatelessWidget {
  const InstructionPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return Scaffold(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    'Instruction',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Text(
                                'In the following, you will go through the Mobile Box Task. Your task is to keep the blue box between the two orange borders. The blue box will appear when you use the slider on the right side of the screen to either accelerate by dragging it up or brake by dragging it down. You can also tilt your phone from left to right to move the box on the x-axis.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "This is necessary because otherwise, you wouldn't be able to keep the blue box in position. This is due to a disruptive factor that is permanently applied to the box's size and speed.",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Now, go to the next page and hold your phone horizontally as if it were a steering wheel. Then, press the start button, and the Mobile Box Task will begin.",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 150,
                            height: 150,
                            child: RotatingOrangePhone(),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Button(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReadyToStartPage(),
                      ),
                    );
                  },
                  text: "Continue",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
