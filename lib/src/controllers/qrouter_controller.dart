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
import '../types/pop_result.dart';
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

  /// Push tha page with this [name] and this [params] on the top of the stack
  Future<void> pushName(String name, {Map<String, dynamic>? params});

  Future<void> replaceName(String name, String withName,
      {Map<String, dynamic>? params});

  Future<void> replaceAllWithName(String name, {Map<String, dynamic>? params});

  Future<void> popUnitOrPushName(String name, {Map<String, dynamic>? params});

  /// Push this [Path] on the top of the stack
  Future<void> push(String path);

  Future<void> popUnitOrPush(String path);

  /// Replace this [path] with this [withPath]
  Future<void> replace(String path, String withPath);

  /// Remove the last page in the stack and add the one with this [path]
  Future<void> replaceLast(String path);

  /// Remove the last page in the stack and add the one with this [name]
  Future<void> replaceLastName(String name);

  /// Remove all pages and add the page with [path]
  Future<void> replaceAll(String path);

  /// remove the last page in the stack
  Future<PopResult> removeLast();

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
    } else if (initPath != null) {
      push(initPath);
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

  Future<QRouteInternal> findPath(String path) =>
      MatchController(path, routes.parentFullPath, routes).match;

  Future<QRouteInternal> findName(String name,
          {Map<String, dynamic>? params}) =>
      MatchController.fromName(name, routes.parentFullPath, routes,
              params: params)
          .match;

  @override
  Future<void> pushName(String name, {Map<String, dynamic>? params}) async =>
      await addRouteAsync(await findName(name, params: params));

  @override
  Future<PopResult> removeLast() async {
    if (QR.isShowingDialog) {
      navKey.currentState!.pop();
      return PopResult.DialogClosed;
    }
    final isPoped = await _pagesController.removeLast();
    if (isPoped == PopResult.Poped) {
      update(withParams: true);
    }
    return isPoped;
  }

  @override
  Future<void> replaceName(String name, String withName,
      {Map<String, dynamic>? params}) async {
    final index =
        _pagesController.routes.indexWhere((e) => e.route.name == name);
    assert(index != -1, 'Path with name $name was not found in the stack');
    if (!await _pagesController.removeIndex(index)) return;
    QR.history.removeLast();
    await pushName(withName, params: params);
  }

  @override
  Future<void> replaceAllWithName(String name,
      {Map<String, dynamic>? params}) async {
    final match = await findName(name, params: params);
    if (await _pagesController.removeAll() != PopResult.Poped) return;
    await addRouteAsync(match);
  }

  @override
  Future<void> push(String path) async {
    final match = await findPath(path);
    await addRouteAsync(match);
  }

  @override
  Future<void> replaceAll(String path) async {
    final match = await findPath(path);
    if (await _pagesController.removeAll() != PopResult.Poped) return;
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
    final index =
        _pagesController.routes.indexWhere((e) => e.route.path == path);
    assert(index != -1, 'Path $path was not found in the stack');
    if (!await _pagesController.removeIndex(index)) return;
    QR.history.removeLast();
    await push(withPath);
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
      final medCont = MiddlewareController(route);
      final result = await medCont.runRedirect();
      if (result != null) {
        QR.log('redirect from [${route.activePath}] to [$result]');
        await QR.to(result);
        route.isProcessed = true;
        return;
      }
      final resultName = await medCont.runRedirectName();
      if (resultName != null) {
        QR.log('redirect from [${route.activePath}] to name [$resultName]');
        await QR.toName(resultName.name, params: resultName.params);
        route.isProcessed = true;
        return;
      }
    }
    QR.history.add(QHistoryEntry(
        route.key, route.activePath!, route.params!, key.name, route.hasChild));
    await _pagesController.add(route);
  }

  @override
  Future<void> popUnitOrPush(String path) async {
    await popUnitOrPushMatch(await findPath(path));
  }

  @override
  Future<void> popUnitOrPushName(String name,
      {Map<String, dynamic>? params}) async {
    final match =
        await MatchController.fromName(name, routes.parentFullPath, routes)
            .match;
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
      if (await _pagesController.removeLast(allowEmptyPages: true) !=
          PopResult.Poped) return;
      await addRouteAsync(match, checkChild: checkChild);
      return;
    }
    // page exist remove unit it
    final pagesLength = _pagesController.pages.length;
    for (var i = index + 1; i < pagesLength; i++) {
      if (await _pagesController.removeLast() != PopResult.Poped) return;
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

  @override
  Future<void> replaceLast(String path) async {
    if (await _pagesController.removeAll() != PopResult.Poped) return;
    return push(path);
  }

  @override
  Future<void> replaceLastName(String name) async {
    if (await _pagesController.removeAll() != PopResult.Poped) return;
    return pushName(name);
  }
}
