import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'route_parser.dart';
import 'routes_tree.dart';
import 'types.dart';

class QRouterApp extends StatelessWidget {
  final List<QRoute> routes;
  final String initRoute;

  const QRouterApp({
    this.initRoute = '',
    @required this.routes,
  });

  @override
  Widget build(BuildContext context) {
    if (routes.map((e) => e.path).contains('/') == false) {
      routes.add(QRoute(path: '/', redirectGuard: (s) => initRoute));
    }
    if (routes.map((e) => e.path).contains('/notfound') == false) {
      routes.add(QRoute(
          path: '/notfound',
          page: (r) => Material(
                child: Center(
                  child: Text('Page Not Found'),
                ),
              )));
    }

    final delegate = QR.routesTree
        .setTree(routes, () => QRouterDelegate(initRoute: initRoute));

    return MaterialApp.router(
      routerDelegate: delegate,
      routeInformationParser:
          QRouteInformationParser(parent: 'QRouterBasePath'),
    );
  }
}

class QRouterDelegate extends RouterDelegate<MatchContext>
    with
        // ignore: prefer_mixin
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<MatchContext> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final List<MatchContext> _stack = [];
  QRouterDelegate({String initRoute, MatchContext matchRoute})
      : navigatorKey = GlobalKey<NavigatorState>() {
    //_stack.add(matchRoute == null ? QR.findMatch(initRoute) : matchRoute);
  }

  @override
  MatchContext get currentConfiguration => _stack.last;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _stack.map((match) => match.toMaterialPage()).toList(),
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        _stack.removeLast();
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(MatchContext route) {
    QR.log('setNewRoutePath: ${route.fullPath}');
    if (!_isOldMatch(route)) {
      _stack
        ..clear()
        ..add(route);
    }
    route.triggerChild();
    return SynchronousFuture(null);
  }

  bool _isOldMatch(MatchContext matchRoute) {
    final last = _stack.last;
    return last.fullPath == matchRoute.fullPath && last.name == matchRoute.name;
  }

  void pop() {
    if (_stack.length <= 1) {
      print('Stack has just one page. Cannot pop');
      return;
    }
    _stack.removeLast();
    notifyListeners();
  }
}
