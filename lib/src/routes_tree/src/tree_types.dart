import '../../../qlevar_router.dart';
import 'match_context.dart';

class Tree {
  final routes = <QRouteInternal>[];
  final treeIndex = <String, String>{};
}

class QRouteInternal {
  final int key;
  final String name;
  final String path;
  final String fullPath;
  final Function onInit;
  final RedirectGuard redirectGuard;
  final Function onDispose;
  final QRoutePage page;
  final bool isComponent;
  final List<QRouteInternal> children = [];

  QRouteInternal(
      {this.name,
      this.isComponent = false,
      this.key,
      this.path,
      this.page,
      this.redirectGuard,
      this.onInit,
      this.onDispose,
      this.fullPath});

  QRouteInternal copyWith({String name, String path, String fullPath}) {
    final result = QRouteInternal(
        fullPath: fullPath ?? this.fullPath,
        name: name ?? this.name,
        path: path ?? this.path,
        page: page,
        onInit: onInit,
        onDispose: onDispose,
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

  MatchContext toMatchContext(
          {QRouter<dynamic> router, MatchContext childContext}) =>
      MatchContext(
          name: route.name,
          isComponent: route.isComponent,
          onDispose: route.onDispose,
          onInit: route.onInit,
          key: route.key,
          fullPath: route.fullPath,
          page: route.page,
          childContext: childContext,
          router: router);

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
