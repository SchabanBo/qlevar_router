import 'package:flutter/material.dart';

import '../qlevar_router.dart';
import 'routes_tree.dart';

// ignore: non_constant_identifier_names
final QR = _QRContext();

/// The main class of qlevar-router
class _QRContext {
  /// The information for the current route
  /// here you can find the params for the current route
  /// or even the fullpath
  final QCurrentRoute currentRoute = QCurrentRoute();
  bool enableLog = true;
  bool enableDebugLog = false;
  final RoutesTree _routesTree = RoutesTree();

  /// list of string for the paths that has been called.
  final history = <String>[];

  QRouterDelegate router(List<QRoute> routes, {String initRoute = ''}) {
    if (routes.map((e) => e.path).contains('/') == false) {
      routes.add(QRoute(path: '/', redirectGuard: (s) => initRoute));
    }
    if (routes.map((e) => e.path).contains('/notfound') == false) {
      routes.add(QRoute(
          path: '/notfound',
          page: (r) => Material(
                child: Center(
                  child: Text('Page Not Found "${QR.currentRoute.fullPath}"'),
                ),
              )));
    }

    return _routesTree.setTree(
        routes, () => QRouterDelegate(matchRoute: findMatch(initRoute)));
  }

  /// Get the RouteInformationParser
  QRouteInformationParser routeParser() =>
      QRouteInformationParser(parent: 'QRouterBasePath');

  MatchContext findMatch(String route, {String parent}) =>
      _routesTree.getMatch(route, parentPath: parent);

  /// Navigate to new page with [path]
  void to(String path, {QNavigationMode mode}) =>
      _routesTree.updatePath(path, mode);

  // back to previous page
  void back() => to(QR.history[QR.history.length - 2]);

  /// wirte log
  void log(String mes, {bool isDebug = false}) {
    if (enableLog && (!isDebug || enableDebugLog)) {
      print('Qlevar-Route: $mes');
    }
  }
}

class QNavigationMode {
  final NavigationType type;

  QNavigationMode({this.type = NavigationType.ReplaceLast});
}

enum NavigationType {
  Push,
  PopUnitOrPush,
  ReplaceLast,
  ReplaceAll,
}
