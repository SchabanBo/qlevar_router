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
  int _searchIndex = 0;
  MatchController(String sPath, this.foundPath, this.routes)
      : path = Uri.parse(sPath),
        parentPath = foundPath {
    QR.log(
        // ignore: lines_longer_than_80_chars
        '${'Finding Match for $sPath under '}${foundPath.isEmpty ? 'root' : 'path $foundPath'}');
  }

  factory MatchController.fromName(
      String name, String foundPath, QRouteChildren routes,
      {Map<String, dynamic>? params}) {
    final path = findPathFromName(name, params ?? <String, dynamic>{});
    return MatchController(path, '', routes);
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
    if ((path.pathSegments.isEmpty ||
            (path.pathSegments.isNotEmpty &&
                path.pathSegments.last == segment)) &&
        path.hasQuery) {
      foundPath += '?${path.query}';
      params.addAll(path.queryParameters);
    }
  }

  QRouteInternal get match {
    var searchIn = routes;
    if (path.pathSegments.isEmpty) {
      final match = _tryFind(searchIn, -1);
      if (match == null) {
        return QRouteInternal.notfound(parentPath + path.toString());
      }
      return match;
    }

    final result = _tryFind(searchIn, _searchIndex);
    if (result == null) {
      return QRouteInternal.notfound(parentPath + path.toString());
    }
    var match = result;
    for (; _searchIndex < path.pathSegments.length;) {
      searchIn = match.children!;
      match.child = _tryFind(searchIn, _searchIndex);
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
      params[name] = segment;
      return true;
    }
    return false;
  }

  QRouteInternal? _tryFind(QRouteChildren routes, int index) {
    var path = index == -1 ? '' : this.path.pathSegments[index];

    bool isSamePath(QRouteInternal route) => route.route.path == '/$path';

    bool isComponent(QRouteInternal route) {
      final routePath = route.route.path;
      if (Uri.parse(routePath).pathSegments.length > 1) {
        return false;
      }
      return isSameComponent(routePath, path);
    }

    var isFind = true;
    bool findMulti(QRouteInternal route) {
      final routeUri = Uri.parse(route.route.path);
      if (routeUri.pathSegments.length <= 1) {
        return false;
      }
      var found = true;
      for (var i = 0; i < routeUri.pathSegments.length; i++) {
        found = found &&
            (routeUri.pathSegments[i] == this.path.pathSegments[i + index] ||
                isSameComponent('/${routeUri.pathSegments[i]}',
                    this.path.pathSegments[i + index]));
      }
      if (found && isFind) {
        for (var i = 0; i < routeUri.pathSegments.length; i++) {
          _searchIndex++;
          updateFoundPath(this.path.pathSegments[i + index]);
        }
        isFind = false;
      }
      return found;
    }

    QRouteInternal? result;
    if (routes.routes.any(isSamePath)) {
      // Try to find matching path
      result = routes.routes.firstWhere(isSamePath);
    } else if (routes.routes.any(isComponent)) {
      // if no matching path found try component
      result = routes.routes.firstWhere(isComponent);
    } else if (routes.routes.any(findMulti)) {
      // or multi pathes
      result = routes.routes.firstWhere(findMulti);
    }

    if (result != null) {
      if (index == -1 || _searchIndex == index) {
        updateFoundPath(path);
        _searchIndex++;
      }
      result.clean();
      result.activePath = foundPath;
      result.params = params.copyWith();
      MiddlewareController(result).runOnMatch();
      return result;
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
        newPath = newPath.replaceAll(':${_param.key}', _param.value.toString());
      } else {
        pathParams.addEntries([_param]);
      }
    }

    // Replace old component
    for (var _param in QR.params.asMap.entries) {
      if (newPath.contains(':${_param.key}')) {
        newPath = newPath.replaceAll(':${_param.key}', _param.value.toString());
      }
    }

    if (pathParams.isNotEmpty) {
      newPath = '$newPath?';
      // Build the params
      for (var i = 0; i < pathParams.length; i++) {
        final param = pathParams.entries.toList()[i];
        newPath = '$newPath${param.key}=${param.value}';
        if (i != pathParams.length - 1) {
          newPath = '$newPath&';
        }
      }
    }
    return newPath;
  }
}
