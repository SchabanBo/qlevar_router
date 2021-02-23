import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../qr.dart';
import 'router_controller.dart';

// ignore: prefer_mixin
class InnerRouterDelegate extends RouterDelegate<int> with ChangeNotifier {
  final RouterController _request;
  InnerRouterDelegate(this._request) {
    _request.addListener(notifyListeners);
  }

  @override
  Widget build(BuildContext context) => Navigator(
        key: _request.navKey,
        pages: _request.pages,
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          return QR.back();
        },
      );

  @override
  Future<bool> popRoute() async => QR.back();

  @override
  Future<void> setNewRoutePath(int configuration) async {
    return SynchronousFuture(null);
  }
}
