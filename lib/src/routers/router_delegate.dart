import 'dart:async';

import 'package:flutter/material.dart';

import '../../qlevar_router.dart';
import '../controllers/qrouter_controller.dart';
import '../helpers/widgets/browser_address_bar.dart';
import '../qr.dart';

/// Qlevar Router implementation for [RouterDelegate]
// ignore: prefer_mixin
class QRouterDelegate extends RouterDelegate<String> with ChangeNotifier {
  QRouterDelegate(
    List<QRoute> routes, {
    GlobalKey<NavigatorState>? navKey,
    this.initPath,
    this.withWebBar = false,
    this.alwaysAddInitPath = false,
    this.observers = const [],
  })  : _controller =
            QR.createRouterController(QRContext.rootRouterName, routes: routes),
        key = navKey ?? GlobalKey<NavigatorState>() {
    _controller.addListener(notifyListeners);
    _controller.navKey = key;
  }

  /// Set this to true if you want always the initial router to be added on the stack
  /// Example.
  /// you have tow routes under the domain www.example.com
  /// - '/' init route
  /// - '/user'
  /// if the user opens www.example.com/user and this property was true the '/' path will be added
  /// so the user could press back to '/', otherwise the user will not be able to press back
  final bool alwaysAddInitPath;

  /// The initial router when the app starts
  final String? initPath;

  /// The navigation key for the navigator
  final GlobalKey<NavigatorState> key;

  /// A list of observers for this navigator.
  final List<NavigatorObserver> observers;

  /// Add a fake app bar so you can test navigating to routes
  /// This app bar will not be added in the release mode
  final bool withWebBar;

  final QRouterController _controller;

  @override
  String get currentConfiguration => QR.currentPath;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Future<bool> popRoute() async {
    final result = await QR.back();
    switch (result) {
      case PopResult.NotPopped:
        return false;
      default:
        return true;
    }
  }

  @override
  Future<void> setInitialRoutePath(String configuration) async {
    if (alwaysAddInitPath) {
      await _controller.push(initPath ?? '/');
    }
    if (configuration != '/') {
      QR.log('incoming init path $configuration', isDebug: true);
      await _controller.push(configuration);
      return;
    }
    await _controller.push(initPath ?? configuration);
  }

  @override
  Future<void> setNewRoutePath(String configuration) async {
    // fix route encoding (order%20home => order home)
    configuration = Uri.decodeFull(configuration).toString();
    if (QR.history.hasLast &&
        QR.history.last.path == QR.settings.notFoundPage.path) {
      if (QR.history.length > 2 &&
          configuration == QR.history.beforeLast.path) {
        QR.history.removeLast();
      }
    }
    if (QR.history.hasLast && configuration == QR.history.last.path) {
      QR.log(
          // ignore: lines_longer_than_80_chars
          'New route reported that was last visited. using QR.back() to response',
          isDebug: true);

      QR.back();
      return;
    }
    await QR.to(configuration);
    return;
  }

  Navigator get navigator => Navigator(
        key: key,
        pages: _controller.pages,
        observers: observers,
        onPopPage: (route, result) {
          _controller.removeLast();
          return false;
        },
      );

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
}
