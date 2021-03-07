import '../routes/qroute_internal.dart';

class MiddlewareController {
  final QRouteInternal route;
  MiddlewareController(this.route);

  Future<String?> runRedirect() async {
    for (var middle in route.route.middleware!) {
      final result = await middle.redirectGuard();
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
}
