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
  final _stack = <MatchContext>[];
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
        pop();
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
    if (!_isOldMatch(route)) _setNewRoutePath(route);
    // if (!_isOldMatch(route)) {
    //   QR.log('New Path: ${route.fullPath}');
    //   _stack
    //     ..clear()
    //     ..add(route);
    //   notifyListeners();
    // }

    route.triggerChild();
    return SynchronousFuture(null);
  }

  void _setNewRoutePath(MatchContext route) {
    QR.log('New Path: ${route.fullPath}');
    if (_stack.any((element) => element.isMatch(route))) {
      final removeFrom = _stack.indexWhere((element) => element.isMatch(route));
      _stack.removeRange(removeFrom + 1, _stack.length);
    } else {
      _stack.add(route);
    }
    notifyListeners();
  }

  bool _isOldMatch(MatchContext matchRoute) => _stack.last.isMatch(matchRoute);

  void pop() {
    if (_stack.length <= 1) {
      print('Stack has just one page. Cannot pop');
      return;
    }
    _stack.removeLast();
    notifyListeners();
  }
}
