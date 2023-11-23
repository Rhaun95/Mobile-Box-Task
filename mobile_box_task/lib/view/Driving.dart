import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Driving extends StatefulWidget {
  const Driving({super.key});

  @override
  State<Driving> createState() => _DrivingState();
}

class _DrivingState extends State<Driving> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          body: Stack(
            children: [
              Positioned(
                  left: 16,
                  bottom: 16,
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueGrey,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 4,
                      ),
                      child: const SizedBox(
                          width: 40,
                          height: 40,
                          child: Center(
                            child: Text('Break'),
                          )))),
              Positioned(
                  right: 16,
                  bottom: 16,
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueGrey,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 4,
                      ),
                      child: const SizedBox(
                          width: 40,
                          height: 40,
                          child: Center(
                            child: Text('Gas'),
                          )))),
            ],
          ),
        ));
  }
}
