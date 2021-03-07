import '../../qlevar_router.dart';
import '../qr.dart';
import '../routes/qroute_children.dart';
import '../types/qroute_key.dart';
import 'qrouter_controller.dart';

class QRController {
  final _manager = _ControllerManager();
  QRouterController createRouterController(
          String name, List<QRoute> routes, String initPath) =>
      _manager.createController(name, routes, initPath);

  QNavigator of(String name) {
    return _manager.withName(name);
  }

  bool back() {
    final controller = of(QR.history.last.navigator);
    if (controller.canPop) {
      controller.removeLast();
      return true;
    }
    if (QR.history.length < 2) {
      return false;
    }
    to(QR.history.elementAt(QR.history.length - 2).path);
    QR.history.removeRange(QR.history.length - 2, QR.history.length);
    return true;
  }

  void to(String path, {String forController = QRContext.rootRouterName}) {
    final controller = _manager.withName(forController);
    controller.popUnitOrPush(path);
    // if (match.isNotFound) {
    // }
  }
}

class _ControllerManager {
  final _controllers = <QRouterController>[];

  QRouterController createController(
      String name, List<QRoute> routes, String initPath) {
    final routePath = QR.treeInfo.namePath[name];
    if (routePath == null) {
      throw Exception('Route with name $name was not found in the tree info');
    }
    final key = QKey(name);
    final controller = QRouterController(
        key,
        QRouteChildren.from(routes, key, routePath == '/' ? '' : routePath),
        initPath);
    _controllers.add(controller);
    return controller;
  }

  QRouterController withName(String name) =>
      _controllers.firstWhere((element) => element.key.hasName(name));
}
