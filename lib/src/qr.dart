import 'dart:async';

import 'package:flutter/material.dart';

import '../qlevar_router.dart';
import 'controllers/controller_manager.dart';
import 'controllers/match_controller.dart';
import 'controllers/qrouter_controller.dart';
import 'helpers/platform/configure_web.dart'
    if (dart.library.io) 'helpers/platform/configure_non_web.dart';
import 'helpers/widgets/stack_tree.dart';
import 'routes/qroute_children.dart';
import 'routes/qroute_internal.dart';
import 'types/qhistory.dart';
import 'types/qobserver.dart';

part 'qr_navigation.dart';

class QRContext {
  static const rootRouterName = 'Root';

  /// Set the active navigator name to call with [navigator]
  /// by default it is the root navigator
  /// For example if you work on a dashboard and you want to do your changes
  /// from now on only on the dashboard Navigator. Then set this value
  /// to the Dashboard Navigator name and every time you call [QR.navigator]
  /// the Dashboard navigator will be called instated of root navigator
  String activeNavigatorName = QRContext.rootRouterName;

  /// This history for the navigation. It is internal history to help with
  /// back method . Modifying it does not affect the Browser history
  final history = QHistory();

  /// Add observer for the navigation or pop
  final observer = QObserver();

  /// The parameter for the current route [see](https://github.com/SchabanBo/qlevar_router#parameters)
  final params = QParams();

  /// The Settings for this package
  /// this will
  final settings = _QRSettings();

  /// Info about the current route tree
  /// This is internal info for the package
  /// Do not modify it unless you know what you are doing
  /// It is used to help with getting the route path from the route name
  final treeInfo = _QTreeInfo();

  final _manager = ControllerManager();

  /// This is the url of the current route
  String get currentPath => history.isEmpty ? '/' : history.current.path;

  /// Get the current route [QRoute] of the active navigator [navigator]
  /// to change the active navigator use [activeNavigatorName]
  QRoute get currentRoute => navigator.currentRoute;

  /// Get the root navigator
  /// This is the default navigator of the app
  QNavigator get rootNavigator => navigatorOf(QRContext.rootRouterName);

  /// Get the active navigator by [activeNavigatorName]
  /// by default it is the root navigator
  /// For example if you work on a dashboard and you want to do your changes
  /// from now on only on the dashboard Navigator. Then set this value
  /// to the Dashboard Navigator name and every time you call [QR.navigator]
  /// the Dashboard navigator will be called instated of root navigator
  QNavigator get navigator => navigatorOf(activeNavigatorName);

  /// return router for a name
  QNavigator navigatorOf(String name) => _manager.withName(name);

  /// Check if navigator with this name exists
  bool hasNavigator(String name) => _manager.hasController(name);

  /// Get the current context of the active navigator
  BuildContext? get context =>
      (navigator as QRouterController).navKey.currentContext;

  ///  return a router [QRouter] for the given routes
  /// you do not need to give the [initRoute]
  Future<QRouter> createNavigator(
    String name, {
    List<QRoute>? routes,
    QRouteChildren? cRoutes,
    String? initPath,
    QRouteInternal? initRoute,
    List<NavigatorObserver>? observers,
    String? restorationId,
  }) async {
    final controller = await createRouterController(
      name,
      routes: routes,
      cRoutes: cRoutes,
      initPath: initPath,
      initRoute: initRoute,
    );
    return QRouter(
      controller,
      observers: observers,
      restorationId: restorationId,
    );
  }

  /// Remove a navigator with this name
  Future<bool> removeNavigator(String name) => _manager.removeNavigator(name);

  /// Remove the hashtag from url,
  /// call this function before running your app,
  /// Somewhere before calling `runApp()` do:
  ///```dart
  /// QR.setUrlStrategy();
  /// ```
  void setUrlStrategy() => configureApp();

  /// check if the current path is the same as the given path
  bool isCurrentPath(String path) => currentPath == path;

