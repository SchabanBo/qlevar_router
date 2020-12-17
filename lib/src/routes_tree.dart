import 'dart:math';

import 'package:flutter/cupertino.dart';

import 'router.dart';
import 'types.dart';

class RoutesTree {
  final List<_QRoute> _routes = [];

  List<_QRoute> buildTree(List<QRoute> routes, String basePath) {
    final result = <_QRoute>[];
    if (routes == null || routes.isEmpty) return result;
    for (var route in routes) {
      var path = route.path;
      if (path.startsWith('/')) {
        path = path.substring(1);
      }
      final fullPath = basePath + (path.isEmpty ? '' : '/$path');
      final _route = _QRoute(
        name: route.name ?? path,
        path: path,
        page: route.page,
        redirectGuard: route.redirectGuard ?? (s) => null,
        fullPath: fullPath,
      );
      _route.children.addAll(buildTree(route.children, fullPath));
      result.add(_route);
      QR.log('"${_route.name}" added with base $basePath');
    }
    return result;
  }

  void setTree(List<QRoute> routes) {
    if (_routes.isNotEmpty) {
      QR.log('Tree already set');
      return;
    }

    _routes.addAll(buildTree(routes, ''));
  }

  void setRootDelegate(QRouterDelegate delegate) {
    for (var item in _routes) {
      item.delegate = delegate;
    }
  }

  MatchRoute _getMatchWithParent(String path, String parentPath) {
    var searchIn = _routes;
    for (var item in Uri.parse(parentPath).pathSegments) {
      searchIn =
          MatchRoute.fromTree(routes: searchIn, path: item).route.children;
    }
    return MatchRoute.fromTree(routes: searchIn, path: path);
  }

  MatchRoute getMatch(String path, {String parentPath}) {
    parentPath = parentPath ?? '';
    QR.log('matching for $path for parent: $parentPath');

    if (parentPath.isNotEmpty) {
      return _getMatchWithParent(path, parentPath);
    }

    // Check if the same route
    if (path == QR.currentRoute.fullPath && QR.currentRoute.match != null) {
      return QR.currentRoute.match;
    }
    final currentRoute = Uri.parse(QR.currentRoute.fullPath).pathSegments;
    final newRoute = Uri.parse(path).pathSegments;

    // InitalRoute
    if (newRoute.isEmpty) {
      return MatchRoute.fromTree(routes: _routes, path: '');
    }

    var searchIn = _routes;
    _QRoute parent;
    var matchLevel = 0;
    // Search for the match level
    for (matchLevel;
        matchLevel < min(newRoute.length, currentRoute.length);
        matchLevel++) {
      if (currentRoute[matchLevel] != newRoute[matchLevel]) {
        break;
      }

      parent = searchIn
          .firstWhere((element) => element.path == currentRoute[matchLevel]);
      searchIn = parent.children;
    }
    // Clean the unused route.
    _cleanTree(searchIn);

    // return the new match
    final match =
        MatchRoute.fromTree(routes: searchIn, path: newRoute[matchLevel++]);
    searchIn = match.route.children;
    // TODO: check if not found for match

    // build rest tree
    var childMatch = match;
    for (matchLevel; matchLevel < newRoute.length; matchLevel++) {
      searchIn = childMatch.route.children;
      childMatch.childMatch =
          MatchRoute.fromTree(routes: searchIn, path: newRoute[matchLevel]);
      // TODO: check if not found for child
      childMatch = childMatch.childMatch;
    }

    //Set initRoute
    final initMatch = MatchRoute.fromTree(routes: searchIn, path: '');
    // TODO: check if not found for child
    childMatch.childMatch = initMatch;

    // Set current route info
    QR.currentRoute.fullPath = path;
    QR.currentRoute.match = match;
    return match;
  }

  void _cleanTree(List<_QRoute> routes) {}
}

class _QRoute {
  final String name;
  final String path;
  final String fullPath;
  final RedirectGuard redirectGuard;
  final QRouteBuilder page;
  QRouterDelegate delegate;

  final List<_QRoute> children = [];

  _QRoute(
      {this.name,
      @required this.path,
      @required this.page,
      @required this.redirectGuard,
      @required this.fullPath});

  bool get hasChidlren => children != null && children.isNotEmpty;

  @override
  String toString() =>
      'fullPath: $fullPath, path: $path, hasChidlren: $hasChidlren';
}

class MatchRoute {
  final _QRoute route;
  MatchRoute childMatch;
  MatchRoute({
    @required this.route,
    this.childMatch,
  });

  factory MatchRoute.fromTree({List<_QRoute> routes, String path}) {
    if (routes.isEmpty) {
      return null;
    }
    assert(routes.any((element) => element.path == path),
        'Path [$path] not set in the route tree');
    final match = routes.firstWhere((element) => element.path == path);
    final redirect = match.redirectGuard(QR.currentRoute.fullPath);
    if (redirect != null) {
      return QR.findMatch(redirect);
    }
    return MatchRoute(route: match);
  }
}
