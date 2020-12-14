import 'package:flutter/cupertino.dart';

import 'router.dart';
import 'types.dart';

class RoutesTree {
  final List<_QRoute> _routes = [];

  List<_QRoute> buildTree(List<QRoute> routes, String basePath, String key) {
    final result = <_QRoute>[];
    if (routes == null || routes.isEmpty) return result;

    for (var route in routes) {
      final fullPath = basePath + route.path;
      final children = buildTree(route.children, fullPath, route.path);
      QR.log('"$fullPath" added with key "$key"');
      result.add(_QRoute(
        page: route.page,
        path: route.path,
        fullPath: fullPath,
        key: key,
        children: children,
      ));
    }
    _routes.addAll(result);
    return result;
  }

  void setTree(List<QRoute> routes) {
    assert(_routes.isEmpty, 'Tree already set');
    buildTree(routes, '', '/');
  }

  MatchRoute getMatch(String path) {
    assert(_routes.any((element) => element.fullPath == path),
        'Path [$path] not set in the route tree');
    final match = _routes.firstWhere((element) => element.fullPath == path);
    QR.log('Route found ${match.fullPath}');
    return MatchRoute(route: match);
  }

  List<_QRoute> getKey(String key) {
    return _routes.where((element) => element.key == key).toList();
  }

  void setDelegate(String key, QRouterDelegate delegate) {
    getKey(key).forEach((element) {
      element.delegate = delegate;
    });
  }
}

class _QRoute {
  final String key;
  final String path;
  final String fullPath;
  QRouterDelegate delegate;
  final QRouteBuilder page;
  final List<_QRoute> children;

  _QRoute(
      {@required this.key,
      @required this.path,
      @required this.fullPath,
      @required this.page,
      this.children});

  bool get hasChidlren => children != null && children.isNotEmpty;

  @override
  String toString() =>
      'key: $key, fullPath: $fullPath, path: $path, hasChidlren: $hasChidlren';
}

class MatchRoute {
  final _QRoute route;

  MatchRoute({
    @required this.route,
  });
}
