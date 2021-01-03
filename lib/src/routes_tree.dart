import 'qr.dart';
import 'route_parser.dart';
import 'router.dart';
import 'types.dart';

class RoutesTree {
  final List<_QRoute> _routes = [];
  final _routesIndex = <String, String>{};

  MatchContext _cureentTree;
  QRouterDelegate _rootDelegate;

  // Build the Route Tree.
  List<_QRoute> _buildTree(List<QRoute> routes, String basePath, int key) {
    final result = <_QRoute>[];
    if (routes == null || routes.isEmpty) return result;

    for (var route in routes) {
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
      final _route = _QRoute(
        key: key + routes.indexOf(route),
        name: route.name,
        isComponent: path.startsWith(':'),
        path: path,
        onInit: route.onInit,
        page: route.page,
        onDispose: route.onDispose,
        redirectGuard: route.redirectGuard ?? (s) => null,
        fullPath: fullPath,
      );
      _route.children
          .addAll(_buildTree(route.children, fullPath, key + routes.length));
      result.add(_route);
      key += routes.indexOf(route);
      if (route.name != null) {
        _routesIndex[route.name] = fullPath;
      }
      QR.log('"${_route.name}" added with base $basePath');
    }
    return result;
  }

  QRouterDelegate setTree(
      List<QRoute> routes, QRouterDelegate Function() delegate) {
    if (_routes.isNotEmpty) {
      QR.log('Tree already set');
      return _rootDelegate;
    }

    _routes.addAll(_buildTree(routes, '', 1));
    for (var route in _routes) {
      route.printTree(1);
    }
    _rootDelegate = delegate();
    return _rootDelegate;
  }

  MatchContext getMatch(String path) {
    path = path.trim();
    QR.log('matching for $path', isDebug: true);

    // Check if the same route
    if (path == QR.currentRoute.fullPath && QR.currentRoute.match != null) {
      return QR.currentRoute.match;
    }

    final match = _getMatch(path);

    final redirect = match.checkRedirect(path);
    if (redirect != null) {
      return getMatch(redirect);
    }

    // AddParams
    final params = Uri.parse(path).queryParametersAll;
    for (var item in params.entries) {
      if (item.value.length == 1) {
        match.params.addAll({item.key: item.value.first});
      } else if (item.value.isNotEmpty) {
        match.params.addAll({item.key: item.value});
      }
    }

    // Build Match Context
    var routeNode = match;
    final newTree =
        (_cureentTree != null && routeNode.route.key == _cureentTree.key)
            ? _cureentTree
            : MatchContext.fromRoute(routeNode);
    var contextNode = newTree;

    while (routeNode.childMatch != null) {
      final needInit =
          // There is no previus context
          contextNode.childContext == null ||
              // This is new child route (it has new key)
              routeNode.childMatch.route.key != contextNode.childContext.key ||
              // It is component (can't compare old route. always create new)
              routeNode.childMatch.route.isComponent;

      if (needInit) {
        contextNode.childContext = MatchContext.fromRoute(routeNode.childMatch);
        // If there was no router and the child has a child
        // then we need new router.
        if (contextNode.router == null) {
          contextNode.router = QRouter(
              routeInformationParser: const QRouteInformationParser(),
              routeInformationProvider: QRouteInformationProvider(),
              routerDelegate:
                  QRouterDelegate(matchRoute: contextNode.childContext));
        }
      }

      routeNode = routeNode.childMatch;

      // if there is params update the path on the last child
      // so he can update with new request with new params
      if (routeNode.childMatch == null && match.params.isNotEmpty) {
        contextNode.childContext = contextNode.childContext
            .copyWith(fullPath: path, isComponent: true);
      }
      contextNode = contextNode.childContext;
    }

    // Set current route info
    _cureentTree = newTree;
    QR.currentRoute.fullPath = path;
    QR.currentRoute.params = match.getParames();
    QR.currentRoute.match = newTree;
    QR.history.add(path);
    return newTree;
  }

  MatchRoute _getMatch(String path) {
    final newRoute = Uri.parse(path).pathSegments;

    // Build Match Base
    var searchIn = _routes;
    final match = MatchRoute.fromTree(
        routes: searchIn, path: newRoute.isEmpty ? '' : newRoute[0]);
    if (!match.found) return _notFound(path);
    searchIn = match.route.children;

    // Build Match Tree
    var childMatch = match;
    for (var i = 1; i < newRoute.length; i++) {
      childMatch.childMatch =
          MatchRoute.fromTree(routes: searchIn, path: newRoute[i]);
      if (!childMatch.childMatch.found) return _notFound(path);
      searchIn = childMatch.childMatch.route.children;
      childMatch = childMatch.childMatch;
    }

    // Set initRoute `/` if needed
    if (childMatch.route.hasChidlren) {
      childMatch.childMatch = MatchRoute.fromTree(routes: searchIn, path: '');
      if (!childMatch.childMatch.found) return _notFound(path);
      searchIn = childMatch.childMatch.route.children;
      childMatch = childMatch.childMatch;
    }

    return match;
  }

