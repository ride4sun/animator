import 'dart:math';

import 'package:animator/animator.dart';
import 'package:flutter/material.dart';

import 'margins.dart';
import 'my_bloc.dart';
import 'my_bloc_provider.dart';
import 'progress_widget.dart';

class AnimationWithAnimatorKey extends StatefulWidget {
  @override
  _AnimationWithAnimatorKeyState createState() =>
      _AnimationWithAnimatorKeyState();
}

MyBloc _myBloc;

class _AnimationWithAnimatorKeyState extends State<AnimationWithAnimatorKey> {
  @override
  void initState() {
    super.initState();
    _myBloc = new MyBloc();
    _myBloc.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Animation"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: MyBlocProvider(
          bloc: _myBloc,
          child: MyAnimation(),
        ),
      ),
    );
  }
}

class MyAnimation extends StatelessWidget {
  final _flutterLog100 =
      FlutterLogo(size: 150, style: FlutterLogoStyle.horizontal);

  final AnimatorKey animatorKey = AnimatorKey<double>();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Margins(
              child: Container(
                width: 300,
                height: 40,
                child: ProgressWidget(
                  streamValue: MyBlocProvider.of(context).progress,
                  curve: Curves.bounceOut,
                  durationCallback: () {
                    Random random = new Random();
                    return Duration(milliseconds: random.nextInt(400) + 1000);
                  },
                ),
              ),
              all: 50,
            ),

//            Text('Start Animation and you can not restart it until it ends'),
//            RaisedButton(
//              child: Text("Animate"),
//              onPressed: () => animatorKey.triggerAnimation(),
//            ),
//            SizedBox(height: 5),
//            Text('Start Animation and restart it if it is running'),
//            RaisedButton(
//              child: Text("restart animation"),
//              onPressed: () => animatorKey.triggerAnimation(restart: true),
//            ),
//            SizedBox(height: 5),
//            Text('Change animation setting and restart it'),
//            Text('Curve is changed from linear to bounceIn'),
            RaisedButton(
              child: Text("reset and restart animation using AnimatorKey"),
              onPressed: () => animatorKey
                ..refreshAnimation(
                  curve: Curves.bounceIn,
                )
                ..triggerAnimation(),
            ),
            Animator<double>(
              tweenMap: {
                "opacityAnim": Tween<double>(begin: 0.5, end: 1),
                "rotationAnim": Tween<double>(begin: 0, end: 2 * pi),
                "translateAnim":
                    Tween<Offset>(begin: Offset.zero, end: Offset(1, 0)),
              },
              cycles: 3,
              duration: Duration(seconds: 2),
              endAnimationListener: (anim) => print("animation finished"),
              animatorKey: animatorKey,
              builder: (context, anim, child) => FadeTransition(
                opacity: anim.getAnimation("opacityAnim"),
                child: FractionalTranslation(
                  translation: anim.getValue("translateAnim"),
                  child: _flutterLog100,
                ),
              ),
            ),
            AnimatorRebuilder(
              observe: () => animatorKey,
              builder: (context, anim, child) {
                return Container(
                  child: FractionalTranslation(
                    translation: anim.getValue("translateAnim"),
                    child: Transform.rotate(
                      angle: anim.getValue("rotationAnim"),
                      child: _flutterLog100,
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
