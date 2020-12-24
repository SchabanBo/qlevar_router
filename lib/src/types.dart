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

class _QRContext {
  final QCurrentRoute currentRoute = QCurrentRoute();
  bool enableLog = true;
}

// ignore: non_constant_identifier_names
final QR = _QRContext();

extension QRouterExtensions on _QRContext {
  static final RoutesTree _routesTree = RoutesTree();
  RoutesTree get routesTree => _routesTree;
  MatchContext findMatch(String route, {String parent}) =>
      _routesTree.getMatch(route, parentPath: parent);

  void replace(String route) => _routesTree.updatePath(route);

  void log(String mes) {
    if (enableLog) {
      print('Qlevar-Route: $mes');
    }
  }
}

class QCurrentRoute {
  String fullPath = '';
  Map<String, dynamic> params = {};
  MatchContext match;
}

class MatchContext {
  final int key;
  final String name;
  final String fullPath;
  final bool isComponent;
  final QRouteBuilder page;
  MatchContext childContext;
  QRouter<dynamic> router;

  MatchContext(
      {this.name,
      this.key,
      this.fullPath,
      this.isComponent,
      this.page,
      this.childContext,
      this.router});

  MatchContext copyWith({String fullPath, bool isComponent}) => MatchContext(
      key: key,
      name: name,
      fullPath: fullPath ?? this.fullPath,
      isComponent: isComponent ?? this.isComponent,
      page: page,
      childContext: childContext,
      router: router);

  factory MatchContext.fromRoute(MatchRoute route,
          {QRouter<dynamic> router, MatchContext childContext}) =>
      MatchContext(
          name: route.route.name,
          isComponent: route.route.isComponent,
          key: route.route.key,
          fullPath: route.route.fullPath,
          page: route.route.page,
          childContext: childContext,
          router: router);

  MaterialPage toMaterialPage() =>
      MaterialPage(name: name, key: ValueKey(fullPath), child: page(router));

  void triggerChild() {
    if (router == null) {
      return;
    }
    router.routerDelegate.setNewRoutePath(childContext);
  }
}

