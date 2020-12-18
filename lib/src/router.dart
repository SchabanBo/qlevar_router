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
    QR.routesTree.setTree(routes);
    final delegate = QRouterDelegate(initRoute: initRoute);
    QR.routesTree.setRootDelegate(delegate);
    return MaterialApp.router(
      routerDelegate: delegate,
      routeInformationParser:
          QRouteInformationParser(parent: 'QRouterBasePath'),
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
  bool _mounted = false;
  QRouterDelegate({String initRoute, MatchRoute matchRoute})
      : navigatorKey = GlobalKey<NavigatorState>() {
    if (matchRoute != null) {
      print(matchRoute.route.toString());
    }
    print('$initRoute-' + navigatorKey.hashCode.toString());

    _stack.add(matchRoute == null ? QR.findMatch(initRoute) : matchRoute);
  }

  @override
  MatchRoute get currentConfiguration => _stack.last;

  @override
  Widget build(BuildContext context) {
    return Navigator(
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
  }

  @override
  Future<void> setNewRoutePath(MatchRoute route) {
    QR.log('setNewRoutePath: ${route.route}');
    _stack
      ..clear()
      ..add(route);
    return SynchronousFuture(null);
  }

  List<Page<dynamic>> get _pages {
    final s = navigatorKey.hashCode;
    return _stack.map((match) {
      QRouter childRouter;

      if (match.childMatch != null || match.childInit != null) {
        final delegate = QRouterDelegate(
            initRoute: match.childInit, matchRoute: match.childMatch);
        for (var item in match.route.children) {
          item.delegate = delegate;
        }
        childRouter = QRouter(
          routerDelegate: delegate,
          routeInformationParser:
              QRouteInformationParser(parent: match.route.fullPath),
          routeInformationProvider:
              QRouteInformationProvider(initialRoute: match.childInit ?? ''),
        );
      }

      return MaterialPage(
          name: match.route.path,
          key: ValueKey(match.route.fullPath),
          child: match.route.page(childRouter));
    }).toList();
  }

  bool _isOldMatch(MatchRoute matchRoute) {
    final last = _stack.last;
    return last.route.path == matchRoute.route.path &&
        last.childInit == matchRoute.childInit &&
        last.childMatch == matchRoute.childMatch;
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
    _stack.removeLast();
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

  @override
  void dispose() {
    if (_mounted) return;
    super.dispose();
    _mounted = true;
  }
}
