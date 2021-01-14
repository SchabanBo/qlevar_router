import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../qlevar_router.dart';
import '../../routes_tree/src/match_context.dart';
import 'navigator.dart';

class QNavigatorController {
  Function _notify;

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
    _notify();
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
    //final initPage = _getPage(match);
    return QNavigatorInternal(state);
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

  QNavigatorState createState(MatchContext initMatch) {
    final page = _getPage(initMatch);
    return QNavigatorState(initPage: page, onPop: pop);
  }

  void setRootData(QNavigatorState state, Function notify) {
    _notify = notify;
  }
}
