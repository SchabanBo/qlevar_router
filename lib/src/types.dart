import 'package:flutter/material.dart';
import 'routes_tree.dart';

class QRouter<T> extends Router<T> {
  const QRouter({
    Key key,
    RouteInformationProvider routeInformationProvider,
    RouteInformationParser<T> routeInformationParser,
    @required RouterDelegate<T> routerDelegate,
    BackButtonDispatcher backButtonDispatcher,
  }) : super(
            key: key,
            backButtonDispatcher: backButtonDispatcher,
            routeInformationParser: routeInformationParser,
            routeInformationProvider: routeInformationProvider,
            routerDelegate: routerDelegate);
}

typedef QRouteBuilder = Widget Function(QRouter);
typedef RedirectGuard = String Function(String);

class QRoute {
  final String name;
  final String path;
  final QRouteBuilder page;
  final RedirectGuard redirectGuard;
  final List<QRoute> children;

  QRoute(
      {this.name,
      @required this.path,
      this.redirectGuard,
      this.page,
      this.children});
}

class QUri {
  final Uri uri;
  QUri(String path) : uri = Uri.parse(path);
}

class _QRInterface {
  final QCurrentRoute currentRoute = QCurrentRoute();
  bool enableLog = true;
}

// ignore: non_constant_identifier_names
final QR = _QRInterface();

extension QRouterExtensions on _QRInterface {
  static final RoutesTree _routesTree = RoutesTree();
  RoutesTree get routesTree => _routesTree;
  MatchRoute findMatch(String route, {String parent}) =>
      _routesTree.getMatch(route, parentPath: parent);
  void to(String route) {
    final match = findMatch(route);
    match.route.delegate.push(match);
  }

  void replace(String route) {
    final match = findMatch(route);
    match.route.delegate.replace(match);
  }

  void log(String mes) {
    if (enableLog) {
      print('Qlevar-Route: $mes');
    }
  }
}

class QCurrentRoute {
  String fullPath = '';
  MatchRoute match;
}
