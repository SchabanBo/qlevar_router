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
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _log('Push', route);
    _routes.add(route);
    super.didPush(route, previousRoute);
  }

  /// A page removed from the pages list below the top one, or a dialog above
  /// it, is removed without a pop. Keeping it here made [hasPopupRoute] true
  /// and the next back popped a page as if it was a dialog.
  @override
  void didRemove(Route route, Route? previousRoute) {
    _log('Remove', route);
    _routes.remove(route);
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _routes.remove(oldRoute);
    if (newRoute != null) _routes.add(newRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  /// check if there is a popup route in the tree
  bool hasPopupRoute() => _routes.any((element) => element is PopupRoute);

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
  final onNavigate = <Future<void> Function(String, QRoute)>[];

  /// Add listener to every route that will be deleted from the tree
  final onPop = <Future<void> Function(String, QRoute)>[];
}
