import '../../qlevar_router.dart';
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

  Future<QNameRedirect?> runRedirectName() async {
    final path = route.getLastActivePath();
    for (var middle in route.route.middleware!) {
      final result = await middle.redirectGuardToName(path);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  Future runOnEnter() async {
    if (!route.hasMiddleware) {
      return;
    }
    for (var middle in route.route.middleware!) {
      await middle.onEnter();
    }
  }

  Future runOnExit() async {
    if (!route.hasMiddleware) {
      return;
    }
    for (var middle in route.route.middleware!) {
      await middle.onExit();
    }
  }

  Future runOnMatch() async {
    if (!route.hasMiddleware) {
      return;
    }
    for (var middle in route.route.middleware!) {
      await middle.onMatch();
    }
  }

  Future<bool> runCanPop() async {
    if (!route.hasMiddleware) {
      return true;
    }
    for (var middle in route.route.middleware!) {
      if (!await middle.canPop()) {
        return false;
      }
    }
    return true;
  }
}
