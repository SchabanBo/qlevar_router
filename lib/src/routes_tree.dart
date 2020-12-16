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
      var path = route.path.trim();
      if (path.startsWith('/')) {
        path = path.substring(1);
      }
      final fullPath = '$basePath/$path';
      final _route = _QRoute(
        page: route.page,
        path: path,
        redirectGuard: route.redirectGuard ?? (s) => null,
        fullPath: fullPath,
        key: key,
      );
      _route.children.addAll(buildTree(route.children, fullPath, path, _route));
      QR.log('"$fullPath" added with path: $path, key "$key"');
      result.add(_route);
    }
    return result;
  }

  void setTree(List<QRoute> routes, String baseKey) {
    assert(_routes.isEmpty, 'Tree already set');
    buildTree(routes, '', baseKey, null).forEach(_routes.add);
  }

  MatchRoute getMatch(String path) {
    // if (path == '/' && _routes.any((element) => element.path == path)) {
    //   final match = _routes.firstWhere((element) => element.path == path);
    //   QR.log('Route $match found for $path.');
    //   final redrict = match.redirectGuard(path);
    //   if (redrict != null) {
    //     QR.log('Redirect to $redrict');
    //     return getMatch(redrict);
    //   }
    //   return MatchRoute(route: match);
    // }
    final segments =Uri.parse(path).pathSegments.toList();
    segments.add('');    
    var searchIn = _routes;
    for (var part in segments) {
      final match = searchIn.firstWhere((element) => element.path == '$part');
      QR.log('Part $match found for $part.');
      final redrict = match.redirectGuard(path);
      if (redrict != null) {
        QR.log('Redirect to $redrict');
        return getMatch(redrict);
      }
      if (segments.indexOf(part) == segments.length - 1) {
        QR.log('Route found $path');
        return MatchRoute(route: match);
      }
      match.delegate.replace(MatchRoute(route: match));
      searchIn = match.children;
    }
    assert(true, 'Path [$path] not set in the route tree');
    return MatchRoute(route: null);
  }

  void setDelegate(String key, QRouterDelegate delegate) {
    _routes.where((element) => element.key == key).forEach((element) {
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
