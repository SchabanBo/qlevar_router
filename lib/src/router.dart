import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'route_parser.dart';
import 'types.dart';

class QRouterApp extends StatelessWidget {
  final List<QRoute> routes;
  final String initRoute;
  final MaterialApp Function(MaterialApp) materialApp;

  const QRouterApp({
    this.initRoute = '/',
    @required this.routes,
    @required this.materialApp,
  });

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp.router(
      routerDelegate: QRouterDelegate(),
      routeInformationParser: QRouteInformationParser(),
    );

    return materialApp == null ? app : materialApp(app);
  }
}

class QRouterDelegate extends RouterDelegate<QUri>
    with
        // ignore: prefer_mixin
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<QUri> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final List<String> _stack = ['/'];
  final List<QRoute> routes;
  QRouterDelegate({this.routes, GlobalKey<NavigatorState> navigatorKey})
      : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>() {
    QR.notifer.addListener(notifyListeners);
  }

  @override
  QUri get currentConfiguration => QUri(_stack.last);

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
  Future<void> setNewRoutePath(QUri configuration) {
    _stack
      ..clear()
      ..add(configuration.uri.toString());
    return SynchronousFuture(null);
  }

  List<Page<dynamic>> get _pages {
    switch (QR.notifer.state) {
      case RouteState.Push:
        _stack.add(QR.notifer.routes.first);
        break;
      default:
    }
    return _stack
        .map((routeName) => MaterialPage(
            key: ValueKey(routeName),
            child:
                routes.firstWhere((element) => element.path == routeName).page))
        .toList();
  }

  void pushNamed(String name) {
    _stack.add(name);
    notifyListeners();
  }

  void replaceNamed(String name) {
    _stack.removeLast();
    _stack.add(name);
    notifyListeners();
  }

  void replaceAllNamed(List<String> routeNames) {
    _stack.clear();
    _stack.addAll(routeNames);
    notifyListeners();
  }

  void pop() {
    _stack.removeLast();
    notifyListeners();
  }
}
