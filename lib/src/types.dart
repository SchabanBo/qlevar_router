import 'package:flutter/material.dart';
import 'routes_tree.dart';

class QRouter<T> extends Router<T> {}

typedef QRouteBuilder = Widget Function(QRouter);

class QRoute {
  final String path;
  final QRouteBuilder page;
  final List<QRoute> children;

  QRoute({@required this.path, @required this.page, this.children});
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
  RoutesTree get routesTree => _routesTree;
  //void push(String name) => _notifer.push(name);
}

class QRNotifer extends ChangeNotifier {
  RouteState state = RouteState.Init;
  List<String> routes;

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
