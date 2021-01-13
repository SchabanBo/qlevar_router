import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../qlevar_router.dart';
import 'routes_tree/routes_tree.dart';

class QNavigatorController {
  /// The internal route Tree
  final RoutesTree _routesTree = RoutesTree();
  final rootKey = MatchContext().navigatorKey;
  Function notify;

  void setTree(List<QRouteBase> routes) => _routesTree.buildTree(routes);

  void toPath(String path, QNavigationMode mode) {
    final match = getMatch(path);
    updatePath(rootKey, match, mode);
  }

  void toName(String name, Map<String, dynamic> params, QNavigationMode mode) {
    final match = _routesTree.getNamedMatch(name, params);
    updatePath(rootKey, match, mode);
  }

  MatchContext getMatch(String path) {
    QR.log('Navigate to $path');
    final match = _routesTree.getMatch(path);
    match.printTree();
    return match;
  }

  void updatePath(NaviKey parentKey, MatchContext match, QNavigationMode mode) {
    if (match.isNew) {
      QR.log('$match is the new route.', isDebug: true);
      _updateNavigator(parentKey, match, mode);
      return;
    }
    if (match.childContext != null) {
      QR.log('$match is the old route. checking child', isDebug: true);
      updatePath(match.navigatorKey, match.childContext, mode);
      return;
    }
    QR.log('No changes for $match was found', isDebug: true);
  }

  void _updateNavigator(NaviKey key, MatchContext match, QNavigationMode mode) {
    QR.log('Use Navigator for $match with key ${key.code}', isDebug: true);
    match.treeUpdated();
    key.state.pushReplacement(_getPage(match));
    notify();
  }

  bool pop() {
    if (QR.history.isEmpty) {
      return false;
    }
    toPath(QR.history[QR.history.length - 2],
        QNavigationMode(type: NavigationType.PopUnitOrPush));
    QR.history.removeLast();
    return true;
  }

  Route<dynamic> initRoute(String initRoute) {
    final match = getMatch(initRoute);
    match.treeUpdated();
    return _getPage(match);
  }

  Route<dynamic> _getPage(MatchContext match) {
    final childNavi = match.childContext == null
        ? null
        : getNavigator(match.navigatorKey, match.childContext);
    return MaterialPageRoute(builder: (c) => match.route.page(childNavi));
  }

  QNavigator getNavigator(NaviKey key, MatchContext match) {
    QR.log('Get Navigator for $match with key ${key.code}', isDebug: true);
    final initPage = _getPage(match);
    return QPageNavigator(match.navigatorKey, initPage, pop);
  }
}
