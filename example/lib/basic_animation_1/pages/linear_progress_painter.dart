import 'package:flutter/material.dart';
//import 'package:logging/logging.dart';

//final _log = new Logger('painter.linear_progress_painter.dart');

///[value] has to be between 0 and 1. With 1 == 100 %
class LinearProgressPainter extends CustomPainter {
  final double value;
  final Color backgroundColor;
  final Paint painter;
  final Paint backgroundPainter;
  final Gradient gradient;
  final Gradient backgroundGradient;
  final bool outline;

  LinearProgressPainter(
      {@required this.value,
      this.backgroundColor = const Color(0xFF5e6572),
      this.gradient = const LinearGradient(
        colors: [const Color(0xFFb3b6bc), const Color(0xFFFFFFFF)],
        stops: [0.0, 1],
      ),
      this.backgroundGradient = const LinearGradient(
        colors: [const Color(0xFF3d4044), const Color(0xFF4d5156)],
        stops: [0.0, 1],
      ),
      this.outline = false})
      : painter = Paint(),
        backgroundPainter = Paint() {
    painter.color = Colors.white;
    backgroundPainter.color = Colors.black;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

//    _log.finest("PAINTER ANIMATION VALUES: IN: $value ");

    final double width = size.width * value;

    if (outline) {
      painter
        ..strokeWidth = size.height / 10
        ..style = PaintingStyle.stroke;
    }

    //background
    var backgroundRect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    backgroundPainter
      ..shader = backgroundGradient?.createShader(backgroundRect);
    canvas.drawRect(backgroundRect, backgroundPainter);

    var rect = Rect.fromLTRB(0.0, 0.0, width, size.height);
    painter..shader = gradient?.createShader(rect);
    canvas.drawRect(rect, painter);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
