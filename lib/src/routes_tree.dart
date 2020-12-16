import 'package:flutter/cupertino.dart';

import 'router.dart';
import 'types.dart';

class RoutesTree {
  final List<_QRoute> _routes = [];

  List<_QRoute> buildTree(
      List<QRoute> routes, String basePath, String key, _QRoute parent) {
    final result = <_QRoute>[];
    if (routes == null || routes.isEmpty) return result;

    for (var route in routes) {
      final fullPath = basePath + route.path;
      final _route = _QRoute(
        page: route.page,
        path: route.path,
        redirectGuard: route.redirectGuard ?? (s) => null,
        fullPath: fullPath,
        key: key,
      );
      _route.children
          .addAll(buildTree(route.children, fullPath, route.path, _route));
      QR.log('"$fullPath" added with key "$key"');
      result.add(_route);
    }
    _routes.addAll(result);
    return result;
  }

  void setTree(List<QRoute> routes, String baseKey) {
    assert(_routes.isEmpty, 'Tree already set');
    buildTree(routes, '', baseKey, null);
  }

  MatchRoute getMatch(String path) {
    assert(_routes.any((element) => element.fullPath == path),
        'Path [$path] not set in the route tree');
    final match = _routes.firstWhere((element) => element.fullPath == path);
    final redrict = match.redirectGuard(path);
    if (redrict != null) {
      QR.log('Redirect to $redrict');
      return getMatch(redrict);
    }
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
  final RedirectGuard redirectGuard;
  QRouterDelegate delegate;
  final QRouteBuilder page;
  final _QRoute parent;
  final List<_QRoute> children = [];

  _QRoute(
      {@required this.key,
      @required this.path,
      @required this.redirectGuard,
      @required this.fullPath,
      @required this.page,
      this.parent});

  bool get hasChidlren => children != null && children.isNotEmpty;

  void shakeTheTree() {
    delegate.replace(MatchRoute(route: this));
    if (parent?.delegate != null) {
      parent.shakeTheTree();
    }
  }

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
