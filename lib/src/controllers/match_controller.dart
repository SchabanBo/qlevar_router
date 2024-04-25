import '../../qlevar_router.dart';
import '../routes/qroute_children.dart';
import '../routes/qroute_internal.dart';
import 'middleware_controller.dart';

class MatchController {
  MatchController(String sPath, this.foundPath, this.routes,
      {Map<String, dynamic>? params})
      : path = _fixedPathUri(sPath),
        parentPath = foundPath {
    if (params != null) {
      this.params.addAll(params);
    }
    QR.log(
        // ignore: lines_longer_than_80_chars
        '${'Finding Match for $sPath under '}${foundPath.isEmpty ? 'root' : 'path $foundPath'}');
  }

  factory MatchController.fromName(
      String name, String foundPath, QRouteChildren routes,
      {Map<String, dynamic>? params}) {
    // Check if this route should be mocked
    if (QR.settings.mockRoute != null) {
      final path = QR.settings.mockRoute!.mockName(name);
      if (path != null) {
        return MatchController(path, foundPath, routes, params: params);
      }
    }
    var path = findPathFromName(name, params ?? <String, dynamic>{});
    if (foundPath != '/' && path.startsWith(foundPath)) {
      path = path.replaceAll(foundPath, '');
    }
    return MatchController(path, foundPath, routes, params: params);
  }

  String foundPath;
  final params = QParams();
  final String parentPath;
  final Uri path;
  final QRouteChildren routes;

  /// index of the path segment we are searching for
  int _searchIndex = -1;

  void updateFoundPath(String segment) {
    foundPath += "/$segment";
    // If the path is just init path '/' and the found path is
    // not empty then remove the extra slash at the end
    if (path.pathSegments.isEmpty && foundPath.length > 2) {
      foundPath = foundPath.substring(0, foundPath.length - 1);
    }

    // check if there is a double slash in the path and remove it
    if (foundPath.contains('//')) {
      foundPath = foundPath.replaceAll('//', '/');
    }

    if (_searchIndex + 1 == path.pathSegments.length && path.hasQuery) {
      foundPath += '?${Uri.decodeFull(path.query)}';
      // Add the query params to the params map if they are not already there
      for (var queryParam in path.queryParameters.entries) {
        if (!params.asMap.containsKey(queryParam.key)) {
          params[queryParam.key] = queryParam.value;
        }
      }
    }
    // update searchIndex after we updated foundPath
    _searchIndex++;
  }

  Future<QRouteInternal> get match async {
    // Check if this route should be mocked
    final isMocked = _isMocked();
    if (isMocked != null) return isMocked;
    final result = await _searchMatch();
    QR.params.updateParams(result.getAllParams());
    return result;
  }

  QRouteInternal? _isMocked() {
    if (QR.settings.mockRoute == null) return null;
    final route = QR.settings.mockRoute!.mockPath(path.toString());
    if (route == null) return null;
    return QRouteInternal.mocked(path.toString(), route);
  }

  Future<QRouteInternal?> _addInitRouterIfNeeded(QRouteInternal route) async {
    // There is no init route
    if (!route.route.withChildRouter) return null;
    // navigator not created, don't add init route
    if (!QR.hasNavigator(route.name)) return null;

    return await _tryFind(route.children!, -1);
  }

  bool isSameComponent(String routeSegment, String segment) {
    if (routeSegment.startsWith('/:')) {
      var name = routeSegment.replaceAll('/:', '');
      if (name.contains('(') && name.contains(')')) {
        try {
          final regexRule = name.substring(name.indexOf('('));
          name = name.substring(0, name.indexOf('('));
          final regex = RegExp(regexRule);
          if (regex.hasMatch(segment)) {
            params[name] = segment;
            return true;
          }
          return false;
        } on FormatException catch (e) {
          QR.log('Error finding regex match for $name: $e');
          return false;
        }
      }
      if (!params.asMap.containsKey(name)) {
        params[name] = segment;
      } else {
        QR.log('Duplicate param name $name');
      }
      return true;
    }
    return false;
  }

  static String findPathFromName(String name, Map<String, dynamic> params) {
    // Check if this route should be mocked
    if (QR.settings.mockRoute != null) {
      final path = QR.settings.mockRoute!.mockName(name);
      if (path != null) return path;
    }
    final isPathFound = QR.treeInfo.namePath[name];
    assert(isPathFound != null, 'Path name not found');
    var newPath = isPathFound!;
    final pathParams = <String, dynamic>{};

    // Search for component params
    for (var param in params.entries) {
      if (newPath.contains(':${param.key}')) {
        newPath =
            newPath.replaceAll(':${param.key}', _getParamString(param.value));
      } else {
        pathParams.addEntries([param]);
      }
    }

    // Replace old component
    for (var param in QR.params.asMap.entries) {
      if (newPath.contains(':${param.key}')) {
        newPath =
            newPath.replaceAll(':${param.key}', _getParamString(param.value));
      }
    }

    if (pathParams.isNotEmpty) {
      newPath = '$newPath?';

      // Build the params
      for (var i = 0; i < pathParams.length; i++) {
        final param = pathParams.entries.toList()[i];
        newPath = '$newPath${param.key}=${_getParamString(param.value)}';
        if (i != pathParams.length - 1) {
          newPath = '$newPath&';
        }
      }
    }
    return newPath;
  }

