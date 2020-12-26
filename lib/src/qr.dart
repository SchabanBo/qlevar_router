import 'package:flutter/material.dart';

import '../qlevar_router.dart';
import 'routes_tree.dart';

// ignore: non_constant_identifier_names
final QR = _QRContext();

class _QRContext {
  final QCurrentRoute currentRoute = QCurrentRoute();
  final bool enableLog = true;
  final bool enableDebugLog = true;
  final RoutesTree _routesTree = RoutesTree();

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

  void replace(String route) => _routesTree.updatePath(route);

  void log(String mes, {bool isDebug = false}) {
    if (enableLog && (!isDebug || enableDebugLog)) {
      print('Qlevar-Route: $mes');
    }
  }
}
