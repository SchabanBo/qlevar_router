import '../../qlevar_router.dart';
import '../routes/qroute_children.dart';
import '../routes/qroute_internal.dart';
import 'middleware_controller.dart';

class MatchController {
  final Uri path;
  final QRouteChildren routes;
  String foundPath;
  final params = QParams();
  final String parentPath;

  /// index of the path segment we are searching for
  int _searchIndex = -1;
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
    var path = findPathFromName(name, params ?? <String, dynamic>{});
    if (foundPath != '/' && path.startsWith(foundPath)) {
      path = path.replaceAll(foundPath, '');
    }
    return MatchController(path, foundPath, routes, params: params);
  }

  void updateFoundPath(String segment) {
    foundPath += "/$segment";
    // If the path is just init path '/' and the found path is
    // not empty then remove the extra slash at the end
    if (path.pathSegments.isEmpty && foundPath.length > 2) {
      foundPath = foundPath.substring(0, foundPath.length - 1);
    }
    // See [#26]
    if (foundPath.length > 1 &&
        foundPath[foundPath.length - 1] == '/' &&
        foundPath[foundPath.length - 2] == '/') {
      foundPath = foundPath.substring(0, foundPath.length - 1);
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
    final result = await _searchMatch();
    QR.params.updateParams(result.getAllParams());
    return result;
  }

  Future<QRouteInternal> _searchMatch() async {
    var searchIn = routes;
    if (path.pathSegments.isEmpty) {
      final match = await _tryFind(searchIn, -1);
      if (match == null) {
        return QRouteInternal.notfound(parentPath + path.toString());
      }
      return match;
    }

    // search from the first segment
    _searchIndex = 0;

    final result = await _tryFind(searchIn, _searchIndex);
    if (result == null) {
      return QRouteInternal.notfound(parentPath + path.toString());
    }
    var match = result;
    while (_searchIndex < path.pathSegments.length) {
      searchIn = match.children!;
      match.child = await _tryFind(searchIn, _searchIndex);
      if (match.child == null) {
        return QRouteInternal.notfound(parentPath + path.toString());
      }
      match = match.child!;
    }
    return result;
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
          print(e);
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

  Future<QRouteInternal?> _tryFind(QRouteChildren routes, int index) async {
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
    // or multi pathes
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
      if (_searchIndex == index && result.route.path != '/!') {
        updateFoundPath(path);
      }
      var newMatch = result.asNewMatch(
          result, foundPath.isEmpty ? '/' : foundPath,
          newParams: params.copyWith());
      await MiddlewareController(newMatch).runOnMatch();
      return newMatch;
    }

    QR.log('[$path] is not child of ${routes.parentKey}');
    return null;
  }

  static String findPathFromName(String name, Map<String, dynamic> params) {
    final isPathFound = QR.treeInfo.namePath[name];
    assert(isPathFound != null, 'Path name not found');
    var newPath = isPathFound!;
    final pathParams = <String, dynamic>{};

    // Search for component params
    for (var _param in params.entries) {
      if (newPath.contains(':${_param.key}')) {
        newPath =
            newPath.replaceAll(':${_param.key}', _getParamString(_param.value));
      } else {
        pathParams.addEntries([_param]);
      }
    }

    // Replace old component
    for (var _param in QR.params.asMap.entries) {
      if (newPath.contains(':${_param.key}')) {
        newPath =
            newPath.replaceAll(':${_param.key}', _getParamString(_param.value));
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

  static String _getParamString(dynamic value) {
    if (value is String) return value;
    if (value is int || value is double || value is bool) {
      return value.toString();
    }
    return value.toString();
  }

  static Uri _fixedPathUri(String path) {
    var _fixedPath = Uri.parse(path);

    /// if the path ended with extra slash /
    /// remove it and continue
    if (_fixedPath.pathSegments.isNotEmpty &&
        _fixedPath.pathSegments.last.isEmpty) {
      _fixedPath = _fixedPath.replace(
        pathSegments: ([..._fixedPath.pathSegments])..removeLast(),
      );
    }
    return _fixedPath;
  }
}
