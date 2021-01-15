import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'navigator/navigator.dart';
import 'navigator/src/navi_request.dart.dart';
import 'qr.dart';
import 'qr_controller.dart';
import 'routes_tree/routes_tree.dart';

/// Qlevar Router implementation for [RouterDelegate]
// ignore: prefer_mixin
class QRouterDelegate extends RouterDelegate<MatchContext> with ChangeNotifier {
  final QRController _controller;
  final QNavigatorState navigationKey;
  QRouterDelegate(this._controller, this.navigationKey, NaviRequest request) {
    QR.log('Root Request key: ${request.key}');
    request.addListener(() {
      if (request.mode == RequestMode.UpdateUrl) {
        notifyListeners();
      }
    });
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
