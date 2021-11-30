import 'package:flutter/material.dart';

import '../qlevar_router.dart';
import 'controllers/controller_manager.dart';
import 'controllers/match_controller.dart';
import 'controllers/qrouter_controller.dart';
import 'helpers/platform/configure_web.dart'
    if (dart.library.io) 'helpers/platform/configure_nonweb.dart';
import 'helpers/widgets/stack_tree.dart';
import 'overlays/qoverlay.dart';
import 'routes/qroute_children.dart';
import 'routes/qroute_internal.dart';
import 'types/qhistory.dart';
import 'types/qobserver.dart';

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

  /// Add observer for the navigation or pop
  final observer = QObserver();

  final _manager = ControllerManager();

  bool isShowingDialog = false;

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
  QRouter createNavigator(String name,
      {List<QRoute>? routes,
      QRouteChildren? cRoutes,
      String? initPath,
      QRouteInternal? initRoute}) {
    final controller = createRouterController(name,
        routes: routes,
        cRoutes: cRoutes,
        initPath: initPath,
        initRoute: initRoute);
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

  /// check if the current path is the same as the given path
  bool isCurrentPath(String path) => currentPath == path;

  /// check if the current path is the same as the given name and params
  bool isCurrentName(String name, {Map<String, dynamic>? params}) =>
      currentPath ==
      MatchController.findPathFromName(name, params ?? <String, dynamic>{});

  /// Update the borwser url
  void updateUrlInfo(String url,
          {Map<String, dynamic>? params,
          QKey? mKey,
          String? navigator,
          bool addHistory = true}) =>
      rootNavigator.updateUrl(url,
          mKey: mKey,
          params: params,
          navigator: navigator,
          addHistory: addHistory);

  /// return the current tree widget
  Widget getActiveTree() {
    return DebugStackTree(_manager.controllers);
  }

  Future<T?> show<T>(QOverlay overlay, {String? name}) async =>
      await overlay.show(name: name);

  /// create a controller to use with a Navigator
  QRouterController createRouterController(String name,
          {List<QRoute>? routes,
          QRouteChildren? cRoutes,
          String? initPath,
          QRouteInternal? initRoute}) =>
      _manager.createController(name, routes, cRoutes, initPath, initRoute);

  /// create a state to use with a declarative router
  QDeclarativeController createDeclarativeRouterController(QKey key) =>
      _manager.createDeclarativeRouterController(key);

  /// Navigate to this path.
  /// The package will try to get the right navigtor to this path.
  /// Set [ignoreSamePath] to true to ignore the navigation if the current path
  /// is the same as the route path
  /// Use [pageAlreadyExistAction] to define what to do when
  /// page already is in the stack you can remove the page
  /// or just bring it to the top
  Future<void> to(String path,
      {bool ignoreSamePath = true,
      PageAlreadyExistAction? pageAlreadyExistAction}) async {
    if (ignoreSamePath && isCurrentPath(path)) {
      return;
    }
    final controller = _manager.withName(rootRouterName);
    var match = await controller.findPath(path);
    await _toMatch(match, pageAlreadyExistAction: pageAlreadyExistAction);
  }

  /// Go to a route with given [name] and [params]
  /// Set [ignoreSamePath] to true to ignore the navigation if the current path
  /// is the same as the route path
  /// Use [pageAlreadyExistAction] to define what to do when
  /// page already is in the stack you can remove the page
  /// or just bring it to the top
  Future<void> toName(String name,
      {Map<String, dynamic>? params,
      bool ignoreSamePath = true,
      PageAlreadyExistAction? pageAlreadyExistAction}) async {
    if (ignoreSamePath && isCurrentName(name, params: params)) {
      return;
    }
    final controller = _manager.withName(rootRouterName);
    var match = await controller.findName(name, params: params);
    await _toMatch(match, pageAlreadyExistAction: pageAlreadyExistAction);
  }

  Future<void> _toMatch(QRouteInternal match,
      {String forController = QRContext.rootRouterName,
      PageAlreadyExistAction? pageAlreadyExistAction}) async {
    final controller = _manager.withName(forController);
    await controller.popUntilOrPushMatch(match,
        checkChild: false,
        pageAlreadyExistAction:
            pageAlreadyExistAction ?? PageAlreadyExistAction.Remove);
    if (match.hasChild && !match.isProcessed) {
      final newControllerName =
          _manager.hasController(match.name) ? match.name : forController;
      await _toMatch(match.child!,
          forController: newControllerName,
          pageAlreadyExistAction: pageAlreadyExistAction);
      return;
    }

    if (!match.hasChild && _manager.hasController(match.name)) {
      final _navigator = navigatorOf(match.name) as QRouterController;
      if (_navigator.hasRoutes) {
        match.activePath =
            match.activePath! + navigatorOf(match.name).currentRoute.path;
      }
    }

    if (match.isProcessed) return;
    if (currentPath != match.activePath!) {
      // See [#18]
      final samePathFromInit = match.route.withChildRouter &&
          match.route.initRoute != null &&
          currentPath == (match.activePath! + match.route.initRoute!);
      if (!samePathFromInit) {
        updateUrlInfo(match.activePath!,
            mKey: match.key,
            params: match.params!.asValueMap,
            // The history should be added for the child init route
            // so use the parent name as navigator
            navigator: match.route.name ?? match.route.path,
            // Add history so currentPath become like activePath
            addHistory: true);
        return;
      }
    }
    if (forController != rootRouterName) {
      (rootNavigator as QRouterController).update(withParams: false);
    }
  }

  /// try to pop the last active navigator or go to last path in the history
  Future<PopResult> back() async {
    // is proccesed by declerative
    if (_manager.isDeclarative(QR.history.current.key.key)) {
      final dCon = _manager.getDeclarative(QR.history.current.key.key);
      if (dCon.pop()) {
        return PopResult.Poped;
      }
    }

    final lastNavi = QR.history.current.navigator;
    if (_manager.hasController(lastNavi)) {
      final popNaviOptions = [lastNavi];
      // Should navigator be removed? if the last path in history is the last
      // path in the navigator then we need to pop the navigator before it and
      // close this one
      if (history.hasLast && lastNavi != history.last.navigator) {
        popNaviOptions.add(history.last.navigator);
      }

      for (final navi in popNaviOptions) {
        final controller = navigatorOf(navi);

        final popResult = await controller.removeLast();
        if (popResult != PopResult.NotPoped) {
          if (popResult != PopResult.Poped) return popResult;
          if (navi != QRContext.rootRouterName) {
            (rootNavigator as QRouterController).update(withParams: false);
          }
          return PopResult.Poped;
        }
      }
    }

    if (!history.hasLast) {
      return PopResult.NotPoped;
    }
    to(history.last.path);
    QR.history.removeLast(count: 2);
    return PopResult.Poped;
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
    observer.onNavigate.clear();
    observer.onPop.clear();
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

  Widget iniPage =
      Material(child: Container(child: Center(child: Text('Loading'))));
  Function(String) logger = print;
  QPage pagesType = QPlatformPage();

  /// Set this to true if you want only one route instance in the stack
  /// e.x. if you have in the stack a route `home/store/2` and then navigate to
  /// `home/store/4`, if this setting is true then the old `home/store/2` will
  /// be deleted and the new  `home/store/4` will be added.
  /// if this setting is false the new  `home/store/4` will be added
  /// and the stack will have two routes but with different params
  bool oneRouteInstancePerStack = false;
}

class _QTreeInfo {
  final Map<String, String> namePath = {QRContext.rootRouterName: '/'};
  int routeIndexer = -1;
}
