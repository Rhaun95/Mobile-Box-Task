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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotatedBox(
            quarterTurns: 3,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 8.0,
                trackShape: const RoundedRectSliderTrackShape(),
                thumbShape: const SquareSliderThumbShape(
                  thumbRadius: 32.0,
                ),
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.height - 32,
                child: Slider(
                  activeColor: Colors.orange,
                  inactiveColor: Colors.orange,
                  thumbColor: Colors.blue,
                  value: sliderValue,
                  min: -50.0,
                  max: 50.0,
                  divisions: 100,
                  onChanged: onSliderChanged,
                  onChangeEnd: onSliderChangeEnd,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SquareSliderThumbShape extends SliderComponentShape {
  final double thumbRadius;

  const SquareSliderThumbShape({
    required this.thumbRadius,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final Paint paint = Paint()
      ..color = sliderTheme.thumbColor!
      ..style = PaintingStyle.fill;

    final double radius = thumbRadius;

    final RRect thumbRect = RRect.fromRectAndRadius(
      Rect.fromCircle(center: center, radius: radius),
      Radius.circular(8.0),
    );

    canvas.drawRRect(thumbRect, paint);
  }
}
