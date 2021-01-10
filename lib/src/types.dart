import 'package:flutter/material.dart';

import '../qlevar_router.dart';
import 'routes_tree.dart';

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

typedef QRouteBuilder = Widget Function(QRouter);
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
class QRoute {
  final String name;
  final String path;
  final QRouteBuilder page;
  final RedirectGuard redirectGuard;
  final Function onInit;
  final Function onDispose;
  final List<QRoute> children;

  QRoute(
      {this.name,
      @required this.path,
      this.page,
      this.onInit,
      this.onDispose,
      this.redirectGuard,
      this.children})
      : assert(path != null),
        assert(redirectGuard != null || page != null);

  QRoute copyWith({
    String name,
    String path,
    QRouteBuilder page,
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

/// The match context for a route.
class MatchContext {
  final int key;
  final String name;
  final String fullPath;
  final bool isComponent;
  final QRouteBuilder page;
  final Function onInit;
  final Function onDispose;
  MatchContext childContext;
  QNavigationMode mode;
  QRouter<dynamic> router;

  MatchContext(
      {this.name,
      this.key,
      this.fullPath,
      this.isComponent,
      this.onInit,
      this.onDispose,
      this.page,
      this.mode,
      this.childContext,
      this.router});

  MatchContext copyWith({String fullPath, bool isComponent}) => MatchContext(
      key: key,
      name: name,
      fullPath: fullPath ?? this.fullPath,
      onInit: onInit,
      onDispose: onDispose,
      isComponent: isComponent ?? this.isComponent,
      page: page,
      childContext: childContext,
      router: router);

  factory MatchContext.fromRoute(MatchRoute route,
          {QRouter<dynamic> router, MatchContext childContext}) =>
      MatchContext(
          name: route.route.name,
          isComponent: route.route.isComponent,
          onDispose: route.route.onDispose,
          onInit: route.route.onInit,
          key: route.route.key,
          fullPath: route.route.fullPath,
          page: route.route.page,
          childContext: childContext,
          router: router);

  MaterialPage toMaterialPage() =>
      MaterialPage(name: name, key: ValueKey(fullPath), child: page(router));

  void setNavigationMode(QNavigationMode nMode) {
    mode = nMode;
    if (childContext != null) {
      childContext.setNavigationMode(nMode);
    }
  }

  void triggerChild() {
    if (router == null) {
      return;
    }
    router.routerDelegate.setNewRoutePath(childContext);
  }

  bool isMatch(MatchContext other) =>
      other.isComponent ? fullPath == other.fullPath : key == other.key;
}
