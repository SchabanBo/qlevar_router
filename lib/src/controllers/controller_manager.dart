import '../../qlevar_router.dart';
import '../routes/qroute_children.dart';
import '../routes/qroute_internal.dart';
import 'qrouter_controller.dart';

class ControllerManager {
  final controllers = <QRouterController>[];
  final dControllers = <QDeclarativeController>[];

  /// Navigators still initializing, they join [controllers] when done
  final _creating = <String, Future<QRouterController>>{};

  /// Increased by [clear], a navigator created before it is not added
  int _generation = 0;

  /// Forget every navigator, see [QRContext.reset]
  void clear() {
    controllers.clear();
    dControllers.clear();
    _creating.clear();
    _generation++;
  }

  Future<QRouterController> createController(
    String name,
    List<QRoute>? routes,
    QRouteChildren? cRoutes,
    String? initPath,
    QRouteInternal? initRoute,
    bool isTemporary,
  ) async {
    if (hasController(name)) {
      QR.log('A navigator with name [$name] already exist', isDebug: true);
      return controllers.firstWhere((element) => element.key.hasName(name));
    }
    // a second create while the first one is initializing gets the same one
    final creating = _creating[name];
    if (creating != null) return creating;
    final future = _createController(
        name, routes, cRoutes, initPath, initRoute, isTemporary);
    _creating[name] = future;
    try {
      return await future;
    } finally {
      // after clear() a newer navigator may be creating with this name
      if (identical(_creating[name], future)) _creating.remove(name);
    }
  }

  Future<QRouterController> _createController(
    String name,
    List<QRoute>? routes,
    QRouteChildren? cRoutes,
    String? initPath,
    QRouteInternal? initRoute,
    bool isTemporary,
  ) async {
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
    final controller = QRouterController(key, cRoutes, isTemporary);
    final generation = _generation;
    await controller.initialize(initPath: initPath, initRoute: initRoute);
    // not after QR.reset(), it belongs to the old route tree
    if (generation == _generation) controllers.add(controller);
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
        false,
      );
    }
    throw Exception('No navigator with name $name was found');
  }

  bool hasController(String name) =>
      controllers.any((element) => element.key.hasName(name));

  Future<bool> removeNavigator(String name) async {
    if (!hasController(name)) {
      return false;
    }
    final controller = withName(name);
    // remove it before awaiting, nobody may get it while it is disposing,
    // and a new navigator with this name keeps its history
    controllers.remove(controller);
    QR.history.removeWithNavigator(name);
    await controller.disposeAsync();
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
