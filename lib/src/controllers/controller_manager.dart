import '../../qlevar_router.dart';
import '../routes/qroute_children.dart';
import '../types/qroute_key.dart';
import 'qrouter_controller.dart';

class ControllerManager {
  final controllers = <QRouterController>[];

  QRouterController createController(
      String name, List<QRoute> routes, String? initPath) {
    if (hasController(name)) {
      QR.log('A navigator with name [$name] already exist', isDebug: true);
      return controllers.firstWhere((element) => element.key.hasName(name));
    }
    final routePath = QR.treeInfo.namePath[name];
    if (routePath == null) {
      throw Exception('Route with name $name was not found in the tree info');
    }
    final key = QKey(name);
    final controller = QRouterController(
        key,
        QRouteChildren.from(routes, key, routePath == '/' ? '' : routePath),
        initPath ?? '/');
    controllers.add(controller);
    return controller;
  }

  QRouterController withName(String name) =>
      controllers.firstWhere((element) => element.key.hasName(name));

  bool hasController(String name) =>
      controllers.any((element) => element.key.hasName(name));

  bool removeNavigator(String name) {
    if (!hasController(name)) {
      return false;
    }
    controllers.removeWhere((element) => element.key.hasName(name));
    QR.log('Navigator with name [$name] was removed');
    return true;
  }
}
