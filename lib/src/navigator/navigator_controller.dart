import 'package:flutter/material.dart';

import '../match_context.dart';
import '../qr.dart';
import '../types.dart';
import 'navigator.dart';
import 'router_controller.dart';

class QNavigatorController {
  final _conManeger = RouterControllerManger();

  void setNewMatch(MatchContext match, QNavigationMode mode) {
    return _updatePath(_conManeger.rootController(), match, mode);
  }

  void _updatePath(RouterController parentRequest, MatchContext match,
      QNavigationMode mode) {
    if (match.isNew) {
      QR.log('$match is the new route has the reqest $parentRequest.',
          isDebug: true);
      parentRequest.updatePage(_getPage(match), mode);
      _conManeger.rootController().updateUrl();
      match.treeUpdated();
      return;
    }
    if (match.childContext != null) {
      QR.log('$match is the old route. checking child', isDebug: true);
      final request = _conManeger.withKey(match.key);
      _updatePath(request, match.childContext, mode);
      return;
    }
    QR.log('No changes for $match was found', isDebug: true);
  }

  Page<dynamic> _getPage(MatchContext match) {
    final childRouter = match.childContext == null
        ? null
        : _getInnerRouter(match, match.childContext);

    return MaterialPage(
        name: match.route.name,
        child: match.route.page(childRouter),
        key: ValueKey(match.key));
  }

  QRouter _getInnerRouter(MatchContext parent, MatchContext match) {
    QR.log('Get Navigator for $match', isDebug: true);
    return QRouter(
      routerDelegate: InnerRouterDelegate(
          createRouterController(parent.key, parent.route.name, match)),
    );
  }

  RouterController createRouterController(
          int key, String name, MatchContext match) =>
      _conManeger.create(key, name, _getPage(match));

  bool pop() {
    try {
      if (QR.history.isEmpty) {
        return false;
      }
      QR.to(QR.history.elementAt(QR.history.length - 2),
          mode: QNavigationMode(type: NavigationType.PopUntilOrPush));
      QR.history.removeLast();
      QR.history.removeLast();
      print('History : ${QR.history}');

      return true;
    } catch (e) {
      return false;
    }
  }
}

class RouterControllerManger {
  final _contollers = <RouterController>[];

  RouterController create(int key, String name, Page page) {
    if (_contollers.any((element) => element.key == key)) {
      final controller =
          _contollers.firstWhere((element) => element.key == key);
      controller.updatePage(page, QNavigationMode());
      return controller;
    }
    final controller = RouterController(key: key, name: name, initPage: page);
    _contollers.add(controller);
    return controller;
  }

  RouterController rootController() => _contollers
      .firstWhere((element) => element.key == -1, orElse: () => null);

  RouterController withKey(int key) => _contollers
      .firstWhere((element) => element.key == key, orElse: () => null);
}
