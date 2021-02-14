import 'package:flutter/widgets.dart';
import 'qpages.dart';

class QRouter extends Router {
  QRouter({
    Key key,
    RouterDelegate routerDelegate,
    BackButtonDispatcher backButtonDispatcher,
  }) : super(
            key: key,
            routerDelegate: routerDelegate,
            backButtonDispatcher: backButtonDispatcher);
}

/// the child route for a page
class QRouteChild {
  /// The router for the child where the child will be displayed.
  final QRouter childRouter;

  /// a function will be called whenever a child (grandchild) for this
  /// route is called
  Function() onChildCall;

  /// The current displayed child
  QRoute currentChild;

  QRouteChild(this.childRouter, {this.onChildCall, this.currentChild});
}

/// The definition for the page. give you the [QRouter]
/// to use when navigation in children.
typedef QRoutePage = Widget Function(QRouteChild);

/// The definition to redirect. give you the cureent path
/// and expexted the new path to redirect to or null.
typedef RedirectGuard = String Function(String);

/// Create new route.
class QRoute extends QRouteBase {
  /// [name] the name of the route.
  final String name;

  /// [page] the page to show
  /// It give the child router to use it in the parent page
  /// when the route has children, otherwise it give null.
  final QRoutePage page;

  /// [redirectGuard] it gives the called path and takes the new path
  /// to navigate to, give it null when you don't want to redirect.
  final RedirectGuard redirectGuard;

  /// [onInit] a function to do what you need before initializing the route.
  final Function onInit;

  /// [onDispose] a function to do what you need before disposing the route.
  final Function onDispose;

  /// Set the initialize route for this route when it has children.
  /// This value will not be used if the route has no  children
  final String initRoute;

  /// [children] the children of this route.
  final List<QRouteBase> children;

  /// The page type to use with this route. Use can use [QRMaterialPage]
  /// or [QRCupertinoPage] or [QRPlatformPage] which is default.
  final QRPage pageType;

  const QRoute(
      {String name,
      String path,
      this.page,
      this.onInit,
      this.initRoute,
      this.onDispose,
      this.redirectGuard,
      this.pageType = const QRPlatformPage(),
      this.children})
      : assert(path != null),
        assert(redirectGuard != null || page != null),
        name = name ?? path,
        super(path);

  /// Create a copy of this class.
  QRoute copyWith({
    String name,
    String path,
    QRoutePage page,
    RedirectGuard redirectGuard,
    Function onInit,
    Function onDispose,
    List<QRoute> children,
  }) =>
      QRoute(
        name: name ?? this.name,
        path: path ?? this.path,
        page: page ?? this.page,
        redirectGuard: redirectGuard ?? this.redirectGuard,
        onInit: onInit ?? this.onInit,
        onDispose: onDispose ?? this.onDispose,
        children: children ?? this.children,
      );
}

/// The base class for the routes
abstract class QRouteBase {
  /// [path] the path of the route.
  final String path;
  const QRouteBase(this.path);
}

/// Create a [QRoute] as a class, useful to organize your project.
// ignore: one_member_abstracts
abstract class QRouteBuilder extends QRouteBase {
  const QRouteBuilder({String path}) : super(path);
  QRoute createRoute();
}
