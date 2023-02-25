import '../../qlevar_router.dart';
import '../routes/qroute_children.dart';
import '../routes/qroute_internal.dart';
import 'qrouter_controller.dart';

class ControllerManager {
  final controllers = <QRouterController>[];
  final dControllers = <QDeclarativeController>[];

  Future<QRouterController> createController(
    String name,
    List<QRoute>? routes,
    QRouteChildren? cRoutes,
    String? initPath,
    QRouteInternal? initRoute,
  ) async {
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
    final controller = QRouterController(key, cRoutes);
    await controller.initialize(initPath: initPath, initRoute: initRoute);
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

  bool isDeclarative(int key) =>
      dControllers.any((element) => element.widget.routeKey.hasKey(key));

  QDeclarativeController getDeclarative(int key) =>
      dControllers.firstWhere((element) => element.widget.routeKey.hasKey(key));

  QRouterController withName(String name) {
    if (controllers.any((element) => element.key.hasName(name))) {
      return controllers.firstWhere((element) => element.key.hasName(name));
    }
    if (QR.settings.mockRoute != null) {
      return QRouterController(
        QKey(name),
        QRouteChildren(
          [QRouteInternal.from(QRoute.empty, '/')],
          QKey(name),
          '/',
        ),
      );
    }
    throw Exception('No router was set in the app');
  }

  bool hasController(String name) =>
      controllers.any((element) => element.key.hasName(name));

  Future<bool> removeNavigator(String name) async {
    if (!hasController(name)) {
      return false;
    }
    final controller = withName(name);
    await controller.disposeAsync();
    controllers.remove(controller);
    QR.log('Navigator with name [$name] was removed');
    return true;
  }

  /// check if any of the navigators has a popup route and return it
  /// otherwise return null
  QRouterController? controllerWithPopup() {
    for (var controller in controllers) {
      if (controller.observer.hasPopupRoute()) {
        return controller;
      }
    }
    return null;
  }
}
