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
    this.routes, {
    GlobalKey<NavigatorState>? navKey,
    this.initPath,
    this.withWebBar = false,
    this.alwaysAddInitPath = false,
    List<NavigatorObserver>? observers,
  }) : key = navKey ?? GlobalKey<NavigatorState>() {
    _createController();
    if (observers != null) {
      this.observers.addAll(observers);
    }
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
  final List<NavigatorObserver> observers = [];

  /// The route tree for the app
  final List<QRoute> routes;

  /// Add a fake app bar so you can test navigating to routes
  /// This app bar will not be added in the release mode
  final bool withWebBar;

  late final QRouterController _controller;

  @override
  String get currentConfiguration => QR.currentPath;

  @override
  void dispose() {
    _controller.disposeAsync();
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
    await _controllerCompleter.future;
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

  Widget _buildNavigator() {
    if (!withWebBar || !BrowserAddressBar.isNeeded) {
      return navigator;
    }

    return Column(
      children: [
        SizedBox(
          height: 40,
          child: BrowserAddressBar(setNewRoutePath, _controller),
        ),
        Expanded(child: navigator),
      ],
    );
  }

  final _controllerCompleter = Completer<QRouterController>();

  Future<void> _createController() async {
    final con = await QR.createRouterController(
      QRContext.rootRouterName,
      routes: routes,
    );
    _controller = con;
    _controllerCompleter.complete(con);
    _controller.addListener(notifyListeners);
    observers.add(_controller.observer);
    _controller.navKey = key;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _controllerCompleter.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildNavigator();
        }
        return QR.settings.initPage;
      },
    );
  }
}
