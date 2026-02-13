import 'package:flutter/material.dart';

import '../../qlevar_router.dart';
import '../pages/qpage_internal.dart';

class QNavigatorObserver extends NavigatorObserver {
  final String name;
  final List<Route> _routes = [];
  QNavigatorObserver(this.name);

  @override
  void didPop(Route route, Route? previousRoute) {
    _log('Pop', route);
    _routes.remove(route);
    super.didRemove(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _log('Push', route);
    _routes.add(route);
    super.didPush(route, previousRoute);
  }

  /// check if there is a popup route in the tree
  bool hasPopupRoute() {
    if (_routes.isEmpty) return false;
    return _routes.any((element) => element is PopupRoute);
  }

  void _log(String message, Route route) {
    if (route.settings is QPageInternal) {
      final page = route.settings as QPageInternal;
      QR.log('$name observer: $message: ${page.matchKey.name}', isDebug: true);
      return;
    }
    QR.log('$name observer: $message: ${route.runtimeType}', isDebug: true);
  }
}

class QObserver {
  /// add listeners to every new route that will be added to the tree
  final onNavigate = <Future Function(String, QRoute)>[];

  /// Add listener to every route that will be deleted from the tree
  final onPop = <Future Function(String, QRoute)>[];
}
