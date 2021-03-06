import 'package:flutter/widgets.dart';
import 'package:qlevar_router/src/types/qhistory.dart';

import '../../qlevar_router.dart';
import '../pages/page_creator.dart';
import '../pages/qpage_internal.dart';
import '../routes/qroute_children.dart';
import '../routes/qroute_internal.dart';
import '../types/qroute_key.dart';
import 'match_controller.dart';

abstract class QNavigator extends ChangeNotifier {
  bool get canPop;

  void push(String name);

  void replace(String name, String withName);

  void replaceAll(String name);

  void pushPath(String path);

  void replacePath(String path, String withPath);

  void replaceAllPath(String path);

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

  final _activePage = <QRouteInternal>[];
  @override
  bool get canPop => _activePage.length > 1;

  List<QPageInternal> get pages => List.unmodifiable(
      _activePage.map((e) => PageCreator(e).create()).toList());

  QRouteInternal findPath(String path) {
    return MatchController(path, key.name, routes).match;
  }

  @override
  void push(String name) {
    // TODO: implement push
  }

  void addRoute(QRouteInternal route, {bool notify = true}) {
    _activePage.add(route);
    QR.history.add(QHistoryEntry(route.activePath!, QR.params, key.name));
    while (route.child != null) {
      _activePage.add(route.child!);
      QR.history
          .add(QHistoryEntry(route.child!.activePath!, QR.params, key.name));
      route = route.child!;
    }

    if (notify) {
      notifyListeners();
    }
  }

  @override
  void removeLast() {
    if (!canPop) {
      return;
    }
    _activePage.removeLast();
    QR.history.removeLast();
    QR.params.updateParams(QR.history.last.params);
    notifyListeners();
  }

  @override
  void replace(String name, String withName) {
    // TODO: implement replace
  }

  @override
  void replaceAll(String name) {
    // TODO: implement replaceAll
  }

  @override
  void pushPath(String path) {
    final match = findPath(path);
    addRoute(match);
  }

  @override
  void replaceAllPath(String path) {
    // TODO: implement replaceAllPath
  }

  @override
  void replacePath(String path, String withPath) {
    // TODO: implement replacePath
  }
}
