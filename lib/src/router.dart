import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'route_parser.dart';
import 'routes_tree.dart';
import 'types.dart';

class QRouterApp extends StatelessWidget {
  final List<QRoute> routes;
  final String initRoute;

  const QRouterApp({
    this.initRoute = '/',
    @required this.routes,
  });

  @override
  Widget build(BuildContext context) {
    QR.routesTree.setTree(routes);
    return MaterialApp.router(
      routerDelegate: QRouterDelegate(key: '/', initRoute: initRoute),
      routeInformationParser: QRouteInformationParser(),
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
              key: match.route.path, initRoute: '${match.route.fullPath}/'),
          // routeInformationParser: QRouteInformationParser(),
          // routeInformationProvider: QRouteInformationProvider(),
        );
      }
      return MaterialPage(
          name: match.route.path,
          key: ValueKey(match.route.fullPath),
          child: match.route.page(childRouter));
    }).toList();
  }

  void pushNamed(MatchRoute route) {
    _stack.add(route);
    notifyListeners();
  }

  void replaceNamed(MatchRoute route) {
    _stack.removeLast();
    _stack.add(route);
    notifyListeners();
  }

  void replaceAllNamed(List<MatchRoute> routes) {
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
