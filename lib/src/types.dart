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
  final String path;
  final QRouteBuilder page;
  final RedirectGuard redirectGuard;
  final List<QRoute> children;

  QRoute({@required this.path, this.redirectGuard, this.page, this.children});
}

class QUri {
  final Uri uri;
  QUri(String path) : uri = Uri.parse(path);
}

class QRInterface {}

// ignore: non_constant_identifier_names
final QR = QRInterface();

extension QRouterExtensions on QRInterface {
  static final RoutesTree _routesTree = RoutesTree();
  static bool enableLog = true;
  RoutesTree get routesTree => _routesTree;
  MatchRoute findMatch(String route) => _routesTree.getMatch(route);
  void to(String route) {
    final match = findMatch(route);
    match.route.delegate.push(match);
  }

  void replace(String route){
    final match = findMatch(route);
    match.route.delegate.replace(match);
  }

  void log(String mes) {
    if (enableLog) {
      print('Qlevar-Route: $mes');
    }
  }
}

class QRNotifer extends ChangeNotifier {
  RouteState state = RouteState.Init;
  List<String> routes = [];

  void push(String name) {
    state = RouteState.Push;
    routes = [name];
  }
}

enum RouteState {
  None,
  Init,
  Push,
  Replace,
  ReplaceAll,
  Pop,
  PopAll,
}
