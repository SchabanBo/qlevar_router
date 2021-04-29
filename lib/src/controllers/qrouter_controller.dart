import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../qlevar_router.dart';
import '../helpers/widgets/routes_tree.dart';
import '../overlays/qoverlay.dart';
import '../pages/qpage_internal.dart';
import '../qr.dart';
import '../routes/qroute_children.dart';
import '../routes/qroute_internal.dart';
import '../types/qhistory.dart';
import '../types/qroute_key.dart';
import 'match_controller.dart';
import 'middleware_controller.dart';
import 'pages_controller.dart';

abstract class QNavigator extends ChangeNotifier {
  /// Get if the cureent [QNavigator] can pop or not
  bool get canPop;

  /// Get the current route for this navigator
  QRoute get currentRoute;

  RoutesChildren get getRoutesWidget;

  /// Set the browser [url]
  void updateUrl(String url,
      {Map<String, String>? params,
      QKey? mKey,
      String? navigator = '',
      bool addHistory = true});

  Future<void> pushName(String name, {Map<String, dynamic>? params});

  Future<void> replaceName(String name, String withName,
      {Map<String, dynamic>? params});

  Future<void> replaceAllWithName(String name, {Map<String, dynamic>? params});

  Future<void> popUnitOrPushName(String name, {Map<String, dynamic>? params});

  Future<void> push(String path);

  Future<void> popUnitOrPush(String path);

  Future<void> replace(String path, String withPath);

  Future<void> replaceAll(String path);

  bool removeLast();

  /// Add Routes to this Navigator
  /// You can extand the definded routes for this navigator.
  /// The path of this navigtor will be added to all given routes
  void addRoutes(List<QRoute> routes);

  /// Remove definded routes from this navigator.
  /// you should give the route name or path to remove
  void removeRoutes(List<String> routesNames);

  Future<T?> show<T>(QOverlay overlay);
}

class QRouterController extends QNavigator {
  final QKey key;

  final QRouteChildren routes;

  final _pagesController = PagesController();

  bool isDisposed = false;

  late GlobalKey<NavigatorState> navKey;

  QRouterController(
    this.key,
    this.routes, {
    String? initPath,
    QRouteInternal? initRoute,
  }) {
    if (initRoute != null) {
      addRouteAsync(initRoute);
    } else {
      push(initPath!);
    }
  }

  @override
  QRoute get currentRoute => _pagesController.routes.last.route;

  @override
  RoutesChildren get getRoutesWidget =>
      RoutesChildren(routes, parentPath: routes.parentFullPath);

  @override
  bool get canPop => _pagesController.pages.length > 1;

  List<QPageInternal> get pages => List.unmodifiable(_pagesController.pages);

  QRouteInternal findPath(String path) {
    return MatchController(path, routes.parentFullPath, routes).match;
  }

  QRouteInternal findName(String name, {Map<String, dynamic>? params}) {
    return MatchController.fromName(name, routes.parentFullPath, routes,
            params: params)
        .match;
  }

  @override
  Future<void> pushName(String name, {Map<String, dynamic>? params}) async =>
      await addRouteAsync(findName(name, params: params));

  @override
  bool removeLast() {
    if (!canPop) {
      return false;
    }
    final isPoped = _pagesController.removeLast();
    if (isPoped) {
      update(withParams: true);
    }
    return isPoped;
  }

  @override
  Future<void> replaceName(String name, String withName,
      {Map<String, dynamic>? params}) async {
    // TODO: implement replace
  }

  @override
  Future<void> replaceAllWithName(String name,
      {Map<String, dynamic>? params}) async {
    final match = findName(name, params: params);
    _pagesController.removeAll();
    await addRouteAsync(match);
  }

  @override
  Future<void> push(String path) async {
    final match = findPath(path);
    await addRouteAsync(match);
  }

  @override
  Future<void> replaceAll(String path) async {
    final match = findPath(path);
    _pagesController.removeAll();
    await addRouteAsync(match);
  }

