import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'navigator/navigator.dart';
import 'qr.dart';
import 'qr_controller.dart';
import 'routes_tree/routes_tree.dart';

/// Qlevar Router implementation for [RouterDelegate]
// ignore: prefer_mixin
class QRouterDelegate extends RouterDelegate<MatchContext> with ChangeNotifier {
  final QRController _controller;
  final QNavigatorState navigationKey;
  QRouterDelegate(
      this._controller, QNavigatorController controller, MatchContext initPage)
      : navigationKey = controller.createState(initPage) {
    controller.setRootData(navigationKey, notifyListeners);
    QR.log('Root Navigator key: ${navigationKey.hashCode}');
  }

  @override
  MatchContext get currentConfiguration =>
      MatchContext(fullPath: QR.currentRoute.fullPath);

  @override
  Future<void> setInitialRoutePath(MatchContext configuration) =>
      SynchronousFuture(null);

  @override
  Future<void> setNewRoutePath(MatchContext route) {
    _controller.toPath(route.fullPath, QNavigationMode());
    return SynchronousFuture(null);
  }

  @override
  Future<bool> popRoute() async => _controller.pop();

  @override
  Widget build(BuildContext context) => QNavigatorInternal(navigationKey);

  Page<dynamic> palceHolder() =>
      MaterialPage(key: ValueKey('placeHolder'), child: Container());
}