  /// check if the current path is the same as the given name and params
  bool isCurrentName(String name, {Map<String, dynamic>? params}) =>
      currentPath ==
      MatchController.findPathFromName(name, params ?? <String, dynamic>{});

  /// Update the browser url
  void updateUrlInfo(
    String url, {
    Map<String, dynamic>? params,
    QKey? mKey,
    String? navigator,
    bool addHistory = true,
    bool updateParams = false,
  }) =>
      rootNavigator.updateUrl(
        url,
        mKey: mKey,
        params: params,
        navigator: navigator,
        updateParams: updateParams,
        addHistory: addHistory,
      );

  /// return the current tree widget
  Widget getActiveTree() {
    return DebugStackTree(_manager.controllers);
  }

  /// create a controller to use with a Navigator
  Future<QRouterController> createRouterController(
    String name, {
    List<QRoute>? routes,
    QRouteChildren? cRoutes,
    String? initPath,
    QRouteInternal? initRoute,
  }) =>
      _manager.createController(name, routes, cRoutes, initPath, initRoute);

  /// create a state to use with a declarative router
  QDeclarativeController createDeclarativeRouterController(QKey key) =>
      _manager.createDeclarativeRouterController(key);

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
    observer.onNavigate.clear();
    observer.onPop.clear();
    treeInfo.namePath[rootRouterName] = '/';
    treeInfo.routeIndexer = -1;
    settings.reset();
  }
}

const Widget _iniPage = Material(child: Center(child: Text('Loading')));
final _notFoundPage = QRoute(
  path: '/notfound',
  builder: () => const Material(child: Center(child: Text('Page Not Found'))),
);

class _QRSettings {
  /// The logger function to use. By default it uses the print function.
  /// You can use this to log the messages from the package to your own logger.
  Function(String) logger = print;

  /// Set this to true if you want to enable debug logs. This will print
  /// more info about what is happening in the package.
  bool enableDebugLog = false;

  /// Set this to false if you don't want the package to print any logs.
  bool enableLog = true;

  /// The default page to show when the app starts until the first route is loaded.
  Widget initPage = _iniPage;

  /// This can be used for testing. if this is set the package will use the given route
  /// and there will be no need for setting the route tree.
  /// If this is set the null was returned, then the package will search in the routes tree.
  RouteMock? mockRoute;

  /// The page to show when the route is not found. you can change the path to show when a page is not found
  QRoute notFoundPage = _notFoundPage;

  /// Set this to true if you want only one route instance in the stack
  /// e.x. if you have in the stack a route `home/store/2` and then navigate to
  /// `home/store/4`, if this setting is true then the old `home/store/2` will
  /// be deleted and the new  `home/store/4` will be added.
  /// if this setting is false the new  `home/store/4` will be added
  /// and the stack will have two routes but with different params
  bool oneRouteInstancePerStack = false;

  /// The type of the pages to use. By default it uses the QPlatformPage.
  /// This will set the transition type for all pages.
  /// if a route dose not have a pagesType set then this will be used.
  /// [More info](https://github.com/SchabanBo/qlevar_router#page-transition)
  QPage pagesType = const QPlatformPage();

  /// Set this to true if you want to enable auto restoration.
  /// This will set the [Navigator.restorationScopeId] automatically for all navigators
  /// and will set the restorationId for all routes.
  /// [More info](https://github.com/SchabanBo/qlevar_router##restoration-management)
  bool autoRestoration = false;

  /// The global middlewares to use for all routes. This will be run on every route.
  final List<QMiddleware> globalMiddlewares = [];

  /// reset the settings to the default values.
  void reset() {
    logger = print;
    enableDebugLog = false;
    enableLog = true;
    initPage = _iniPage;
    notFoundPage = _notFoundPage;
    oneRouteInstancePerStack = false;
    pagesType = const QPlatformPage();
    mockRoute = null;
    globalMiddlewares.clear();
  }
}

class _QTreeInfo {
  final Map<String, String> namePath = {QRContext.rootRouterName: '/'};
  int routeIndexer = -1;
}
