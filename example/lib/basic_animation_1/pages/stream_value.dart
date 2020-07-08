import 'dart:async';

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

final _log = new Logger('stream.stream_value.dart');

abstract class ReadStreamValue<T> extends Object {
  ReadStreamValue({@required this.seedValue}) {
    _s = BehaviorSubject<T>.seeded(seedValue);
    _previousValue = seedValue;
    _value = seedValue;
  }
  T get value => _value;
  T get previousValue => _previousValue;
  final T seedValue;
  T _value;
  T _previousValue;
  Subject<T> _s;
  Stream<T> get stream => _s.stream.asBroadcastStream();

  Stream<T> streamDebounce(Duration duration) =>
      _s.debounce((_) => TimerStream(true, duration)).asBroadcastStream();

  @override
  String toString() => '$value';

  refresh() {
    _s.add(_value);
  }

  Future dispose() async {
    _s.drain();
    _s.close();
  }
}

class StreamValue<T> extends ReadStreamValue<T> {
  StreamValue(
      {@required seedValue,
      this.updateEvenIfEqual = true,
      this.ignoreNullValues = false,
      this.name})
      : super(seedValue: seedValue);

  final bool updateEvenIfEqual;
  final bool ignoreNullValues;
  final String name;

  set value(T newValue) {
    if (newValue == null && ignoreNullValues) return;
    if (newValue != _value || updateEvenIfEqual) {
      if (name != null)
        _log.finest(
            'name: $name: value: ${value.toString()} changed to: ${newValue.toString()}');
      _previousValue = _value;
      _value = newValue;
      _s.add(newValue);
    }
  }
}
