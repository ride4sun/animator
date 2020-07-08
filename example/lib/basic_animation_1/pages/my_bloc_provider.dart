import 'package:flutter/material.dart';

import 'my_bloc.dart';

class MyBlocProvider extends InheritedWidget {
  const MyBlocProvider({
    @required this.bloc,
    Widget child,
    Key key,
  }) : super(key: key, child: child);

  final MyBloc bloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static MyBloc of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MyBlocProvider>().bloc;
}
