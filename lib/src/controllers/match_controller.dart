import '../../qlevar_router.dart';
import '../routes/qroute_children.dart';
import '../routes/qroute_internal.dart';
import 'middleware_controller.dart';

class MatchController {
  final Uri path;
  final QRouteChildren routes;
  String foundPath;
  final params = QParams();
  int _searchIndex = 0;
  MatchController(String sPath, this.foundPath, this.routes)
      : path = Uri.parse(sPath) {
    QR.log('Finding Match for $sPath');
  }

  factory MatchController.fromName(
      String name, String foundPath, QRouteChildren routes,
      {Map<String, dynamic>? params}) {
    final path = findPathFromName(name, params ?? <String, dynamic>{});
    return MatchController(path, '', routes);
  }

  void updateFoundPath(String segment) {
    foundPath += "/$segment";
    if (path.pathSegments.isNotEmpty &&
        path.pathSegments.last == segment &&
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
        return QRouteInternal.notfound();
      }
      return match;
    }

    final result = _tryFind(searchIn, _searchIndex);
    if (result == null) {
      return QRouteInternal.notfound();
    }
    var match = result;
    for (_searchIndex; _searchIndex < path.pathSegments.length;) {
      searchIn = match.children!;
      match.child = _tryFind(searchIn, _searchIndex);
      if (match.child == null) {
        return QRouteInternal.notfound();
      }
      match = match.child!;
    }
    return result;
  }

  QRouteInternal? _tryFind(QRouteChildren routes, int index) {
    bool isSameSegment(String routeSegment, String segment) {
      if (routeSegment == segment) {
        return true;
      }
      // try find component
      if (routeSegment.startsWith(':')) {
        var name = routeSegment.replaceAll(':', '');
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

    var path = index == -1 ? '' : this.path.pathSegments[index];

    var isFind = true;

    bool find(QRouteInternal route) {
      final routeUri = Uri.parse(route.route.path);
      if (routeUri.pathSegments.isEmpty) {
        return path == '';
      }
      if (routeUri.pathSegments.length == 1) {
        return isSameSegment(routeUri.pathSegments.first, path);
      }
      var found = true;
      for (var i = 0; i < routeUri.pathSegments.length; i++) {
        found = found &&
            isSameSegment(
                routeUri.pathSegments[i], this.path.pathSegments[i + index]);
      }
      // if the route was found update the foundpath and the search indexs
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
    if (routes.routes.any(find)) {
      result = routes.routes.firstWhere(find);
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
        newPath = newPath.replaceAll(':${_param.key}', _param.value.value!);
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
