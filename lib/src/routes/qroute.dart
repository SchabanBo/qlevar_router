import 'package:flutter/widgets.dart';

import '../../qlevar_router.dart';
import '../routers/qrouter.dart';

abstract class QMiddleware {
  Future<String?> redirectGuard();
  void onMatch();
  void onEnter();
  void onExit();
}

typedef PageBuilder = Widget Function();
typedef PageWithChildBuilder = Widget Function(QRouter);

class QRoute {
  final String path;
  final String? name;
  final PageBuilder? builder;
  final PageWithChildBuilder? builderChild;
  final QPage? pageType;
  final List<QMiddleware>? middleware;
  final List<QRoute>? children;
  const QRoute({
    required this.path,
    required this.builder,
    this.name,
    this.pageType,
    this.middleware,
    this.children,
  })  : assert(builder != null),
        builderChild = null;

  const QRoute.withChild({
    required this.path,
    required this.builderChild,
    this.name,
    this.pageType,
    this.middleware,
    this.children,
  })  : assert(builderChild != null),
        builder = null;

  bool get withChildRouter => builderChild != null;
}
