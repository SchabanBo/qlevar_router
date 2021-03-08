import 'package:flutter/material.dart';

import '../qlevar_router.dart';
import 'controllers/controller_manager.dart';
import 'controllers/qrouter_controller.dart';
import 'helpers/widgets/stack_tree.dart';
import 'routers/qrouter.dart';
import 'routes/qroute.dart';
import 'routes/qroute_internal.dart';
import 'types/qhistory.dart';

class QRContext {
  static const rootRouterName = 'Root';

  final history = QHistory();

  /// The cureent route url
  String get curremtPath => history.current.path;

  /// Set the active navigator name to call with [navigator]
  String activeNavigatorName = QRContext.rootRouterName;

  /// The parameter for the cureent route
  final params = QParams();
  final settings = _QRSettings();
  final treeInfo = _QTreeInfo();

  final _manager = ControllerManager();

  /// Get the root navigator
  QNavigator get rootNavigator => navigatorOf(QRContext.rootRouterName);

  /// Get the active navigator
  QNavigator get navigator => navigatorOf(activeNavigatorName);

  /// return router for a name
  QNavigator navigatorOf(String name) => _manager.withName(name);

  ///  return a router [QRouter] for the given routes
  QRouter createNavigator(String name, List<QRoute> routes,
      {String? initPath}) {
    final controller = createRouterController(name, routes, initPath: initPath);
    return QRouter(controller);
  }

  void removeNavigator(String name) => _manager.removeNavigator(name);

  /// Update the borwser url
  void updateUrlInfo(String url, {bool addHistory = true}) =>
      rootNavigator.updateUrl(url, addHistory: addHistory);

  /// Add this routes as child for the route with name.
  //void expandRoute(String name, List<QRoute> routes) {}
  /// Remove this route from the router
  //void cleanRoute(String routerName, String routeName) {}
  ///go to the route with given name, and can be has a father with this name
  // - void toName(String name, {Map params, String parent}):
  /// a callback that calls that RootDelegate to update the path.
  ///  That path should only set from the root delegate

  /// return the current tree widget
  Widget getActiveTree() {
    return DebugStackTree(_manager.controllers);
  }

  /// create a controller to use with a Navigator
  QRouterController createRouterController(String name, List<QRoute> routes,
          {String? initPath}) =>
      _manager.createController(name, routes, initPath);

  /// Navigate to this path.
  /// The package will try to get the right navigtor to this path
  void to(String path) {
    final controller = _manager.withName(rootRouterName);
    var match = controller.findPath(path);
    _toMatch(match);
  }

  Future<void> _toMatch(QRouteInternal match,
      {String forController = QRContext.rootRouterName}) async {
    final controller = _manager.withName(forController);
    await controller.popUnitOrPushMatch(match, checkChild: false);
    if (match.hasChild) {
      final newControllerName =
          _manager.hasController(match.name) ? match.name : forController;
      await _toMatch(match.child!, forController: newControllerName);
    } else {
      updateUrlInfo(match.activePath!, addHistory: false);
    }
  }

  /// try to pop the last active navigator or go to last path in the history
  bool back() {
    var lastNavi = QR.history.current.navigator;
    if (_manager.hasController(lastNavi)) {
      // Should navigator removed, if the last path in history is the last path
      // in the navigator then we need to pop the navigator before it and colse
      // this one
      if (history.hasLast && lastNavi != history.last.navigator) {
        QR.history.removeLast();
        lastNavi = history.last.navigator;
      }
      final controller = navigatorOf(lastNavi);
      if (controller.canPop) {
        controller.removeLast();
        if (lastNavi != QRContext.rootRouterName) {
          updateUrlInfo(curremtPath, addHistory: false);
        }
        return true;
      }
    }

    if (!history.hasLast) {
      return false;
    }
    to(history.last.path);
    QR.history.removeLast(count: 2);
    return true;
  }

  /// Print a message from the package
  void log(String mes, {bool isDebug = false}) {
    if (settings.enableLog && (!isDebug || settings.enableDebugLog)) {
      settings.logger('QR: $mes');
    }
  }
}

class _QRSettings {
  bool enableLog = true;
  bool enableDebugLog = false;
  // Add the default not found page path without slash.
  QRoute notFoundPage = QRoute(
      path: '/notfound',
      builder: () => Material(child: Center(child: Text('Page Not Found'))));
  Function(String) logger = print;
}

class _QTreeInfo {
  final Map<String, String> namePath = {QRContext.rootRouterName: '/'};
  int routeIndexer = -1;
}
