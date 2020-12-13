import 'types.dart';

class RoutesTree {
  final List<_QRoute> routes = [];
  RoutesTree({List<QRoute> routes});

  List<_QRoute> buildTree(List<QRoute> _routes, String basePath, int level) {
    final result = <_QRoute>[];
    if (_routes == null || _routes.isEmpty) return result;

    for (var route in _routes) {
      final fullPath = basePath + route.path;
      final children = buildTree(route.children, basePath, level++);

      result.add(_QRoute(
        page: route.page,
        path: route.path,
        fullPath: fullPath,
        notifer: QRNotifer(),
        level: level,
        children: children,
      ));
    }

    return result;
  }

  void setTree(List<QRoute> _routes) {
    assert(routes.isNotEmpty, 'Build already set');
    buildTree(_routes, '/', 0).forEach(routes.add);
  }
}

class _QRoute {
  final int level;
  final String path;
  final String fullPath;
  final QRNotifer notifer;
  final QRouteBuilder page;
  final List<_QRoute> children;

  _QRoute(
      {this.level,
      this.path,
      this.fullPath,
      this.notifer,
      this.page,
      this.children});

  bool get hasChidlren => children != null && children.isNotEmpty;
}
