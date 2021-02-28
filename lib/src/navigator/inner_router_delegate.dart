import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../qr.dart';
import 'router_controller.dart';

// ignore: prefer_mixin
class InnerRouterDelegate extends RouterDelegate<int> with ChangeNotifier {
  final RouterController _controller;
  final key = GlobalKey<NavigatorState>();
  InnerRouterDelegate(this._controller) {
    _controller.addListener(notifyListeners);
    _controller.navKey = key.toString();
    QR.log('New router with key $key for controller $_controller created',
        isDebug: true);
  }

  @override
  Widget build(BuildContext context) => Navigator(
        key: key,
        pages: _controller.pages,
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          return _controller.pop().didPop;
        },
      );

  @override
  Future<bool> popRoute() async => QR.back();

  @override
  Future<void> setNewRoutePath(int configuration) async {
    return SynchronousFuture(null);
  }
}
