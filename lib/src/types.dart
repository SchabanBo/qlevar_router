import 'package:flutter/material.dart';

/// QRouter to palce where the children of natsten route should appear.
class QRouter<T> extends Router<T> {
  const QRouter({
    Key key,
    RouteInformationProvider routeInformationProvider,
    RouteInformationParser<T> routeInformationParser,
    @required RouterDelegate<T> routerDelegate,
    BackButtonDispatcher backButtonDispatcher,
  }) : super(
            key: key,
            backButtonDispatcher: backButtonDispatcher,
            routeInformationParser: routeInformationParser,
            routeInformationProvider: routeInformationProvider,
            routerDelegate: routerDelegate);
}

typedef QRoutePage = Widget Function(QRouter);
typedef RedirectGuard = String Function(String);

/// Create new route.
/// [name] the name of the route.
/// [path] the path of the route.
/// [page] the page to show
/// [onInit] a function to do what you need before initializing the route.
/// [onDispose] a function to do what you need before disposing the route.
/// It give the child router to use it in the parent page
/// when the route has children, otherwise it give null.
/// [redirectGuard] it gives the called path and takes the new path
/// to navigate to, give it null when you don't want to redirect.
/// [children] the children of this route.
class QRoute extends QRouteBase {
  final String name;
  final QRoutePage page;
  final RedirectGuard redirectGuard;
  final Function onInit;
  final Function onDispose;
  final List<QRouteBase> children;

  QRoute(
      {this.name,
      String path,
      this.page,
      this.onInit,
      this.onDispose,
      this.redirectGuard,
      this.children})
      : assert(path != null),
        assert(redirectGuard != null || page != null),
        super(path);

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

abstract class QRouteBase {
  final String path;
  QRouteBase(this.path);
}

/// Create a [QRoute]
// ignore: one_member_abstracts
abstract class QRouteBuilder extends QRouteBase {
  QRouteBuilder({String path}) : super(path);
  QRoute createRoute();
}
