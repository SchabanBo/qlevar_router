import 'package:flutter/widgets.dart';

import '../../qlevar_router.dart';
import '../pages/qpage_internal.dart';
import '../routes/qroute_children.dart';
import '../routes/qroute_internal.dart';
import '../types/qhistory.dart';
import '../types/qroute_key.dart';
import 'match_controller.dart';
import 'middleware_controller.dart';
import 'pages_controller.dart';

abstract class QNavigator extends ChangeNotifier {
  bool get canPop;

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
    final match = findPath(initPath);
    QR.history.add(QHistoryEntry(initPath, QR.params, key.name));
    addRoute(match);
  }

  final _pagesController = PagesController();
  @override
  bool get canPop => _pagesController.pages.length > 1;

  List<QPageInternal> get pages => List.unmodifiable(_pagesController.pages);

  QRouteInternal findPath(String path) {
    return MatchController(path, key.name, routes).match;
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
    QR.params.updateParams(QR.history.last.params);
    notifyListeners();
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
    // TODO: implement replaceAllPath
  }

  @override
  void replace(String path, String withPath) {
    // TODO: implement replacePath
  }

  void addRoute(QRouteInternal route, {bool notify = true}) {
    QR.log('Adding $route to Navigator with $key');
    addRouteAsync(route, notify: notify);
  }

  Future<void> addRouteAsync(QRouteInternal route, {bool notify = true}) async {
    var redirect = await _addRoute(route);
    while (route.child != null && !redirect) {
      redirect = await _addRoute(route.child!);
      route = route.child!;
    }

    if (notify && !redirect) {
      notifyListeners();
    }
  }

  Future<bool> _addRoute(QRouteInternal route) async {
    if (_pagesController.exist(route)) {
      // if page already exsit, do not run the middleware for it or readd it
      return false;
    }
    if (route.hasMiddlewares) {
      final result = await MiddlewareController(route).runRedirect();
      if (result != null) {
        QR.to(result);
        return true;
      }
    }
    _pagesController.add(route);
    QR.history.add(QHistoryEntry(route.activePath!, QR.params, key.name));
    return false;
  }

  @override
  void popUnitOrPush(String path) {
    final match = findPath(path);
    final index = _pagesController.routes
        .indexWhere((element) => element.key.isSame(match.key));
    if (index == -1) {
      // Page not exist add it.
      addRoute(match);
      return;
    }
    if (index == _pagesController.pages.length - 1) {
      // Page is on top replace it.
      _pagesController.removeLast();
      addRoute(match);
      return;
    }
    // page exist remove unit it
    for (var i = index + 1; i < _pagesController.pages.length; i++) {
      _pagesController.removeIndex(i);
      i--;
    }
    notifyListeners();
  }
}
