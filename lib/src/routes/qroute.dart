import 'package:flutter/widgets.dart';

import '../../qlevar_router.dart';
import '../routers/qrouter.dart';
import 'qmiddleware.dart';

typedef PageBuilder = Widget Function();
typedef PageWithChildBuilder = Widget Function(QRouter);

/// Define a route
class QRoute {
  ///Set the path to this Route
  ///then use `QR.to()`to navigate to it.
  ///
  ///6ou can add path parmeter easily like this:
  ///`/products/:id`
  ///and recive it using `QR.params['id']`
  ///
  ///More over you can add Regex to this paramter
  ///'`/products/:id(^[0-9]\$)'` any id with more than one number
  ///Will be directed to the notfound route
  ///
  ///Useful regex:
  ///
  ///
  /// `^[0-9]*$` none or many numbers only.
  ///
  /// `^[0-9]+$` one or more numbers only.
  ///
  /// `^[0-9]$`  one numbers only.
  ///
  /// `(a | b | c )` one value only  a or b or.
  final String path;

  /// The name for this route
  final String? name;

  /// The default widget builder for this route
  final PageBuilder? builder;

  /// Widget builder with a [QRouter] for the nested navigation
  /// use it with [QRoute.withChild]
  final PageWithChildBuilder? builderChild;

  /// Set the page type for this route
  /// you can use [QMaterialPage], [QCupertinoPage] or [QPlatformPage]
  /// The default is [QPlatformPage]
  final QPage? pageType;

  /// Define a Middlewares for this route
  /// with [QMiddleware] or [QMiddlewareBuilder]
  final List<QMiddleware>? middleware;

  /// Set the initPath for the route, used with [QRoute.withChild]
  final String? initRoute;

  /// The childrens for this route
  final List<QRoute>? children;
  const QRoute({
    required this.path,
    required this.builder,
    this.name,
    this.pageType,
    this.middleware,
    this.children,
  })  : assert(builder != null),
        initRoute = null,
        builderChild = null;

  /// Call this function to get a [QRouter] to use it for Nested Navigation
  const QRoute.withChild({
    required this.path,
    required this.builderChild,
    this.initRoute,
    this.name,
    this.pageType,
    this.middleware,
    this.children,
  })  : assert(builderChild != null),
        builder = null;

  /// does this route use [QRouter]
  bool get withChildRouter => builderChild != null;
}
