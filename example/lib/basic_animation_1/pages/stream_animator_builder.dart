import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'stream_value.dart';

final _log = new Logger('ui.app.dart');

class StreamAnimatorBuilder<T extends double> extends StatelessWidget {
  final StreamValue<T> streamValue;
  final Widget Function(double) builder;
  final Duration Function() durationCallback;
  final Curve curve;
  final animatorKey = AnimatorKey<double>();

  StreamAnimatorBuilder(
      {@required this.streamValue,
      @required this.builder,
      @required this.durationCallback,
      this.curve = Curves.easeInOut}) {
//    animatorKey
//      ..refreshAnimation(
//        tween: Tween<double>(begin: 0, end: 0),
//        duration: Duration(milliseconds: 300),
//        curve: curve,
//      );

    streamValue.stream.listen(
      (value) {
        double previousValue = streamValue.previousValue;
        double value = streamValue.value;

        Duration duration = Duration(milliseconds: 300);

        //durationCallback();
        _log.finest("Animation Duration: $duration");

        _log.finest(
            "ANIMATION VALUES IN StreamAnimationBuilder: previous: $previousValue , value: $value");
        if (previousValue == 0.0 && value == 0.0) return;
        animatorKey
          ..refreshAnimation(
            tween: Tween<double>(begin: previousValue, end: value),
            duration: duration,
            curve: curve,
          )
          ..triggerAnimation();
      },
    );
  }

  @override
  Widget build(BuildContext context) => Animator<double>(
      animatorKey: animatorKey,
      duration: Duration(milliseconds: 300),
      builder: (context, anim, child) => builder(anim.value));
}
