import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../qlevar_router.dart';
import '../helpers/widgets/routes_tree.dart';
import '../pages/qpage_internal.dart';
import '../routes/qroute_children.dart';
import '../routes/qroute_internal.dart';
import '../types/qhistory.dart';
import '../types/qobserver.dart';
import 'match_controller.dart';
import 'middleware_controller.dart';
import 'pages_controller.dart';

abstract class QNavigator extends ChangeNotifier {
  /// Get if the current [QNavigator] can pop or not
  bool get canPop;

  bool get isTemporary;

  /// Get the current route for this navigator
  QRoute get currentRoute;

  RoutesChildren get getRoutesWidget;

  /// Set the browser [url]
  void updateUrl(String url,
      {Map<String, dynamic>? params,
      QKey? mKey,
      String? navigator = '',
      bool updateParams = false,
      bool addHistory = true});

  /// {@template q.navigator.push}
  /// Push this [Path] on the top of the stack
  /// {@endtemplate}
  Future<void> push(String path);

  /// {@template q.navigator.pushName}
  /// Push tha page with this [name] and this [params] on the top of the stack
  /// {@endtemplate}
  Future<void> pushName(String name, {Map<String, dynamic>? params});

  /// {@template q.navigator.replace}
  /// Replace this [path] with this [withPath]
  /// {@endtemplate}
  Future<void> replace(String path, String withPath);

  /// {@template q.navigator.replaceName}
  /// Replace the page with the page with this [name] and this [params]
  /// {@endtemplate}
  Future<void> replaceName(String name, String withName,
      {Map<String, dynamic>? params, Map<String, dynamic>? withParams});

  /// {@template q.navigator.replaceAll}
  /// Remove all pages and add the page with [path]
  /// {@endtemplate}
  Future<void> replaceAll(String path);

  /// {@template q.navigator.replaceAllWithName}
  /// remove all pages with the page with this [path] and this [params]
  /// {@endtemplate}
  Future<void> replaceAllWithName(String name, {Map<String, dynamic>? params});

  /// {@template q.navigator.popUntilOrPush}
  /// Push this [Path] on the top of the stack, or pop unit it if it's already
  /// in the stack
  /// {@endtemplate}
  Future<void> popUntilOrPush(String path);

  /// {@template q.navigator.popUntilOrPushName}
  /// Push the page with this [name] on the top of the stack, or pop unit it if it's already
  /// in the stack
  /// {@endtemplate}
  Future<void> popUntilOrPushName(String name, {Map<String, dynamic>? params});

  /// {@template q.navigator.switchTo}
  /// Push this path on the top of the stack if not already on the stack
  /// or bring it to top if already on the stack
  /// This is useful to switch between pages without losing the states of them
  /// the defiance between this and [popUntilOrPush] is that no page will
  /// be popped
  /// {@endtemplate}
  Future<void> switchTo(String path);

  /// {@template q.navigator.switchToName}
  /// Push this route name on the top of the stack if not already on the stack
  /// or bring it to top if already on the stack
  /// This is useful to switch between pages without losing the states of them
  /// {@endtemplate}
  Future<void> switchToName(String name, {Map<String, dynamic>? params});

  /// {@template q.navigator.replaceLast}
  /// Remove the last page in the stack and add the one with this [path]
  /// {@endtemplate}
  Future<void> replaceLast(String path);

  /// {@template q.navigator.replaceLastName}
  /// Remove the last page in the stack and add the one with this [name]
  /// {@endtemplate}
  Future<void> replaceLastName(String name, {Map<String, dynamic>? params});

  /// remove the last page in the stack
  Future<PopResult> removeLast({dynamic result});

  /// Add Routes to this Navigator
  /// You can extend the defended routes for this navigator.
  /// The path of this navigator will be added to all given routes
  void addRoutes(List<QRoute> routes);

  /// Remove defended routes from this navigator.
  /// you should give the route name or path to remove
  void removeRoutes(List<String> routesNames);
}

class QRouterController extends QNavigator {
  bool isDisposed = false;
  final QKey key;
  late GlobalKey<NavigatorState> navKey;
  late final observer = QNavigatorObserver(key.name);
  final QRouteChildren routes;
  @override
  final bool isTemporary;

  final _pagesController = PagesController();

  QRouterController(this.key, this.routes, this.isTemporary);

  @override
  void addRoutes(List<QRoute> routes) => this.routes.add(routes);

  @override
  bool get canPop => _pagesController.pages.length > 1;

  @override
  QRoute get currentRoute => _pagesController.routes.last.route;

  @override
  RoutesChildren get getRoutesWidget =>
      RoutesChildren(routes, parentPath: routes.parentFullPath);

  @override
  Future<void> popUntilOrPush(String path) async {
    await popUntilOrPushMatch(await findPath(path));
  }

  @override
  Future<void> popUntilOrPushName(String name,
      {Map<String, dynamic>? params}) async {
    final match = await findName(name, params: params);
    await popUntilOrPushMatch(match);
  }

