import '../../qlevar_router.dart';
import '../routes/qroute_children.dart';
import '../routes/qroute_internal.dart';
import 'middleware_controller.dart';

class MatchController {
  final Uri path;
  final QRouteChildren routes;
  String foundPath;
  final params = QParams();
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
      final match = _tryFind(searchIn, '')!;
      return match;
    }

    final result = _tryFind(searchIn, path.pathSegments[0]);
    if (result == null) {
      return QRouteInternal.notfound();
    }
    var match = result;
    for (var i = 1; i < path.pathSegments.length; i++) {
      searchIn = match.children!;
      match.child = _tryFind(searchIn, path.pathSegments[i]);
      if (match.child == null) {
        return QRouteInternal.notfound();
      }
      match = match.child!;
    }
    return result;
  }

  QRouteInternal? _tryFind(QRouteChildren routes, String path) {
    bool find(QRouteInternal route) => '/$path' == route.route.path;

    bool findComponent(QRouteInternal route) {
      final routePath = route.route.path;
      if (routePath.startsWith('/:')) {
        var name = routePath.replaceAll('/:', '');

        if (name.indexOf('(') != -1) {
          final regexRule = name.substring(name.indexOf('('));
          name = name.substring(0, name.indexOf('('));

          final regex = RegExp(regexRule);

          if (regex.hasMatch(path)) {
            params[name] = path;
            return true;
          }
          return false;
        }
        params[name] = path;
        return true;
      }
      return false;
    }

    QRouteInternal? result;
    if (routes.routes.any(find)) {
      result = routes.routes.firstWhere(find);
    }
    // try find component
    else if (routes.routes.any(findComponent)) {
      result = routes.routes.firstWhere(findComponent);
    }
    if (result != null) {
      updateFoundPath(path);
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
