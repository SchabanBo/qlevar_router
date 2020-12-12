import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'route.dart';
import 'route_parser.dart';

class QRouter extends InheritedWidget {
  final QPages pages;

  const QRouter({
    Key key,
    @required this.pages,
    @required Widget child,
  }) : super(key: key, child: child);

  static QRouter of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<QRouter>();
  }

  void pushNamed(String routeName) {
    pages.pushNamed(routeName);
  }

  void replaceNamed(String routeName) {
    pages.replaceNamed(routeName);
  }

  void replaceAllNamed(List<String> routeNames) {
    pages.replaceAllNamed(routeNames);
  }

  void pop() {
    pages.pop();
  }

  @override
  bool updateShouldNotify(QRouter old) => pages != old.pages;
}

class QPages {
  final QRouterDelegate routerDelegate;
  final QRouteInformationParser informationParser;

  QPages({@required List<QRoute> routes})
      : routerDelegate = QRouterDelegate(routes: routes),
        informationParser = QRouteInformationParser();

  void pushNamed(String routeName) {
    routerDelegate.pushNamed(routeName);
  }

  void replaceNamed(String routeName) {
    routerDelegate.replaceNamed(routeName);
  }

  void replaceAllNamed(List<String> routeNames) {
    routerDelegate.replaceAllNamed(routeNames);
  }

  void pop() {
    routerDelegate.pop();
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
      : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();

  @override
  QUri get currentConfiguration => QUri(_stack.last);

  @override
  Widget build(BuildContext context) => Navigator(
        key: navigatorKey,
        pages: [
          ..._stack.map((routeName) {
            return MaterialPage(
                key: ValueKey(routeName),
                child: routes
                    .firstWhere((element) => element.path == routeName)
                    .page);
          }),
        ],
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
