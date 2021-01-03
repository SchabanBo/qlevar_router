import 'package:flutter/material.dart';

import '../qlevar_router.dart';
import 'routes_tree.dart';

/// Qlevar Router.
// ignore: non_constant_identifier_names
final QR = _QRContext();

/// The main class of qlevar-router
class _QRContext {
  /// The information for the current route
  /// here you can find the params for the current route
  /// or even the fullpath
  final _QCurrentRoute currentRoute = _QCurrentRoute();
  bool enableLog = true;
  bool enableDebugLog = false;
  final RoutesTree _routesTree = RoutesTree();
  Map<String, dynamic> get params => currentRoute.params;

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
  QRouteInformationParser routeParser() => const QRouteInformationParser();

  MatchContext findMatch(String route) => _routesTree.getMatch(route);

  /// Navigate to new page with [path]
  void to(String path, {QNavigationMode mode}) =>
      _routesTree.updatePath(path, mode);

  void toName(String name,
          {Map<String, dynamic> params, QNavigationMode mode}) =>
      _routesTree.updateNamedPath(name, params ?? <String, dynamic>{}, mode);

  // back to previous page
  void back() => to(QR.history[QR.history.length - 2]);

  /// wirte log
  void log(String mes, {bool isDebug = false}) {
    if (enableLog && (!isDebug || enableDebugLog)) {
      print('Qlevar-Route: $mes');
    }
  }
}

/// Define how you want the navgiation to react.
class QNavigationMode {
  /// The navigation type
  final NavigationType type;

  QNavigationMode({this.type = NavigationType.ReplaceLast});
}

/// Navigation type, used when navigation to new page.
/// [Pash] place the new page on the top of the stack.
/// and don't remove the last one.
/// [PopUnitOrPush] Pop all page unit you get this page in the stack
/// if the page doesn't exist in the stack push in on the top.
/// [ReplaceLast] replace the last page with this page.
/// [ReplaceAll] remove all page from the stack and place this on on the top.
enum NavigationType {
  Push,
  PopUnitOrPush,
  ReplaceLast,
  ReplaceAll,
}

/// The cureent route inforamtion
class _QCurrentRoute {
  /// The current full path
  String fullPath = '';

  /// The params for the current route
  Map<String, dynamic> params = {};

  /// The last match information
  MatchContext match;
}
