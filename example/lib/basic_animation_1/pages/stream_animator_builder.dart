import 'package:animator/animator.dart';
import 'package:elm_bluetooth_bloc/model/units/unit.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:utilities/utilities.dart' show StreamValue;

final _log = new Logger('ui.app.dart');

class StreamAnimatorBuilder<T extends Unit> extends StatelessWidget {
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
    animatorKey
      ..refreshAnimation(
        tween: Tween<double>(begin: 0, end: 0),
        duration: Duration(milliseconds: 300),
        curve: curve,
      );

    streamValue.stream.listen(
      (value) {
        double previousValue = double.parse(streamValue.previousValue.value);
        double value = double.parse(streamValue.value.value);

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

//Animator<double>(
//tweenMap: {
//"opacityAnim": Tween<double>(begin: 0.5, end: 1),
//"rotationAnim": Tween<double>(begin: 0, end: 2 * pi),
//"translateAnim":
//Tween<Offset>(begin: Offset.zero, end: Offset(1, 0)),
//},
//cycles: 3,
//duration: Duration(seconds: 2),
//endAnimationListener: (anim) => print("animation finished"),
//animatorKey: animatorKey,
//builder: (context, anim, child) => FadeTransition(
//opacity: anim.getAnimation("opacityAnim"),
//child: FractionalTranslation(
//translation: anim.getValue("translateAnim"),
//child: _flutterLog100,
//),
//),
//),

//class StreamAnimatorBuilder<T extends Unit> extends StatelessWidget {
//  final StreamValue<T> streamValue;
//  final Widget Function(double) builder;
//  final Duration Function() durationCallback;
//  final Curve curve;
//  final animatorKey = AnimatorKey<double>();
//
//  StreamAnimatorBuilder(
//      {@required this.streamValue,
//      @required this.builder,
//      @required this.durationCallback,
//      this.curve = Curves.easeInOut}) {
//    streamValue.stream.listen(
//      (value) {
//        double previousValue = double.parse(streamValue.previousValue.value);
//        double value = double.parse(streamValue.value.value);
//
//        Duration duration = Duration(milliseconds: 300);
//
//        //durationCallback();
//        _log.finest("Animation Duration: $duration");
//
//        _log.finest(
//            "ANIMATION VALUES IN StreamAnimationBuilder: previous: $previousValue , value: $value");
//        if (previousValue == 0.0 && value == 0.0) return;
//        animatorKey
//          ..refreshAnimation(
//            tween: Tween<double>(begin: previousValue, end: value),
//            duration: duration,
//            curve: curve,
//          )
//          ..triggerAnimation();
//      },
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) => Animator<double>(
//        animatorKey: animatorKey,
//        builder: (buildContext, anim, child) => builder(anim.value),
//      );
//}
