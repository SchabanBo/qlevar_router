import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../qr.dart';
import '../../routes_tree/src/match_context.dart';
import 'navi_request.dart.dart';
import 'navigator.dart';

class QNavigatorController {
  // TODO :: clean list when updated
  final _requests = <NaviRequest>[];

  void setNewMatch(MatchContext match, QNavigationMode mode) => _updatePath(
      _requests.firstWhere((element) => element.key == -1), match, mode);

  void _updatePath(
      NaviRequest parentRequest, MatchContext match, QNavigationMode mode) {
    if (match.isNew) {
      QR.log('$match is the new route has the reqest $parentRequest.',
          isDebug: true);
      parentRequest.updatePage(_getPage(match), mode);
      _requests.firstWhere((element) => element.key == -1).updateUrl();
      match.treeUpdated();
      return;
    }
    if (match.childContext != null) {
      QR.log('$match is the old route. checking child', isDebug: true);
      final request =
          _requests.firstWhere((element) => element.key == match.key);
      _updatePath(request, match.childContext, mode);
      return;
    }
    QR.log('No changes for $match was found', isDebug: true);
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

  Page<dynamic> _getPage(MatchContext match) {
    final childNavi = match.childContext == null
        ? null
        : _getNavigator(match, match.childContext);
    return MaterialPage(
        child: match.route.page(childNavi), key: ValueKey(match.key));
  }

  QNavigatorInternal _getNavigator(MatchContext parent, MatchContext match) {
    QR.log('Get Navigator for $match', isDebug: true);
    final request = createRequest(match, parent.key, parent.route.name);
    return QNavigatorInternal(createState(match, request: request));
  }

  QNavigatorState createState(MatchContext initMatch, {NaviRequest request}) {
    final page = _getPage(initMatch);
    return QNavigatorState(request, page, pop);
  }

  NaviRequest createRequest(MatchContext match, int key, String name,
      {QNavigationMode mode}) {
    final page = _getPage(match);
    if (_requests.any((element) => element.key == key)) {
      final request = _requests.firstWhere((element) => element.key == key);
      request.page = page;
      request.naviMode = mode;
      return request;
    }
    final request = NaviRequest(
      key: key,
      name: name ?? match.route.name,
      page: page,
      naviMode: mode,
    );
    QR.log('Request $request for $match created', isDebug: true);
    _requests.add(request);
    return request;
  }
}