  @override
  Future<void> push(String path) async {
    final match = await findPath(path);
    await addRouteAsync(match);
  }

  @override
  Future<void> pushName(String name, {Map<String, dynamic>? params}) async =>
      await addRouteAsync(await findName(name, params: params));

  @override
  Future<PopResult> removeLast({dynamic result}) async {
    final isPopped = await _pagesController.removeLast(result: result);
    if (isPopped == PopResult.Popped) {
      update(withParams: true);
    }
    return isPopped;
  }

  @override
  void removeRoutes(List<String> routesNames) => routes.remove(routesNames);

  @override
  Future<void> replace(String path, String withPath) async {
    final match = await findPath(path);
    final index = _pagesController.routes.indexWhere((e) => e.isSame(match));
    assert(index != -1, 'Path $path was not found in the stack');
    if (!await _pagesController.removeIndex(index)) return;
    await push(withPath);
  }

  @override
  Future<void> replaceAll(String path) async {
    final match = await findPath(path);
    if (await _pagesController.removeAll() != PopResult.Popped) return;
    await addRouteAsync(match);
  }

  @override
  Future<void> replaceAllWithName(String name,
      {Map<String, dynamic>? params}) async {
    final match = await findName(name, params: params);
    if (await _pagesController.removeAll() != PopResult.Popped) return;
    await addRouteAsync(match);
  }

  @override
  Future<void> replaceLast(String path) async {
    final last = _pagesController.routes.last;
    return replace(last.activePath!, path);
  }

  @override
  Future<void> replaceLastName(String name,
      {Map<String, dynamic>? params}) async {
    final last = _pagesController.routes.last;
    return replaceName(
      last.name,
      name,
      params: last.params?.asMap,
      withParams: params,
    );
  }

  @override
  Future<void> replaceName(String name, String withName,
      {Map<String, dynamic>? params, Map<String, dynamic>? withParams}) async {
    final match = await findName(name, params: params);
    final index = _pagesController.routes.indexWhere((e) => e.isSame(match));
    assert(index != -1, 'Path with name $name was not found in the stack');
    if (!await _pagesController.removeIndex(index)) return;
    await pushName(withName, params: withParams);
  }

  @override
  Future<void> switchTo(String path) async {
    await popUntilOrPushMatch(await findPath(path),
        pageAlreadyExistAction: PageAlreadyExistAction.BringToTop);
  }

  @override
  Future<void> switchToName(String name, {Map<String, dynamic>? params}) async {
    final match = await findName(name, params: params);
    await popUntilOrPushMatch(match,
        pageAlreadyExistAction: PageAlreadyExistAction.BringToTop);
  }

  @override
  void updateUrl(
    String url, {
    Map<String, dynamic>? params,
    QKey? mKey,
    String? navigator,
    bool updateParams = false,
    bool addHistory = true,
  }) {
    if (key.name != QRContext.rootRouterName) {
      QR.log('Only ${QRContext.rootRouterName} can update the url');
      return;
    }
    final newParams = QParams();
    newParams.addAll(params ?? Uri.parse(url).queryParameters);
    QR.history.add(QHistoryEntry(mKey ?? QKey('Out Route'), url, newParams,
        navigator ?? 'Out Route', false));
    update(withParams: updateParams);
    if (!addHistory) {
      QR.history.removeLast();
    }
  }

  Future<void> initialize({String? initPath, QRouteInternal? initRoute}) async {
    if (initRoute != null) {
      await addRouteAsync(initRoute);
    } else if (initPath != null) {
      await push(initPath);
    }
  }

  Future<void> disposeAsync() async {
    if (!isTemporary) await _pagesController.removeAll();
    isDisposed = true;
    if (isTemporary) {
      // remove routes from the tree
      final routesNames = routes.routes.map((e) => e.name).toList();
      removeRoutes(routesNames);
    }
    super.dispose();
  }

  bool get hasRoutes => _pagesController.routes.isNotEmpty;

  List<QPageInternal> get pages => List.unmodifiable(_pagesController.pages);

  Future<QRouteInternal> findPath(String path) => MatchController(
        path,
        routes.parentFullPath,
        routes,
      ).match;

  Future<QRouteInternal> findName(
    String name, {
    Map<String, dynamic>? params,
  }) =>
      MatchController.fromName(
        name,
        routes.parentFullPath,
        routes,
        params: params,
      ).match;

  void updatePathIfNeeded(QRouteInternal match, {bool updateParams = false}) {
    if (key.name != QRContext.rootRouterName) {
      QR.updateUrlInfo(
        match.activePath!,
        mKey: match.key,
        params: match.params!.asValueMap,
        navigator: key.name,
        updateParams: updateParams,
      );
    }
  }

