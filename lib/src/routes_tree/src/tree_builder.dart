import 'package:flutter/material.dart';

import '../../qr.dart';
import '../../types.dart';
import 'tree_types.dart';

class TreeBuilder {
  List<QRouteInternal> _buildTree(
      Tree tree, List<QRouteBase> routes, String basePath) {
    final result = <QRouteInternal>[];
    if (routes == null || routes.isEmpty) return result;

    for (var routebase in routes) {
      var route = routebase is QRoute
          ? routebase
          : (routebase as QRouteBuilder).createRoute();

      var path = route.path;
      if (!path.startsWith('/')) {
        path = '/$path';
      }
      final pathSegments = Uri.parse(path).pathSegments;
      if (pathSegments.isEmpty) {
        // There is no path 'Empty path'
        path = '';
      } else if (pathSegments.length == 1) {
        // There is just one segment take it.
        path = pathSegments.first;
      } else {
        // There is mulitble segment, convert them to tree
        var newRoute = route.copyWith(path: pathSegments.last);
        for (var i = pathSegments.length - 2; i >= 0; i--) {
          newRoute = QRoute(
              path: pathSegments[i], page: (c) => c, children: [newRoute]);
        }
        path = pathSegments.first;
        route = newRoute;
      }
      final fullPath = basePath + (path.isEmpty ? '' : '/$path');
      final _route = QRouteInternal(
        key: tree.treeIndex.length + 1,
        isComponent: path.startsWith(':'),
        path: path,
        route: route,
        fullPath: fullPath,
      );
      tree.treeIndex[route.name ?? _route.fullPath] = fullPath;
      // Add children default init
      if (route.children != null &&
          !route.children.any((element) => element.path == '/')) {
        route.children.add(QRoute(
          path: '/',
          name: '${route.name} Init',
          page: (c) => Container(),
        ));
      }
      _route.children.addAll(_buildTree(tree, route.children, fullPath));
      result.add(_route);
      QR.log('"${_route.name}" added with path ${_route.fullPath}',
          isDebug: true);
    }
    return result;
  }

  Tree buildTree(List<QRouteBase> routes) {
    _checkRoutes(routes);
    final tree = Tree();
    tree.routes.addAll(_buildTree(tree, routes, ''));
    return tree;
  }

  void _checkRoutes(List<QRouteBase> routes) {
    if (routes.map((e) => e.path).contains('/notfound') == false) {
      routes.add(QRoute(
          path: '/notfound',
          page: (r) => Material(
                child: Center(
                  child: Text('Page Not Found "${QR.currentRoute.fullPath}"'),
                ),
              )));
    }
  }
}
