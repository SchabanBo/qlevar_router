import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../qlevar_router.dart';
import 'types.dart';

class QRouterDelegate extends RouterDelegate<MatchContext>
    with
        // ignore: prefer_mixin
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<MatchContext> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final List<MatchContext> _stack = [];
  QRouterDelegate({MatchContext matchRoute})
      : navigatorKey = GlobalKey<NavigatorState>() {
    _stack.add(matchRoute);
  }

  @override
  MatchContext get currentConfiguration => _stack.last;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _stack.map((match) => match.toMaterialPage()).toList(),
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        _stack.removeLast();
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(MatchContext route) {
    if (route == null) {
      return SynchronousFuture(null);
    }
    QR.log('setNewRoutePath: ${route.fullPath}', isDebug: true);
    if (!_isOldMatch(route)) {
      QR.log('New Path: ${route.fullPath}');
      _stack
        ..clear()
        ..add(route);
      notifyListeners();
    }
    route.triggerChild();
    return SynchronousFuture(null);
  }

  bool _isOldMatch(MatchContext matchRoute) => matchRoute.isComponent
      ? _stack.last.fullPath == matchRoute.fullPath
      : _stack.last.key == matchRoute.key;

  void pop() {
    if (_stack.length <= 1) {
      print('Stack has just one page. Cannot pop');
      return;
    }
    _stack.removeLast();
    notifyListeners();
  }
}
