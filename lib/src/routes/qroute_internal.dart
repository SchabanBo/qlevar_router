import 'package:qlevar_router/qlevar_router.dart';

import '../types/qroute_key.dart';
import 'qroute.dart';
import 'qroute_children.dart';

class QRouteInternal {
  /// The key
  final QKey key;

  /// The full path
  final String fullPath;

  /// The orginal definition for this route
  final QRoute route;

  final bool isNotFound;

  String? activePath;

  /// The children for this route
  QRouteChildren? children;

  /// The active parent for this route
  QRouteInternal? parent;

  /// The active child for this route
  QRouteInternal? child;

  QRouteInternal({
    required this.key,
    required this.fullPath,
    required this.route,
    required this.isNotFound,
    this.activePath,
    this.children,
    this.parent,
    this.child,
  });

  factory QRouteInternal.from(QRoute route, String cureentPath) {
    final key = QKey(route.name ?? route.path);
    final fullPath = '$cureentPath/${route.path}';
    return QRouteInternal(
        key: key,
        route: route,
        fullPath: fullPath,
        isNotFound: false,
        children: route.children == null
            ? null
            : QRouteChildren.from(route.children!, key, fullPath));
  }

  factory QRouteInternal.notfound(String foundPath) {
    final route = QR.settings.notFoundPage;
    final key = QKey(route.name ?? route.path);
    final fullPath = '${route.path}';
    return QRouteInternal(
        key: key,
        route: route,
        fullPath: fullPath,
        isNotFound: true,
        activePath: foundPath,
        children: route.children == null
            ? null
            : QRouteChildren.from(route.children!, key, fullPath));
  }

  void clean() {
    child = null;
    activePath = null;
  }

  bool isSmae(QRouteInternal other) => key.isSame(other.key);

  @override
  String toString() => 'Route: $key, Full Path: $fullPath';
}
