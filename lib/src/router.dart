import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'navigator.dart';
import 'qr.dart';
import 'routes_tree/routes_tree.dart';

/// Qlevar Router implementation for [RouterDelegate]
// ignore: prefer_mixin
class QRouterDelegate extends RouterDelegate<MatchContext> with ChangeNotifier {
  final QNavigatorController _navigator;
  final String _initRoute;

  QRouterDelegate(this._navigator, this._initRoute) {
    _navigator.notify = notifyListeners;
    QR.log('Root Navigator key: ${_navigator.rootKey.code}');
  }

  @override
  MatchContext get currentConfiguration =>
      MatchContext(fullPath: QR.currentRoute.fullPath);

  @override
  Future<void> setInitialRoutePath(MatchContext configuration) {
    return SynchronousFuture(null);
  }

  @override
  Future<void> setNewRoutePath(MatchContext route) {
    _navigator.toPath(route.fullPath, QNavigationMode());
    return SynchronousFuture(null);
  }

  @override
  Future<bool> popRoute() async => _navigator.pop();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigator.rootKey.navigatorKey,
      initialRoute: _initRoute,
      onGenerateInitialRoutes: (navigator, initialRoute) =>
          [_navigator.initRoute(_initRoute)],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        return _navigator.pop();
      },
    );
  }
}
