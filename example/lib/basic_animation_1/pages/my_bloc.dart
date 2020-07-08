import 'dart:async';
import 'dart:math';

import 'package:logging/logging.dart';

import 'stream_value.dart';

final _log = new Logger('bloc.my_bloc.dart');

class MyBloc {
  Timer _timer;

  init() {
    _timerCallback(null);
  }

  void _timerCallback(_) {
    _timer?.cancel();

    var random = new Random();
    //generates a number between 0 and 1.0
    _progress.value = random.nextDouble() * 100.0;

    random = new Random();
    //generates random for the timer
    var duration = Duration(milliseconds: random.nextInt(500) + 1000);
    _log.finest('Model timer update duration: $duration');
    _timer = Timer.periodic(duration, _timerCallback);
  }

  //call dispose when you delete the object
  dispose() {
    _progress.dispose();
    _timer?.cancel();
  }

  ReadStreamValue<double> get progress => _progress;
  final StreamValue<double> _progress =
      StreamValue<double>(seedValue: 0.0, name: 'progress');
}
