import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'navigator.dart';
import 'qr.dart';
import 'routes_tree/routes_tree.dart';

/// Qlevar Router implementation for [RouterDelegate]
// ignore: prefer_mixin
class QRouterDelegate extends RouterDelegate<MatchContext> with ChangeNotifier {
  final QNavigator _navigator;
  final _stack = <Page<dynamic>>[];
  final String _initRoute;

  QRouterDelegate(this._navigator, this._initRoute) {
    _navigator.notify = notifyListeners;
  }

  @override
  MatchContext get currentConfiguration => MatchContext();

  @override
  Future<void> setInitialRoutePath(MatchContext configuration) {
    _stack.add(_navigator.initRoute(_initRoute));
    return SynchronousFuture(null);
  }

  @override
  Future<void> setNewRoutePath(MatchContext route) {
    _navigator.updatePath(route, QNavigationMode());
    return SynchronousFuture(null);
  }

  @override
  Future<bool> popRoute() async => _navigator.pop();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigator.rootKey,
      pages: _stack,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        return _navigator.pop();
      },
    );
  }
}
