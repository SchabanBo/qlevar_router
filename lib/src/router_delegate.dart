import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'navigator/router_controller.dart';
import 'qr.dart';

/// Qlevar Router implementation for [RouterDelegate]
// ignore: prefer_mixin
class QRouterDelegate extends RouterDelegate<String> with ChangeNotifier {
  final GlobalKey<NavigatorState> key;
  final RouterController _request;
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
