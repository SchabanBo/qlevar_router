import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../qlevar_router.dart';
import '../controllers/qrouter_controller.dart';
import '../helpers/widgets/browser_address_bar.dart';
import '../qr.dart';
import '../types/pop_result.dart';

/// Qlevar Router implementation for [RouterDelegate]
// ignore: prefer_mixin
class QRouterDelegate extends RouterDelegate<String> with ChangeNotifier {
  final key = GlobalKey<NavigatorState>();
  final QRouterController _controller;
  final bool withWebBar;
  final bool alwaysAddInitPath;
  final String? initPath;
  QRouterDelegate(
    List<QRoute> routes, {
    this.initPath,
    this.withWebBar = false,
    this.alwaysAddInitPath = false,
  }) : _controller = QR.createRouterController(QRContext.rootRouterName,
            routes: routes) {
    _controller.addListener(notifyListeners);
    _controller.navKey = key;
  }

  @override
  String get currentConfiguration => QR.currentPath;

  @override
  Future<void> setInitialRoutePath(String configuration) async {
    if (alwaysAddInitPath) {
      await _controller.push(initPath ?? '/');
    }
    if (configuration != '/') {
      QR.log('incomming init path $configuration', isDebug: true);
      await _controller.push(configuration);
      return;
    }
    await _controller.push(initPath ?? configuration);
  }

  @override
  Future<void> setNewRoutePath(String route) async {
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
      return;
    }
    await QR.to(route);
    return;
  }

  @override
  Future<bool> popRoute() async {
    final result = await QR.back();
    switch (result) {
      case PopResult.NotPoped:
        return false;
      default:
        return true;
    }
  }

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
          _controller.removeLast();
          return false;
        },
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
