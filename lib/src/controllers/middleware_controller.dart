import '../routes/qroute_internal.dart';

class MiddlewareController {
  final QRouteInternal route;
  MiddlewareController(this.route);

  Future<String?> runRedirect() async {
    final path = route.getLastActivePath();
    for (var middle in route.route.middleware!) {
      final result = await middle.redirectGuard(path);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  void runOnEnter() {
    if (!route.hasMiddlewares) {
      return;
    }
    for (var middle in route.route.middleware!) {
      middle.onEnter();
    }
  }

  void runOnExit() {
    if (!route.hasMiddlewares) {
      return;
    }
    for (var middle in route.route.middleware!) {
      middle.onExit();
    }
  }

  void runOnMatch() {
    if (!route.hasMiddlewares) {
      return;
    }
    for (var middle in route.route.middleware!) {
      middle.onMatch();
    }
  }

  bool runCanPop() {
    if (!route.hasMiddlewares) {
      return true;
    }
    for (var middle in route.route.middleware!) {
      if (!middle.canPop()) {
        return false;
      }
    }
    return true;
  }
}
