import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../qlevar_router.dart';
import '../controllers/qrouter_controller.dart';
import '../qr.dart';

/// Qlevar Router implementation for [RouterDelegate]
// ignore: prefer_mixin
class QRouterDelegate extends RouterDelegate<String> with ChangeNotifier {
  final key = GlobalKey<NavigatorState>();
  final QRouterController _controller;
  QRouterDelegate(List<QRoute> routes, {String? initPath, QRoute? notFoundPage})
      : _controller = QR.createRouterController(
            QRContext.rootRouterName, routes,
            initPaht: initPath) {
    _controller.addListener(notifyListeners);
  }

  @override
  String get currentConfiguration => QR.curremtPath;

  @override
  Future<void> setInitialRoutePath(String configuration) {
    if (configuration != '/') {
      QR.log('setInitialRoutePath $configuration', isDebug: true);
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
        pages: _controller.pages,
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          return QR.back();
        },
      );
}
