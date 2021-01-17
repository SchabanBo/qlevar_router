import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'router_controller.dart';

// ignore: prefer_mixin
class InnerRouterDelegate extends RouterDelegate<int> with ChangeNotifier {
  final key = GlobalKey<NavigatorState>();
  final RouterController _request;
  InnerRouterDelegate(this._request) {
    _request.addListener(notifyListeners);
  }

  @override
  Widget build(BuildContext context) => Navigator(
        key: key,
        pages: _request.pages,
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          return _request.onPop();
        },
      );

  @override
  Future<bool> popRoute() async => _request.onPop();

  @override
  Future<void> setNewRoutePath(int configuration) async {
    return SynchronousFuture(null);
  }
}
