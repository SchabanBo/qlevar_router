import '../../qlevar_router.dart';
import 'qroute_internal.dart';

class QRouteChildren {
  final QKey parentKey;
  final String parentFullPath;
  final List<QRouteInternal> _routes;

  List<QRouteInternal> get routes => _routes;

  QRouteChildren(this._routes, this.parentKey, this.parentFullPath)
      : assert(_routes.isNotEmpty);

  factory QRouteChildren.from(
      List<QRoute> routes, QKey parentKey, String currentPath) {
    final result = <QRouteInternal>[];
    for (var route in routes) {
      final internal = QRouteInternal.from(route, currentPath);
      result.add(internal);
    }
    return QRouteChildren(result, parentKey, currentPath);
  }

  void add(List<QRoute> routes) {
    for (var route in routes) {
      if (_routes.any((element) => element.route.path == route.path)) {
        QR.log('Path ${route.path} already exist, cannot add');
        continue;
      }
      final internal = QRouteInternal.from(route, parentFullPath);
      _routes.add(internal);
      QR.log('$internal was add to $parentKey');
    }
  }

  void remove(List<String> routesNames) {
    for (var name in routesNames) {
      bool finder(QRouteInternal element) => element.key.hasName(name);
      if (_routes.any(finder)) {
        _routes.removeWhere(finder);
        QR.log('$name is removed from $parentKey');
        QR.treeInfo.namePath.remove(name);
        return;
      }
      QR.log('$name is not child of from $parentKey. Can not remove it');
    }
  }
}
