import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../qlevar_router.dart';
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

  /// Set the browser [url]
  void updateUrl(String url,
      {Map<String, String>? params,
      QKey? mKey,
      String? navigator = '',
      bool addHistory = true});

  void pushName(String name, {Map<String, dynamic>? params});

  void replaceName(String name, String withName,
      {Map<String, dynamic>? params});

  void replaceAllWithName(String name, {Map<String, dynamic>? params});

  void popUnitOrPushName(String name, {Map<String, dynamic>? params});

  void push(String path);

  void popUnitOrPush(String path);

  void replace(String path, String withPath);

  void replaceAll(String path);

  bool removeLast();
}

class QRouterController extends QNavigator {
  final QKey key;

  final QRouteChildren routes;

  final _pagesController = PagesController();

  QRouterController(this.key, this.routes, String initPath) {
    push(initPath);
  }

  @override
  bool get canPop => _pagesController.pages.length > 1;

  List<QPageInternal> get pages => List.unmodifiable(_pagesController.pages);

  QRouteInternal findPath(String path) {
    return MatchController(path, routes.parentFullPaht, routes).match;
  }

  QRouteInternal findName(String name, {Map<String, dynamic>? params}) {
    return MatchController.fromName(name, routes.parentFullPaht, routes,
            params: params)
        .match;
  }

  @override
  void pushName(String name, {Map<String, dynamic>? params}) =>
      addRoute(findName(name, params: params));

  @override
  bool removeLast() {
    if (!canPop) {
      return false;
    }
    _pagesController.removeLast();
    update(withParams: true);
    return true;
  }

  @override
  void replaceName(String name, String withName,
      {Map<String, dynamic>? params}) {
    // TODO: implement replace
  }

  @override
  void replaceAllWithName(String name, {Map<String, dynamic>? params}) {
    final match = findName(name, params: params);
    _pagesController.removeAll();
    addRoute(match);
  }

  @override
  void push(String path) {
    final match = findPath(path);
    addRoute(match);
  }

  @override
  void replaceAll(String path) {
    final match = findPath(path);
    _pagesController.removeAll();
    addRoute(match);
  }

  @override
  void replace(String path, String withPath) {
    // TODO: implement replacePath
  }

  void addRoute(QRouteInternal route,
      {bool notify = true, bool checkChild = true}) {
    addRouteAsync(route, notify: notify, checkChild: checkChild);
    QR.log('$route added to the navigator with $key');
  }

  Future<void> addRouteAsync(QRouteInternal route,
      {bool notify = true, bool checkChild = true}) async {
    var redirect = await _addRoute(route);
    while (checkChild && route.hasChild && !redirect) {
      redirect = await _addRoute(route.child!);
      route = route.child!;
    }

    if (notify && !redirect) {
      update();
    }
  }

  Future<bool> _addRoute(QRouteInternal route) async {
    if (_pagesController.exist(route) && route.hasChild) {
      // if page already exsit, and has a child, that means the child need
      // to be added, so do not run the middleware for it or add it again
      return false;
    }
    if (route.hasMiddlewares) {
      final result = await MiddlewareController(route).runRedirect();
      if (result != null) {
        QR.to(result);
        return true;
      }
    }
    QR.history.add(QHistoryEntry(
        route.key, route.activePath!, route.params!, key.name, route.hasChild));
    _pagesController.add(route);
    return false;
  }

  @override
  void popUnitOrPush(String path) {
    popUnitOrPushMatch(findPath(path));
  }

  @override
  void popUnitOrPushName(String name, {Map<String, dynamic>? params}) {}

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
    for (var i = index + 1; i < _pagesController.pages.length; i++) {
      _pagesController.removeIndex(i);
      QR.history.removeLast();
      i--;
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
}
