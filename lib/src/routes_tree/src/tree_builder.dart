import 'package:flutter/material.dart';

import '../../helpers/iterables_extensions.dart';
import '../../qr.dart';
import '../../types.dart';
import 'tree_types.dart';

class TreeBuilder {
  List<QRouteInternal> _buildTree(
      Tree tree, List<QRouteBase> routes, String basePath) {
    final result = <QRouteInternal>[];
    if (routes == null || routes.isEmpty) return result;

    for (var route in _prepareTree(routes)) {
      final path = route.path;
      final fullPath = basePath + (path.isEmpty ? '' : '/$path');
      final _route = QRouteInternal(
        key: tree.treeIndex.length + 1,
        isComponent: path.startsWith(':'),
        path: path,
        route: route,
        fullPath: fullPath,
      );
      if (route.name != null) {
        tree.treeIndex[route.name] = fullPath;
      }

      // Add children default init
      final needInitRoute = route.children.notNullOrEmpty &&
          (!route.children.any((element) => element.path == '/') ||
              route.initRoute == null);
      if (needInitRoute) {
        route.children.add(QRoute(
          path: '/',
          name: '${route.name} Init',
          page: (c) => Container(),
          pageType: route.pageType,
        ));
      }
      _route.children.addAll(_buildTree(tree, route.children, fullPath));
      result.add(_route);
      QR.log('"${_route.name}" added with path ${_route.fullPath}',
          isDebug: true);
    }
    return result;
  }

  List<QRoute> _prepareTree(List<QRouteBase> routes) {
    final result = <QRoute>[];
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
              path: pathSegments[i],
              page: (c) => c.childRouter,
              children: [newRoute],
              pageType: route.pageType);
        }
        path = pathSegments.first;
        route = newRoute;
      }
      result.add(route.copyWith(path: path));
    }
    final groups = result.groupBy((r) => r.path);
    if (!groups.entries.any((element) => element.value.length > 1)) {
      return result;
    }

    // Group matching path
    final groupedRoutes = <QRoute>[];
    for (var group in groups.entries) {
      if (group.value.length == 1) {
        groupedRoutes.add(group.value.first);
        continue;
      }

      bool notHasChildren(QRoute element) =>
          element.children == null || element.children.isEmpty;

      final newRoute = group.value.any(notHasChildren)
          ? group.value.firstWhere(notHasChildren)
          : QRoute(
              path: group.key,
              page: (c) => c.childRouter,
              pageType: group.value.first.pageType);

      final children = group.value
          .where((e) => e.children.notNullOrEmpty)
          .map((e) => e.children)
          .fold<List<QRouteBase>>(<QRouteBase>[], (list, route) {
        list.addAll(route);
        return list;
      }).toList();

      groupedRoutes.add(newRoute.copyWith(children: children));
    }
    return groupedRoutes;
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
          path: '/${QR.settings.notFoundPagePath}',
          page: (r) => Material(
                child: Center(
                  child: Text('Page Not Found "${QR.currentRoute.fullPath}"'),
                ),
              )));
    }
  }
}
