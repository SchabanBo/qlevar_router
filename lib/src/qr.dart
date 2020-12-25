
import 'package:flutter/material.dart';

import '../qlevar_router.dart';
import 'routes_tree.dart';

class _QRContext {
  final QCurrentRoute currentRoute = QCurrentRoute();
  bool enableLog = true;
  final RoutesTree _routesTree = RoutesTree();
  RoutesTree get routesTree => _routesTree;
  
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
        routes, () => QRouterDelegate(matchRoute: QR.findMatch(initRoute)));
  }

  /// Get the RouteInformationParser
  QRouteInformationParser routeParser() =>
      QRouteInformationParser(parent: 'QRouterBasePath');
}

// ignore: non_constant_identifier_names
final QR = _QRContext();

extension QRouterExtensions on _QRContext {
  MatchContext findMatch(String route, {String parent}) =>
      QR.routesTree.getMatch(route, parentPath: parent);

  void replace(String route) => _routesTree.updatePath(route);

  void log(String mes) {
    if (enableLog) {
      print('Qlevar-Route: $mes');
    }
  }
}