  void updatePathIfNeeded(QRouteInternal match) {
    if (key.name != QRContext.rootRouterName) {
      QR.updateUrlInfo(match.activePath!,
          mKey: match.key,
          params: match.params!.asStringMap(),
          navigator: key.name);
    }
  }

  @override
  Future<void> replace(String path, String withPath) async {
    // TODO: implement replacePath
  }

  Future<void> addRouteAsync(QRouteInternal match,
      {bool notify = true, bool checkChild = true}) async {
    QR.log('adding $match to the navigator with $key');
    QR.params.updateParams(match.params!);
    await _addRoute(match);
    while (checkChild &&
        match.hasChild &&
        !match.route.withChildRouter &&
        !match.isProcessed) {
      await _addRoute(match.child!);
      match = match.child!;
    }

    if (notify && !match.isProcessed && !isDisposed) {
      update();
      updatePathIfNeeded(match);
    }
  }

  Future<void> _addRoute(QRouteInternal route) async {
    if (_pagesController.exist(route) && route.hasChild) {
      // if page already exsit, and has a child, that means the child need
      // to be added, so do not run the middleware for it or add it again
      return;
    }
    if (route.hasMiddlewares) {
      final result = await MiddlewareController(route).runRedirect();
      if (result != null) {
        QR.log('redirect from [${route.activePath}] to [$result]');
        await QR.to(result);
        route.isProcessed = true;
        return;
      }
    }
    QR.history.add(QHistoryEntry(
        route.key, route.activePath!, route.params!, key.name, route.hasChild));
    _pagesController.add(route);
  }

  @override
  Future<void> popUnitOrPush(String path) async {
    await popUnitOrPushMatch(findPath(path));
  }

  @override
  Future<void> popUnitOrPushName(String name,
      {Map<String, dynamic>? params}) async {
    final match =
        MatchController.fromName(name, routes.parentFullPath, routes).match;
    await popUnitOrPushMatch(match);
  }

  Future<void> popUnitOrPushMatch(QRouteInternal match,
      {bool checkChild = true}) async {
    final index = _pagesController.routes
        .indexWhere((element) => element.key.isSame(match.key));
    if (index == -1) {
      // Page not exist add it.
      await addRouteAsync(match, checkChild: checkChild);
      return;
    }

    if (match.hasChild) {
      // page exist and has children
      if (checkChild) {
        await popUnitOrPushMatch(match.child!);
      }
      return;
    }

    // page is exist and has no children
    // then pop unit it or replace it
    if (index == _pagesController.pages.length - 1) {
      // if the same page is on the top, then replace it.
      // remove it from the top and add it again
      _pagesController.removeLast();
      await addRouteAsync(match, checkChild: checkChild);
      return;
    }
    // page exist remove unit it
    final pagesLength = _pagesController.pages.length;
    for (var i = index + 1; i < pagesLength; i++) {
      _pagesController.removeLast();
    }
    update();
  }

  void update({bool withParams = false}) {
    if (withParams) {
      QR.params.updateParams(QR.history.current.params);
    }
    notifyListeners();
  }

  @override
  void updateUrl(String url,
      {Map<String, String>? params,
      QKey? mKey,
      String? navigator,
      bool addHistory = true}) {
    if (key.name != QRContext.rootRouterName) {
      QR.log('Only ${QRContext.rootRouterName} can update the url');
      return;
    }
    final _params = QParams();
    _params.addAll(params ?? Uri.parse(url).queryParameters);
    QR.history.add(QHistoryEntry(mKey ?? QKey('Out Route'), url, _params,
        navigator ?? 'Out Route', false));
    update();
    if (!addHistory) {
      QR.history.removeLast();
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  @override
  void addRoutes(List<QRoute> routes) => this.routes.add(routes);

  @override
  void removeRoutes(List<String> routesNames) => routes.remove(routesNames);

  @override
  Future<T?> show<T>(QOverlay overlay) {
    assert(navKey.currentState != null);
    return overlay.show(
        state: navKey.currentState!, context: navKey.currentContext!);
  }
}
