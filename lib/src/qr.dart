import 'package:flutter/material.dart';

import '../qlevar_router.dart';
import 'controllers/controller_manager.dart';
import 'controllers/match_controller.dart';
import 'controllers/qrouter_controller.dart';
import 'helpers/platform/configure_web.dart'
    if (dart.library.io) 'helpers/platform/configure_nonweb.dart';
import 'helpers/widgets/stack_tree.dart';
import 'routers/qrouter.dart';
import 'routes/qroute.dart';
import 'routes/qroute_internal.dart';
import 'types/qhistory.dart';
import 'types/qroute_key.dart';

class QRContext {
  static const rootRouterName = 'Root';

  /// This history for the navigation. It is internal history to help with
  /// back method . Modifying it does not affect the Browser history
  final history = QHistory();

  /// The parameter for the cureent route
  final params = QParams();

  /// The Settings for this package
  final settings = _QRSettings();

  /// Info about the cureent route tree
  final treeInfo = _QTreeInfo();

  final _manager = ControllerManager();

  /// The cureent route url
  String get currentPath => history.isEmpty ? '/' : history.current.path;

  /// Set the active navigator name to call with [navigator]
  /// by default it is the root navigator
  /// For example if you work on a dashboard and you want to do your changes
  /// from now on olny on the dashboard Navi. Then set this value
  /// to the Dashboard Navi name and every time you call [QR.navigator]
  /// the Dashboard navigator will be called instade of root navigator
  String activeNavigatorName = QRContext.rootRouterName;

  /// Get the root navigator
  QNavigator get rootNavigator => navigatorOf(QRContext.rootRouterName);

  /// Get the active navigator
  QNavigator get navigator => navigatorOf(activeNavigatorName);

  /// return router for a name
  QNavigator navigatorOf(String name) => _manager.withName(name);

  ///  return a router [QRouter] for the given routes
  /// you do not need to give the [initRoute]
  QRouter createNavigator(String name, List<QRoute> routes,
      {String? initPath, QRouteInternal? initRoute}) {
    final controller = createRouterController(name, routes,
        initPath: initPath, initRoute: initRoute);
    return QRouter(controller);
  }

  /// Remove a navigator with this name
  bool removeNavigator(String name) => _manager.removeNavigator(name);

  /// Remove the hastag from url,
  /// call this function before running your app,
  /// Somewhere before calling `runApp()` do:
  ///```dart
  /// QR.setUrlStrategy();
  /// ```
  void setUrlStrategy() => configureApp();

  /// Update the borwser url
  void updateUrlInfo(String url,
          {Map<String, String>? params,
          QKey? mKey,
          String? navigator,
          bool addHistory = true}) =>
      rootNavigator.updateUrl(url,
          mKey: mKey,
          params: params,
          navigator: navigator,
          addHistory: addHistory);

  /// Add this routes as child for the route with name.
  // void expandRoute(String name, List<QRoute> routes) {}
  // Remove this route from the router
  //void cleanRoute(String routerName, String routeName) {}

  /// return the current tree widget
  Widget getActiveTree() {
    return DebugStackTree(_manager.controllers);
  }

  /// create a controller to use with a Navigator
  QRouterController createRouterController(String name, List<QRoute> routes,
          {String? initPath, QRouteInternal? initRoute}) =>
      _manager.createController(name, routes, initPath, initRoute);

  /// Navigate to this path.
  /// The package will try to get the right navigtor to this path.
  Future<void> to(String path, {bool ignoreSamePath = true}) async {
    if (ignoreSamePath && currentPath == path) {
      return;
    }
    final controller = _manager.withName(rootRouterName);
    var match = controller.findPath(path);
    await _toMatch(match);
  }

  /// Go to a route with given name
  Future<void> toName(String name,
      {Map<String, dynamic>? params, bool ignoreSamePath = true}) async {
    if (ignoreSamePath &&
        currentPath ==
            MatchController.findPathFromName(
                name, params ?? <String, dynamic>{})) {
      return;
    }
    final controller = _manager.withName(rootRouterName);
    var match = controller.findName(name, params: params);
    await _toMatch(match);
  }

  Future<void> _toMatch(QRouteInternal match,
      {String forController = QRContext.rootRouterName}) async {
    final controller = _manager.withName(forController);
    // if (controller.isDeclarative) {
    //   controller.updateDeclarative(match: match);
    //   return;
    // }
    await controller.popUnitOrPushMatch(match, checkChild: false);
    if (match.hasChild) {
      final newControllerName =
          _manager.hasController(match.name) ? match.name : forController;
      await _toMatch(match.child!, forController: newControllerName);
    } else if (currentPath != match.activePath!) {
      updateUrlInfo(match.activePath!,
          mKey: match.key,
          params: match.params!.asStringMap(),
          navigator: forController,
          addHistory: false);
    } else if (forController != rootRouterName) {
      (rootNavigator as QRouterController).update(withParams: false);
    }
  }

  /// try to pop the last active navigator or go to last path in the history
  bool back() {
    var lastNavi = QR.history.current.navigator;
    if (_manager.hasController(lastNavi)) {
      // Should navigator be removed? if the last path in history is the last
      // path in the navigator then we need to pop the navigator before it and
      // colse this one
      if (history.hasLast && lastNavi != history.last.navigator) {
        lastNavi = history.last.navigator;
      }
      final controller = navigatorOf(lastNavi);
      if (controller.canPop) {
        controller.removeLast();
        if (lastNavi != QRContext.rootRouterName) {
          (rootNavigator as QRouterController).update(withParams: false);
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

  /// Clear everything.
  void reset() {
    _manager.controllers.clear();
    params.clear();
    history.clear();
    treeInfo.namePath.clear();
    treeInfo.namePath[rootRouterName] = '/';
    treeInfo.routeIndexer = -1;
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
