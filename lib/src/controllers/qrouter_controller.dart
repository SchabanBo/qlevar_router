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
  bool get canPop;

  void updateUrl(String url,
      {Map<String, String>? params,
      String? navigator = '',
      bool addHistory = true});

  void pushName(String name);

  void replaceName(String name, String withName);

  void replaceAllWithName(String name);

  void push(String path);

  void popUnitOrPush(String path);

  void replace(String path, String withPath);

  void replaceAll(String path);

  void removeLast();
}

class QRouterController extends QNavigator {
  final QKey key;

  final QRouteChildren routes;

  QRouterController(this.key, this.routes, String initPath) {
    push(initPath);
  }

  final _pagesController = PagesController();
  @override
  bool get canPop => _pagesController.pages.length > 1;

  List<QPageInternal> get pages => List.unmodifiable(_pagesController.pages);

  QRouteInternal findPath(String path) {
    return MatchController(path, routes.parentFullPaht, routes).match;
  }

  @override
  void pushName(String name) {
    // TODO: implement push
  }

  @override
  void removeLast() {
    if (!canPop) {
      return;
    }
    _pagesController.removeLast();
    QR.history.removeLast();
    _update();
  }

  @override
  void replaceName(String name, String withName) {
    // TODO: implement replace
  }

  @override
  void replaceAllWithName(String name) {
    // TODO: implement replaceAll
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
      notifyListeners();
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
    QR.history.add(
        QHistoryEntry(route.activePath!, QR.params, key.name, route.hasChild));
    _pagesController.add(route);
    return false;
  }

  @override
  void popUnitOrPush(String path) {
    popUnitOrPushMatch(findPath(path));
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
    for (var i = index + 1; i < _pagesController.pages.length; i++) {
      _pagesController.removeIndex(i);
      i--;
    }
    QR.history.add(QHistoryEntry(
        _pagesController.routes.last.activePath!, QR.params, key.name, false));
    _update();
  }

  void _update({bool withParams = true}) {
    if (withParams) {
      QR.params.updateParams(QR.history.current.params);
    }
    notifyListeners();
  }

  @override
  void updateUrl(String url,
      {Map<String, String>? params,
      String? navigator,
      bool addHistory = true}) {
    if (key.name != QRContext.rootRouterName) {
      QR.log('Only ${QRContext.rootRouterName} can update the url');
      return;
    }
    final _params = QParams();
    _params.addAll(params ?? Uri.parse(url).queryParameters);
    QR.history.add(QHistoryEntry(url, _params, navigator ?? 'From out', false));
    _update();
    if (!addHistory) {
      QR.history.removeLast();
    }
  }
}
