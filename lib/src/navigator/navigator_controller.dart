import 'package:flutter/material.dart';
import 'package:qlevar_router/src/navigator/router_pages.dart';

import '../match_context.dart';
import '../qr.dart';
import '../types.dart';
import 'navigator.dart';
import 'router_controller.dart';

class QNavigatorController {
  // TODO :: clean list when updated
  final _contollers = <RouterController>[];

  void setNewMatch(MatchContext match, QNavigationMode mode) => _updatePath(
      _contollers.firstWhere((element) => element.key == -1), match, mode);

  void _updatePath(RouterController parentRequest, MatchContext match,
      QNavigationMode mode) {
    if (match.isNew) {
      QR.log('$match is the new route has the reqest $parentRequest.',
          isDebug: true);
      parentRequest.updatePage(_getPage(match), mode);
      _contollers.firstWhere((element) => element.key == -1).updateUrl();
      match.treeUpdated();
      return;
    }
    if (match.childContext != null) {
      QR.log('$match is the old route. checking child', isDebug: true);
      final request =
          _contollers.firstWhere((element) => element.key == match.key);
      _updatePath(request, match.childContext, mode);
      return;
    }
    QR.log('No changes for $match was found', isDebug: true);
  }

  Page<dynamic> _getPage(MatchContext match) {
    final childRouter = match.childContext == null
        ? null
        : _getInnerRouter(match, match.childContext);

    return QRMaterialPage.fromMath(match, childRouter);
  }

  QRouter _getInnerRouter(MatchContext parent, MatchContext match) {
    QR.log('Get Navigator for $match', isDebug: true);
    return QRouter(
      routerDelegate: InnerRouterDelegate(
          createRouterController(parent.key, parent.route.name, match)),
    );
  }

  RouterController createRouterController(
      int key, String name, MatchContext match) {
    final page = _getPage(match);
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

  bool pop() {
    if (QR.history.isEmpty) {
      return false;
    }
    QR.to(QR.history[QR.history.length - 2],
        mode: QNavigationMode(type: NavigationType.PopUnitOrPush));
    QR.history.removeLast();
    return true;
  }
}
