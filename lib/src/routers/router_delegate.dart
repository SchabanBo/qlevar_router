import 'dart:async';

import 'package:flutter/material.dart';

import '../../qlevar_router.dart';
import '../controllers/qrouter_controller.dart';
import '../helpers/widgets/browser_address_bar.dart';

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
    this.restorationScopeId,
  }) : key = navKey ?? GlobalKey<NavigatorState>() {
    _createController();
    if (observers != null) {
      this.observers.addAll(observers);
    }
  }

  /// Restoration ID to save and restore the state of the navigator, including
  /// its history.
  final String? restorationScopeId;

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
    if (configuration != _slash) {
      QR.log('incoming init path $configuration', isDebug: true);
      if (alwaysAddInitPath) {
        QR.log(
            'adding init path $initPath because QRouterDelegate.alwaysAddInitPath is true',
            isDebug: true);
        await QR.to(initPath ?? _slash);
      }
      await QR.to(configuration);
      return;
    }
    await _controller.push(initPath ?? _slash);
  }

  @override
  Future<void> setNewRoutePath(String configuration) async {
    // fix route encoding (order%20home => order home)
    try {
      configuration = Uri.decodeFull(configuration).toString();
    } catch (_) {
      QR.log('Error while decoding the route $configuration');
    }
    if (QR.history.hasLast &&
        QR.history.last.path == QR.settings.notFoundPage.path) {
      if (QR.history.length > 2 &&
          configuration == QR.history.beforeLast.path) {
        QR.history.removeLast();
      }
    }
    if (QR.history.hasLast && configuration == QR.history.last.path) {
      QR.log(
        'New route reported that was last visited. using QR.back() to response',
        isDebug: true,
      );

      QR.back();
      return;
    }
    await QR.to(configuration);
    return;
  }

  Navigator get navigator {
    var scopId = restorationScopeId;
    if (scopId == null && QR.settings.autoRestoration) {
      scopId = 'router:${_controller.key.name}';
    }
    return Navigator(
      key: key,
      pages: _controller.pages,
      observers: observers,
      restorationScopeId: restorationScopeId,
      onPopPage: (route, result) {
        _controller.removeLast();
        return false;
      },
    );
  }

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

const _slash = '/';
