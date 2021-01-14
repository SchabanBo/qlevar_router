import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:qlevar_router/src/navigator/src/navigator.dart';
import 'package:qlevar_router/src/routes_tree/src/match_context.dart';
import 'package:qlevar_router/src/routes_tree/src/routes_tree.dart';

class QRController {
  /// The internal route Tree
  final RoutesTree _routesTree = RoutesTree();
  final rootState = MatchContext().state;
  Function notify;

  void setTree(List<QRouteBase> routes) => _routesTree.buildTree(routes);

  void toPath(String path, QNavigationMode mode) {
    final match = getMatch(path);
    updatePath(rootState, match, mode);
  }

  void toName(String name, Map<String, dynamic> params, QNavigationMode mode) {
    final match = _routesTree.getNamedMatch(name, params);
    updatePath(rootState, match, mode);
  }

  MatchContext getMatch(String path) {
    QR.log('Navigate to $path');
    final match = _routesTree.getMatch(path);
    match.printTree();
    return match;
  }

  void updatePath(
      QNavigatorState parentKey, MatchContext match, QNavigationMode mode) {
    if (match.isNew) {
      QR.log('$match is the new route.', isDebug: true);
      _updateNavigator(parentKey, match, mode);
      return;
    }
    if (match.childContext != null) {
      QR.log('$match is the old route. checking child', isDebug: true);
      updatePath(match.state, match.childContext, mode);
      return;
    }
    QR.log('No changes for $match was found', isDebug: true);
  }

  void _updateNavigator(
      QNavigatorState state, MatchContext match, QNavigationMode mode) {
    QR.log('Use Navigator for $match with key ${state.hashCode}',
        isDebug: true);
    match.treeUpdated();
    state.replaceAll([_getPage(match)]);
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

  Page<dynamic> _getPage(MatchContext match) {
    final childNavi = match.childContext == null
        ? null
        : getNavigator(match.state, match.childContext);
    return MaterialPage(child: match.route.page(childNavi));
  }

  QNavigatorInternal getNavigator(QNavigatorState state, MatchContext match) {
    QR.log('Get Navigator for $match with key ${state.hashCode}',
        isDebug: true);
    final initPage = _getPage(match);
    return QNavigatorInternal(state);
  }
}
