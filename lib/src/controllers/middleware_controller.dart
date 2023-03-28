import 'package:flutter/material.dart';

import '../../qlevar_router.dart';
import '../routes/qroute_internal.dart';

class MiddlewareController {
  final QRouteInternal route;
  MiddlewareController(this.route);

  List<QMiddleware> get middleware {
    final list = <QMiddleware>[];
    if (route.hasMiddleware) {
      list.addAll(route.route.middleware!);
    }
    list.addAll(QR.settings.globalMiddlewares);
    list.sort((a, b) => a.priority.compareTo(b.priority));
    return list;
  }

  Future<String?> runRedirect() async {
    final path = route.getLastActivePath();
    for (var middle in middleware) {
      final result = await middle.redirectGuard(path);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  Future<QNameRedirect?> runRedirectName() async {
    final path = route.getLastActivePath();
    for (var middle in middleware) {
      final result = await middle.redirectGuardToName(path);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  Future runOnEnter() async {
    for (var middle in middleware) {
      await middle.onEnter();
    }
  }

  Future runOnExit() async {
    for (var middle in middleware) {
      await middle.onExit();
    }
  }

  Future scheduleOnExited() async {
    if (middleware.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.endOfFrame.then((_) {
        for (var middle in middleware) {
          middle.onExited();
        }
      });
    });
  }

  Future runOnMatch() async {
    for (var middle in middleware) {
      await middle.onMatch();
    }
  }

  Future<bool> runCanPop() async {
    for (var middle in middleware) {
      if (!await middle.canPop()) return false;
    }
    return true;
  }
}
