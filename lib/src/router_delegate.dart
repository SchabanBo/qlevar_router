import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'navigator/router_controller.dart';
import 'qr.dart';

/// Qlevar Router implementation for [RouterDelegate]
// ignore: prefer_mixin
class QRouterDelegate extends RouterDelegate<String> with ChangeNotifier {
  final GlobalKey<NavigatorState> key;
  final RouterController _request;
  bool _isNewRoute = true;
  QRouterDelegate(this._request) : key = _request.navKey {
    QR.log('Root Controller : $_request', isDebug: true);
    _request.addListener(notifyListeners);
  }

  @override
  String get currentConfiguration => QR.currentRoute.fullPath;

  @override
  Future<void> setInitialRoutePath(String configuration) {
    if (configuration != '/') {
      QR.to(configuration);
    }
    return SynchronousFuture(null);
  }

  @override
  Future<void> setNewRoutePath(String route) {
    // I Don't know why but when the user press the back button in the browser
    // the framework will report this route multiple time.
    if (!_isNewRoute) {
      return SynchronousFuture(null);
    }
    _isNewRoute = false;
    Future.delayed(Duration(milliseconds: 200), () => _isNewRoute = true);

    if (QR.history.length > 1 &&
        route == QR.history[QR.history.length - 2].path) {
      QR.back();
      return SynchronousFuture(null);
    }
    QR.to(route);
    return SynchronousFuture(null);
  }

  @override
  Future<bool> popRoute() async => QR.back();

  @override
  Widget build(BuildContext context) => Navigator(
        key: key,
        pages: _request.pages,
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          return QR.back();
        },
      );
}