  void updatePath(String path, QNavigationMode mode) {
    final match = getMatch(path);
    match.setNavigationMode(mode ?? QNavigationMode());
    _rootDelegate.setNewRoutePath(match);
  }

  void updateNamedPath(
      String name, Map<String, dynamic> params, QNavigationMode mode) {
    var path = _routesIndex[name];
    assert(path != null, 'Path name not found');
    final pathParams = <String, dynamic>{};

    // Search for component params
    for (var param in params.entries) {
      if (path.contains(':${param.key}')) {
        path = path.replaceAll(':${param.key}', param.value.toString());
      } else {
        pathParams.addAll(params);
      }
    }
    if (pathParams.isNotEmpty) {
      path = '$path?';
      // Build the params
      for (var i = 0; i < pathParams.length; i++) {
        final param = pathParams.entries.toList()[i];
        path = '$path${param.key}=${param.value}';
        if (i != pathParams.length - 1) {
          path = '$path&';
        }
      }
    }
    updatePath(path, mode);
  }

  // Get match object for notFound Page.
  MatchRoute _notFound(String path) {
    QR.currentRoute.fullPath = path;
    final match = MatchRoute.fromTree(routes: _routes, path: 'notfound');
    return match;
  }
}

class _QRoute {
  final int key;
  final String name;
  final String path;
  final String fullPath;
  final Function onInit;
  final RedirectGuard redirectGuard;
  final Function onDispose;
  final QRouteBuilder page;
  final bool isComponent;
  final List<_QRoute> children = [];

  _QRoute(
      {this.name,
      this.isComponent = false,
      this.key,
      this.path,
      this.page,
      this.redirectGuard,
      this.onInit,
      this.onDispose,
      this.fullPath});

  _QRoute copyWith({String name, String path, String fullPath}) {
    final result = _QRoute(
        fullPath: fullPath ?? this.fullPath,
        name: name ?? this.name,
        path: path ?? this.path,
        page: page,
        redirectGuard: redirectGuard,
        isComponent: isComponent);
    result.children.addAll(children);
    return result;
  }

  bool get hasChidlren => children != null && children.isNotEmpty;

  @override
  String toString() =>
      // ignore: lines_longer_than_80_chars
      'fullPath: $fullPath, path: $path,isComponent: $isComponent hasChidlren: $hasChidlren';

  String _info() =>
      // ignore: lines_longer_than_80_chars
      'key: $key, name: $name, fullPath: $fullPath, path: $path, isComponent: $isComponent';

  void printTree(int width) {
    QR.log(''.padRight(width, '-') + _info());
    for (var item in children) {
      item.printTree(width + 1);
    }
  }
}

class MatchRoute {
  final _QRoute route;
  final bool found;
  final Map<String, dynamic> params;
  MatchRoute childMatch;

  MatchRoute({
    this.route,
    this.found = true,
    this.childMatch,
    this.params,
  });

  factory MatchRoute.notFound() => MatchRoute(found: false);

  factory MatchRoute.fromTree(
      {List<_QRoute> routes, String path, String childInit}) {
    if (routes.isEmpty) {
      return null;
    }
    if (!routes.any((route) => route.path == path || route.isComponent)) {
      return MatchRoute.notFound();
    }

    var matchs = routes.where((route) => route.path == path);
    final params = <String, dynamic>{};
    _QRoute match;
    if (matchs.isEmpty) {
      matchs = routes.where((route) => route.isComponent);
      final component = matchs.first.path.substring(1);
      params.addAll({component: path});
      final fullPath =
          matchs.first.fullPath.replaceAll(matchs.first.path, path);
      match = matchs.first.copyWith(path: path, fullPath: fullPath);
    } else {
      match = matchs.first;
    }
    return MatchRoute(route: match, params: params);
  }

  Map<String, dynamic> getParames() {
    final result = params;
    if (childMatch != null) {
      result.addAll(childMatch.getParames());
    }
    return result;
  }

  String checkRedirect(String path) {
    final redirect = route.redirectGuard(path);
    return redirect != null
        ? redirect
        : childMatch == null
            ? null
            : childMatch.checkRedirect(path);
  }
}