  Future<QRouteInternal> _searchMatch() async {
    var searchIn = routes;
    if (path.pathSegments.isEmpty) {
      final match = await _tryFind(searchIn, -1);
      if (match == null) {
        return QRouteInternal.notFound(parentPath + path.toString());
      }
      return match;
    }

    // search from the first segment
    _searchIndex = 0;

    final result = await _tryFind(searchIn, _searchIndex);
    if (result == null) {
      return QRouteInternal.notFound(parentPath + path.toString());
    }
    var match = result;
    while (_searchIndex < path.pathSegments.length) {
      if (match.children == null) break;
      searchIn = match.children!;
      match.child = await _tryFind(searchIn, _searchIndex);
      if (match.child == null) {
        return QRouteInternal.notFound(parentPath + path.toString());
      }
      match = match.child!;
    }
    match.child = await _addInitRouterIfNeeded(match);
    return result;
  }

  Future<QRouteInternal?> _tryFind(QRouteChildren routes, int index,
      {bool updatePath = true}) async {
    final path = index == -1 ? '' : this.path.pathSegments[index];

    bool isSamePath(QRouteInternal route) => route.route.path == '/$path';

    bool isComponent(QRouteInternal route) {
      final routePath = route.route.path;
      if (Uri.parse(routePath).pathSegments.length > 1) {
        return false;
      }
      return isSameComponent(routePath, path);
    }

    bool findMulti(QRouteInternal route) {
      final routeUri = Uri.parse(route.route.path);
      // fast path
      if (routeUri.pathSegments.length <= 1 ||
          routeUri.pathSegments.length >
              this.path.pathSegments.length - index) {
        return false;
      }
      var found = true;
      for (var i = 0; i < routeUri.pathSegments.length; i++) {
        if (!(routeUri.pathSegments[i] == this.path.pathSegments[i + index] ||
            isSameComponent('/${routeUri.pathSegments[i]}',
                this.path.pathSegments[i + index]))) {
          found = false;
          break;
        }
      }
      if (found) {
        for (var i = 0; i < routeUri.pathSegments.length; i++) {
          updateFoundPath(this.path.pathSegments[i + index]);
        }
      }
      return found;
    }

    bool findNoPath(QRouteInternal route) => route.route.path == '/!';

    // Try to find matching path
    var foundIndex = routes.routes.indexWhere(isSamePath);

    // if no matching path found try component
    if (foundIndex == -1) {
      foundIndex = routes.routes.indexWhere(isComponent);
    }
    // or multi paths
    if (foundIndex == -1 &&
        index != -1 &&
        // if the length of remaining segments isn't
        // greater than 1, skip searching
        this.path.pathSegments.length - index > 1) {
      foundIndex = routes.routes.indexWhere(findMulti);
    }

    if (foundIndex == -1) {
      foundIndex = routes.routes.indexWhere(findNoPath);
    }

    final result = foundIndex == -1 ? null : routes.routes[foundIndex];

    if (result != null) {
      if (updatePath && _searchIndex == index && result.route.path != '/!') {
        updateFoundPath(path);
      }
      var newMatch = result.asNewMatch(foundPath.isEmpty ? '/' : foundPath,
          newParams: params.copyWith());
      await MiddlewareController(newMatch).runOnMatch();
      return newMatch;
    }

    /// if the path is not found at this point and the we are in the root route
    /// then search for a route with path '/' and search in its children for the wanted path
    /// if found return the route with path '/' as the match to navigate to the wanted path
    /// see #111
    final isRoot = routes.parentKey.name == QRContext.rootRouterName;
    final searchChildren = routes.routes
        .any((child) => child.route.path == '/' && child.children != null);
    if (isRoot && searchChildren) {
      /// check for the wanted path in the children of the route with path '/'
      final slashRoute =
          routes.routes.firstWhere((element) => element.route.path == '/');
      final routeExists =
          await _tryFind(slashRoute.children!, index, updatePath: false);
      if (routeExists != null) {
        return slashRoute.asNewMatch(foundPath.isEmpty ? '/' : foundPath,
            newParams: params.copyWith());
      }
    }

    QR.log('[$path] is not child of ${routes.parentKey}');
    return null;
  }

  static String _getParamString(dynamic value) {
    if (value is String) return value;
    if (value is int || value is double || value is bool) {
      return value.toString();
    }
    return value.toString();
  }

  static Uri _fixedPathUri(String path) {
    var fixedPath = Uri.parse(path);

    /// if the path ended with extra slash /
    /// remove it and continue
    if (fixedPath.pathSegments.isNotEmpty &&
        fixedPath.pathSegments.last.isEmpty) {
      fixedPath = fixedPath.replace(
        pathSegments: ([...fixedPath.pathSegments])..removeLast(),
      );
    }
    return fixedPath;
  }
}