  Future<void> addRouteAsync(QRouteInternal match,
      {bool notify = true, bool checkChild = true}) async {
    QR.log('adding $match to the navigator with $key');
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

  Future<void> popUntilOrPushMatch(
    QRouteInternal match, {
    bool checkChild = true,
    PageAlreadyExistAction pageAlreadyExistAction =
        PageAlreadyExistAction.Remove,
  }) async {
    final index =
        _pagesController.routes.indexWhere((element) => element.isSame(match));
    // Page not exist add it.
    if (index == -1) {
      if (QR.settings.oneRouteInstancePerStack) {
        final sameRouteIndex = _pagesController.routes
            .indexWhere((element) => element.key.isSame(match.key));
        if (sameRouteIndex != -1) {
          await _pagesController.removeIndex(sameRouteIndex);
        }
      }

      await addRouteAsync(match, checkChild: checkChild);
      return;
    }

    if (match.hasChild) {
      // page exist and has children
      if (checkChild) {
        await popUntilOrPushMatch(match.child!);
      }

      // See [#56]
      // if the parent have a navigator then just insure that the
      // page is on the top
      if (QR.hasNavigator(match.name) && this != QR.navigatorOf(match.name)) {
        // here the bring on to should ignore any children, because the route has a navigator and the navigator will handle the children
        _bringPageToTop(index, true);
      }

      return;
    }

    switch (pageAlreadyExistAction) {
      case PageAlreadyExistAction.BringToTop:
      case PageAlreadyExistAction.IgnoreChildrenAndBringToTop:
        var shouldIgnoreChildren = pageAlreadyExistAction ==
            PageAlreadyExistAction.IgnoreChildrenAndBringToTop;
        if (match.route.path == '/') {
          // if the path is / then we have to ignore the children, because
          // in this case the children are the siblings of the route
          shouldIgnoreChildren = true;
        }
        final route = _bringPageToTop(index, shouldIgnoreChildren);
        if (shouldIgnoreChildren) _updatePathWhenBringingPageToTop(route);
        QR.log('${route.fullPath} is on to top of the stack');
        match.isProcessed = true;
        break;
      case PageAlreadyExistAction.Remove:
      default:
        // page is exist and has no children
        // then pop until it or replace it
        if (index == _pagesController.pages.length - 1) {
          // if the same page is on the top, then replace it.
          // remove it from the top and add it again
          if (await _pagesController.removeLast(allowEmptyPages: true) !=
              PopResult.Popped) return;
          await addRouteAsync(match, checkChild: checkChild);
          return;
        }
        // page exist remove unit it
        final pagesLength = _pagesController.pages.length;
        for (var i = index + 1; i < pagesLength; i++) {
          if (await _pagesController.removeLast() != PopResult.Popped) return;
        }
    }

    update();
  }

  void update({bool withParams = false}) {
    if (withParams && QR.history.entries.isNotEmpty) {
      QR.params.updateParams(QR.history.current.params);
    }
    notifyListeners();
  }

  /// this method is only called when this navigator has a [PopupRoute] to remove it
  void closePopup<T>(T? result) {
    Navigator.pop(navKey.currentContext!, result);
  }

  Future<void> _addRoute(QRouteInternal route) async {
    if (_pagesController.exist(route) && route.hasChild) {
      // if page already exist, and has a child, that means the child need
      // to be added, so do not run the middleware for it or add it again
      return;
    }
    if (route.hasMiddleware ||
        (QR.settings.globalMiddlewares.isNotEmpty && !route.isNotFound)) {
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
      route.key,
      route.activePath!,
      route.params!,
      key.name,
      route.hasChild,
    ));
    await _pagesController.add(route);
  }

  void _updatePathWhenBringingPageToTop(QRouteInternal route) {
    // if this route has his own navigator, then update its path to the last page seen in it
    final lastFoundRoute = QR.history.findLastForNavigator(route.name);
    if (lastFoundRoute != null) {
      QR.log(
          'update path to the last seen route for ${route.name} which is ${lastFoundRoute.path}',
          isDebug: true);
      QR.rootNavigator.updateUrl(
        lastFoundRoute.path,
        addHistory: true,
        params: lastFoundRoute.params.asValueMap,
        navigator: lastFoundRoute.navigator,
        updateParams: true,
      );
    } else {
      // update the path to this page
      updatePathIfNeeded(route);
    }
  }

  QRouteInternal _bringPageToTop(int index, bool shouldIgnoreChildren) {
    var route = _pagesController.routes[index];
    if (shouldIgnoreChildren) {
      final page = _pagesController.pages[index];
      _pagesController.routes.remove(route);
      _pagesController.pages.remove(page);
      _pagesController.routes.add(route);
      _pagesController.pages.add(page);
      return route;
    }
    // if page children should not be ignored, then bring the page to the top
    // with its children too in the same order
    final routesWithSamePath = _pagesController.routes
        .where((element) => element.fullPath.contains(route.fullPath))
        .toList();
    QR.log('bring page to top with children: $routesWithSamePath',
        isDebug: true);
    for (route in routesWithSamePath) {
      index = _pagesController.routes.indexOf(route);
      final page = _pagesController.pages[index];
      _pagesController.routes.remove(route);
      _pagesController.pages.remove(page);
      _pagesController.routes.add(route);
      _pagesController.pages.add(page);
      _updatePathWhenBringingPageToTop(route);
    }

    return route;
  }
}
