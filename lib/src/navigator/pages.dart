import 'package:flutter/material.dart';

abstract class QPage extends Page {
  final int matchKey;

  QPage(this.matchKey);
}

class QMaterialPage extends MaterialPage implements QPage {
  final int _key;
  QMaterialPage({
    Widget child,
    bool maintainState = true,
    bool fullscreenDialog = false,
    int key,
    String name,
    Object arguments,
  })  : _key = key,
        super(
            child: child,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog,
            key: ValueKey(key),
            name: name,
            arguments: arguments);

  @override
  int get matchKey => _key;
}
