// The point here is that we don't need any state
// in the Widget because the bloc
// should contain it all. A general rule is one or more blocs per screen.t';
import 'package:flutter/material.dart';

import 'linear_progress_painter.dart';
import 'stream_animator_builder.dart';
import 'stream_value.dart';

//A more universal bloc ready ProgressWidget
class ProgressWidget extends StatelessWidget {
  ProgressWidget(
      {@required this.streamValue,
      @required this.durationCallback,
      this.curve = Curves.easeInOut});

  final ReadStreamValue<double> streamValue;
  final Duration Function() durationCallback;
  final Curve curve;

  @override
  Widget build(BuildContext context) => StreamAnimatorBuilder<double>(
        streamValue: streamValue,
        durationCallback: () => durationCallback(),
        curve: curve,
        builder: (value) => CustomPaint(
          painter: LinearProgressPainter(
            value: value / 100.0,
          ),
        ),
      );
}
