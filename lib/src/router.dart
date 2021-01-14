import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/src/navigator/navigator.dart';
import 'package:qlevar_router/src/navigator/src/navigator_controller.dart';
import 'package:qlevar_router/src/qr_controller.dart';
import 'qr.dart';
import 'routes_tree/routes_tree.dart';

/// Qlevar Router implementation for [RouterDelegate]
// ignore: prefer_mixin
class QRouterDelegate extends RouterDelegate<MatchContext> with ChangeNotifier {
  final QRController _navigator;

  QRouterDelegate(this._navigator) {
    _navigator.notify = notifyListeners;
    QR.log('Root Navigator key: ${_navigator.rootState.hashCode}');
  }

  @override
  MatchContext get currentConfiguration =>
      MatchContext(fullPath: QR.currentRoute.fullPath);

  @override
  Future<void> setInitialRoutePath(MatchContext configuration) {
    return SynchronousFuture(null);
  }

  @override
  Future<void> setNewRoutePath(MatchContext route) {
    _navigator.toPath(route.fullPath, QNavigationMode());
    return SynchronousFuture(null);
  }

  @override
  Future<bool> popRoute() async => _navigator.pop();

  @override
  Widget build(BuildContext context) {
    return QNavigatorInternal(_navigator.rootState);
  }

  Page<dynamic> palceHolder() =>
      MaterialPage(key: ValueKey('placeHolder'), child: Container());
}
