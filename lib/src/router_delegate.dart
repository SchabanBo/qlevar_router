import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'navigator/router_controller.dart';
import 'qr.dart';
import 'routes_tree/routes_tree.dart';

/// Qlevar Router implementation for [RouterDelegate]
// ignore: prefer_mixin
class QRouterDelegate extends RouterDelegate<MatchContext> with ChangeNotifier {
  final key = GlobalKey<NavigatorState>();
  final RouterController _request;
  QRouterDelegate(this._request) {
    QR.log('Root Controller : $_request');
    _request.addListener(notifyListeners);
  }

  @override
  MatchContext get currentConfiguration =>
      MatchContext(fullPath: QR.currentRoute.fullPath);

  @override
  Future<void> setInitialRoutePath(MatchContext configuration) =>
      SynchronousFuture(null);

  @override
  Future<void> setNewRoutePath(MatchContext route) {
    QR.to(route.fullPath);
    return SynchronousFuture(null);
  }

  @override
  Future<bool> popRoute() async => _request.onPop();

  @override
  Widget build(BuildContext context) => Navigator(
        key: key,
        pages: _request.pages,
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          return _request.onPop();
        },
      );

  Page<dynamic> palceHolder() =>
      MaterialPage(key: ValueKey('placeHolder'), child: Container());
}
