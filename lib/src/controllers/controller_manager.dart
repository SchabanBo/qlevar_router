import '../../qlevar_router.dart';
import '../routers/qdeclarative._router.dart';
import '../routes/qroute_children.dart';
import '../routes/qroute_internal.dart';
import '../types/qroute_key.dart';
import 'qrouter_controller.dart';

class ControllerManager {
  final controllers = <QRouterController>[];
  final dControllers = <QDeclarativeController>[];

  QRouterController createController(String name, List<QRoute>? routes,
      QRouteChildren? cRoutes, String? initPath, QRouteInternal? initRoute) {
    if (hasController(name)) {
      QR.log('A navigator with name [$name] already exist', isDebug: true);
      return controllers.firstWhere((element) => element.key.hasName(name));
    }
    final routePath = QR.treeInfo.namePath[name];
    if (routePath == null) {
      throw Exception('Route with name $name was not found in the tree info');
    }
    final key = QKey(name);

    if (cRoutes == null) {
      assert(routes != null, 'List<QRoute> or QRouteChildren must be given');
      cRoutes =
          QRouteChildren.from(routes!, key, routePath == '/' ? '' : routePath);
    }
    final controller = QRouterController(key, cRoutes,
        initPath: initPath ?? '/', initRoute: initRoute);
    controllers.add(controller);
    return controller;
  }

  QDeclarativeController createDeclarativeRouterController(QKey key) {
    if (dControllers.any((e) => e.widget.routeKey.hasName(key.name))) {
      dControllers.removeWhere((e) => e.widget.routeKey.hasName(key.name));
    }
    final state = QDeclarativeController();
    dControllers.add(state);
    return state;
  }

  QRouterController withName(String name) =>
      controllers.firstWhere((element) => element.key.hasName(name));

  bool hasController(String name) =>
      controllers.any((element) => element.key.hasName(name));

  bool removeNavigator(String name) {
    if (!hasController(name)) {
      return false;
    }
    final controller = withName(name);
    controller.dispose();
    controllers.remove(controller);
    QR.log('Navigator with name [$name] was removed');
    return true;
  }
}
