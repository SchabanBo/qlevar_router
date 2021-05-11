import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../qlevar_router.dart';
import '../controllers/qrouter_controller.dart';
import '../helpers/widgets/browser_address_bar.dart';
import '../qr.dart';

/// Qlevar Router implementation for [RouterDelegate]
// ignore: prefer_mixin
class QRouterDelegate extends RouterDelegate<String> with ChangeNotifier {
  final key = GlobalKey<NavigatorState>();
  final QRouterController _controller;
  final bool withWebBar;
  QRouterDelegate(
    List<QRoute> routes, {
    String? initPath,
    this.withWebBar = false,
  }) : _controller = QR.createRouterController(QRContext.rootRouterName,
            routes: routes, initPath: initPath) {
    _controller.addListener(notifyListeners);
    _controller.navKey = key;
  }

  @override
  String get currentConfiguration => QR.currentPath;

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
    if (QR.history.hasLast &&
        QR.history.last.path == QR.settings.notFoundPage.path) {
      if (QR.history.length > 2 && route == QR.history.beforelast.path) {
        QR.history.removeLast();
      }
    }
    if (QR.history.hasLast && route == QR.history.last.path) {
      QR.log(
          // ignore: lines_longer_than_80_chars
          'New route reported that was last visited. Useing QR.back() to response',
          isDebug: true);

      QR.back();
      return SynchronousFuture(null);
    }
    QR.to(route);
    return SynchronousFuture(null);
  }

  @override
  Future<bool> popRoute() async => QR.back();

  @override
  Widget build(BuildContext context) =>
      (withWebBar && BrowserAddressBar.isNeeded)
          ? Column(children: [
              SizedBox(
                  height: 40,
                  child: BrowserAddressBar(setNewRoutePath, _controller)),
              Expanded(child: navigator),
            ])
          : navigator;

  Navigator get navigator => Navigator(
        key: key,
        pages: _controller.pages,
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          return _controller.removeLast();
        },
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
