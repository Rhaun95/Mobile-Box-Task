import 'dart:async';

import 'package:flutter/material.dart';

class AnimatedPhone extends StatefulWidget {
  @override
  _AnimatedPhoneState createState() => _AnimatedPhoneState();
}

class _AnimatedPhoneState extends State<AnimatedPhone>
    with TickerProviderStateMixin {
  bool isRotated = false;
  late Timer _timer;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(seconds: 1), // Set your desired duration
      vsync: this,
    );

    _timer = Timer.periodic(Duration(milliseconds: 1500), (Timer timer) {
      _rotatePhone();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RotationTransition(
          turns: isRotated
              ? Tween(begin: 0.0, end: -0.25).animate(_animationController)
              : AlwaysStoppedAnimation(0),
          child: Icon(
            Icons.phone_android,
            size: 100,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  void _rotatePhone() {
    setState(() {
      isRotated = !isRotated;
      _animationController.reset();
      _animationController.forward(); // Start the animation from the beginning
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Timer cancellation
    _animationController.dispose(); // Animation controller disposal
    super.dispose();
  }
}
