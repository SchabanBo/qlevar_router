import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'route_parser.dart';
import 'routes_tree.dart';
import 'types.dart';

class QRouterApp extends StatelessWidget {
  final List<QRoute> routes;
  final String initRoute;
  final _baseKey = 'root';

  const QRouterApp({
    this.initRoute = '',
    @required this.routes,
  });

  @override
  Widget build(BuildContext context) {
    if (routes.map((e) => e.path).contains('/') == false) {
      routes.add(QRoute(path: '/', redirectGuard: (s) => initRoute));
    }
    QR.routesTree.setTree(routes, _baseKey);
    return MaterialApp.router(
      routerDelegate: QRouterDelegate(key: _baseKey, initRoute: initRoute),
      routeInformationParser:
          QRouteInformationParser(parent: '', key: _baseKey),
    );
  }
}

class QRouterDelegate extends RouterDelegate<MatchRoute>
    with
        // ignore: prefer_mixin
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<MatchRoute> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final List<MatchRoute> _stack = [];
  QRouterDelegate({@required String key, String initRoute})
      : navigatorKey = GlobalKey<NavigatorState>(),
        assert(initRoute != null) {
    QR.routesTree.setDelegate(key, this);
    _stack.add(QR.findMatch(initRoute));
  }

  @override
  MatchRoute get currentConfiguration => _stack.last;

  @override
  Widget build(BuildContext context) => Navigator(
        key: navigatorKey,
        pages: _pages,
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }

          _stack.removeLast();
          notifyListeners();
          return true;
        },
      );

  @override
  Future<void> setNewRoutePath(MatchRoute route) {
    QR.log('setNewRoutePath: ${route.route}');
    if (_isOldMatch(route)) {
      QR.log('${route.route} is already on the top of the stack');
      return SynchronousFuture(null);
    }
    _stack
      ..clear()
      ..add(route);
    return SynchronousFuture(null);
  }

  List<Page<dynamic>> get _pages {
    return _stack.map((match) {
      QRouter childRouter;

      if (match.route.hasChidlren) {
        childRouter = QRouter(
          routerDelegate: QRouterDelegate(
              key: match.route.path, initRoute: '${match.route.fullPath}'),
          routeInformationParser: QRouteInformationParser(
              parent: match.route.fullPath, key: match.route.path),
          routeInformationProvider: QRouteInformationProvider(initialRoute: ''),
        );
      }
      return MaterialPage(
          name: match.route.path,
          key: ValueKey(match.route.fullPath),
          child: match.route.page(childRouter));
    }).toList();
  }

  bool _isOldMatch(MatchRoute matchRoute) {
    if (_stack.isEmpty) {
      return false;
    }
    final last = _stack.last;
    return last.route.key == matchRoute.route.key &&
        last.route.path == matchRoute.route.path;
  }

  void push(MatchRoute route) {
    _stack.add(route);
    notifyListeners();
  }

  void replace(MatchRoute route) {
    if (_isOldMatch(route)) {
      QR.log('${route.route} is already on the top of the stack');
      return;
    }
    // TODO: Do you have to check this
    if (_stack.isNotEmpty) {
      _stack.removeLast();
    }
    _stack.add(route);
    notifyListeners();
  }

  void replaceAll(List<MatchRoute> routes) {
    _stack.clear();
    _stack.addAll(routes);
    notifyListeners();
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
