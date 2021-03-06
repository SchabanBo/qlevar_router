import 'package:flutter/material.dart';

import '../qlevar_router.dart';
import 'controllers/qcontroller.dart';
import 'controllers/qrouter_controller.dart';
import 'routers/qrouter.dart';
import 'routes/qroute.dart';
import 'types/qhistory.dart';

class QRContext {
  static const rootRouterName = 'Root';

  final history = <QHistoryEntry>[];

  /// The cureent route url
  String get curremtPath => history.last.path;

  /// Set the active navigator name to call with [navigator]
  String activeNavigatorName = QRContext.rootRouterName;

  /// The parameter for the cureent route
  final params = QParams();
  final settings = _QRSettings();
  final treeInfo = _QTreeInfo();

  final _controller = QRController();

  /// Get the root navigator
  QNavigator get rootNavigator => navigatorOf(QRContext.rootRouterName);

  /// Get the active navigator
  QNavigator get navigator => navigatorOf(activeNavigatorName);

  /// create a controller for a route
  QRouterController createRouterController(String name, List<QRoute> routes,
          {String? initPaht}) =>
      _controller.createRouterController(name, routes, initPaht ?? '/');

  ///  return a router [QRouter] for the given routes
  QRouter createRouter(String name, List<QRoute> routes) {
    final controller = createRouterController(name, routes);
    return QRouter(controller);
  }

  /// Update the borwser url
  //void updateUrl(String url) => updateUrlInfo(RouteInformation(location: url));

  /// Update the borwser url
  //void updateUrlInfo(RouteInformation url) => urlController.updateUrl(url);

  /// Add this routes as child for the route with name.
  void expandRoute(String name, List<QRoute> routes) {
    //TODO
  }

  bool back() => _controller.back();

  /// Remove this route from the router
  void cleanRoute(String routerName, String routeName) {
    //TODO
  }

  /// return router for a name
  QNavigator navigatorOf(String name) => _controller.of(name);

  /// Navigate to this path.
  /// The package will try to get the right navigtor to this path
  void to(String path) => _controller.to(path);

  // QRootRouter delegate(Routes routes): return the main router delegate
// - QRouter activeRouter: return the current router
// - void toName(String name, {Map params, String parent}): go to the route with given name, and can be has a father with this name
// - void back(): go to previous page
// - String activePath: the current path
// - void updatePath(String path): a callback that calls that RootDelegate to update the path. That path should only set from the root delegate
// - QParams params: params collection
// - Widget getActiveTree(): return the current tree widget

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
