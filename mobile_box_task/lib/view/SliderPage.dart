import 'package:flutter/material.dart';

class SliderWidget extends StatelessWidget {
  final double sliderValue;
  final ValueChanged<double> onSliderChanged;
  final ValueChanged<double> onSliderChangeEnd;

  SliderWidget({
    required this.sliderValue,
    required this.onSliderChanged,
    required this.onSliderChangeEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selected Level: $sliderValue',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
          ],
        ),
        SizedBox(width: 20),
        RotatedBox(
          quarterTurns: 3, // Rotate the slider vertically
          child: Slider(
            activeColor: Colors.red,
            secondaryActiveColor: Colors.black.withOpacity(0.5),
            thumbColor: Colors.blue.withOpacity(0.5),
            inactiveColor: Colors.red,
            overlayColor:
                MaterialStateProperty.all(Colors.red.withOpacity(0.5)),
            value: sliderValue,
            min: 1.0,
            max: 5.0,
            divisions: 4,
            onChanged: onSliderChanged,
            onChangeEnd: onSliderChangeEnd,
          ),
        ),
      ],
    );
  }
}
