import '../../../qlevar_router.dart';
import 'match_context.dart';

class Tree {
  final routes = <QRouteInternal>[];
  final treeIndex = <String, String>{};
}

class QRouteInternal {
  final int key;
  final String path;
  final String fullPath;
  final bool isComponent;
  final QRoute route;
  final List<QRouteInternal> children = [];

  QRouteInternal({
    this.key,
    this.path,
    this.fullPath,
    this.route,
    this.isComponent = false,
  });

  String get name => route?.name;

  QRouteInternal copyWith({String path, String fullPath}) {
    final result = QRouteInternal(
        key: key,
        path: path ?? this.path,
        fullPath: fullPath ?? this.fullPath,
        route: route,
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
  final QRouteInternal route;
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
      {List<QRouteInternal> routes, String path, String childInit}) {
    if (routes.isEmpty) {
      return null;
    }
    if (!routes.any((route) => route.path == path || route.isComponent)) {
      return MatchRoute.notFound();
    }

    var matchs = routes.where((route) => route.path == path);
    final params = <String, dynamic>{};
    QRouteInternal match;
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

  MatchContext toMatchContext({MatchContext childContext}) => MatchContext(
      route: route.route,
      isComponent: route.isComponent,
      key: route.key,
      fullPath: route.fullPath,
      childContext: childContext);

  Map<String, dynamic> getParames() {
    final result = params;
    if (childMatch != null) {
      result.addAll(childMatch.getParames());
    }
    return result;
  }

  String checkRedirect(String path) {
    final redirect = route.route.redirectGuard == null
        ? null
        : route.route.redirectGuard(path);
    return redirect != null
        ? redirect
        : childMatch == null
            ? null
            : childMatch.checkRedirect(path);
  }

  @override
  String toString() =>
      'key: ${route.key}, name: ${route.route.name} found: $found';
}
