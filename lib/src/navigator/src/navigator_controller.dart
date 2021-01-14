import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:qlevar_router/src/navigator/src/navigator.dart';
import 'package:qlevar_router/src/routes_tree/src/match_context.dart';
import 'package:qlevar_router/src/routes_tree/src/routes_tree.dart';

class QNavigatorController {
  final rootState = MatchContext().state;
  Function notify;

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

  Page<dynamic> initRoute(String initRoute) {
    final match = getMatch(initRoute);
    match.treeUpdated();
    return _getPage(match);
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
