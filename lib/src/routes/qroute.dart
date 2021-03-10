import 'package:flutter/widgets.dart';

import '../../qlevar_router.dart';
import '../routers/qrouter.dart';
import 'qmiddleware.dart';

typedef PageBuilder = Widget Function();
typedef PageWithChildBuilder = Widget Function(QRouter);

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
  ///
  final String path;
  final String? name;
  final PageBuilder? builder;
  final PageWithChildBuilder? builderChild;
  final QPage? pageType;
  final List<QMiddleware>? middleware;
  final String? initRoute;
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

  bool get withChildRouter => builderChild != null;
}
