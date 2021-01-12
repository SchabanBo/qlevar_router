import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../qlevar_router.dart';
import 'qr.dart';
import 'routes_tree/routes_tree.dart';

/// Qlevar Router implementation for [RouterDelegate]
class QRouterDelegate extends RouterDelegate<MatchContext>
    with
        // ignore: prefer_mixin
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<MatchContext> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final _Stack _stack;

  QRouterDelegate({MatchContext matchRoute})
      : navigatorKey = GlobalKey<NavigatorState>(),
        _stack = _Stack(matchRoute);

  @override
  MatchContext get currentConfiguration => _stack.last;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _stack.pages,
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
    if (_stack.isNewPath(route)) {
      notifyListeners();
    }
    return SynchronousFuture(null);
  }

  @override
  void dispose() {
    _stack.clear();
    super.dispose();
  }

  void pop() {
    _stack.removeLast();
    notifyListeners();
  }
}

class _Stack {
  final _stack = <MatchContext>[];
  MatchContext _initContext;

  /// Give the initRoute to this stack
  /// at this point onInit for this route will not be called.
  _Stack(this._initContext);

  MatchContext get last => _stack.isEmpty ? _initContext : _stack.last;

  List<MaterialPage> get pages => _stack.isEmpty
      ? [_initContext.toMaterialPage()]
      : _stack.map((e) => e.toMaterialPage()).toList();

  void removeLast() {
    if (_stack.length < 1) {
      print('Stack has just one page. Cannot pop');
      return;
    }
    remove(last);
  }

  /// remove all routes from the _stack
  void clear() {
    for (var item in _stack) {
      remove(item);
    }
  }

  /// Add new route to the stack and call OnInit to it.
  void add(MatchContext route) {
    if (route.onInit != null) {
      route.onInit();
    }
    _stack.add(route);
  }

  /// Checks if the new route is new, if it is the add it to the _stack.
  bool isNewPath(MatchContext route) {
    if (route == null) {
      return false;
    }
    QR.log('SetNewRoutePath: ${route.fullPath}', isDebug: true);
    final isNew = !_isOldMatch(route);
    if (isNew) {
      _setNewRoutePath(route);
    }
    route.triggerChild();
    return isNew;
  }

  ///  Remove the last route in the _stack and call onDispose for it.
  void remove(MatchContext route) {
    runOnDispose(route);
    _stack.remove(route);
  }

  /// Run onDispose for the route and its childrens
  void runOnDispose(MatchContext route) {
    if (route.onDispose != null) {
      route.onDispose();
    }
    if (route.childContext != null) {
      runOnDispose(route.childContext);
    }
  }

  void _setNewRoutePath(MatchContext route) {
    QR.log('New Path: ${route.fullPath}');
    route.mode = route.mode ?? QNavigationMode(type: NavigationType.Push);
    switch (route.mode.type) {
      case NavigationType.Push:
        //if (_stack.any((element) => element.isMatch(route))) {
        //  final removeFrom =
        //      _stack.indexWhere((element) => element.isMatch(route));
        //  for (var i = removeFrom + 1; i < _stack.length; i++) {
        //    remove(_stack[i]);
        //  }
        //} else {
        add(route);
        //}
        break;
      case NavigationType.PopUnitOrPush:
        if (_stack.any((element) => element.isMatch(route))) {
          final removeFrom =
              _stack.indexWhere((element) => element.isMatch(route));
          for (var i = removeFrom + 1; i < _stack.length; i++) {
            remove(_stack[i]);
          }
        } else {
          add(route);
        }
        break;
      case NavigationType.ReplaceLast:
        removeLast();
        add(route);
        break;
      case NavigationType.ReplaceAll:
        clear();
        add(route);
        break;
    }
  }

  /// is the new route matches the current route
  /// when the _stack is empty then prof the _initContext, if it is match then
  /// add it to the stack on call to call onInit for it.
  bool _isOldMatch(MatchContext matchRoute) {
    if (_stack.isEmpty && _initContext.isMatch(matchRoute)) {
      _initContext = null;
      add(matchRoute);
      return true;
    }
    return _stack.last.isMatch(matchRoute);
  }
}
