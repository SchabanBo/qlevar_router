import 'package:flutter/material.dart';
import 'routes_tree.dart';

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
  final List<QRoute> children;

  QRoute(
      {this.name,
      @required this.path,
      this.redirectGuard,
      this.page,
      this.children});
}

/// The cureent route inforamtion 
class QCurrentRoute {
  String fullPath = '';
  Map<String, dynamic> params = {};
  MatchContext match;
}

/// the match context for a route
class MatchContext {
  final int key;
  final String name;
  final String fullPath;
  String cureentPath;
  final bool isComponent;
  final QRouteBuilder page;
  MatchContext childContext;
  QRouter<dynamic> router;

  MatchContext(
      {this.name,
      this.key,
      this.fullPath,
      this.isComponent,
      this.page,
      this.childContext,
      this.router});

  MatchContext copyWith({String fullPath, bool isComponent}) => MatchContext(
      key: key,
      name: name,
      fullPath: fullPath ?? this.fullPath,
      isComponent: isComponent ?? this.isComponent,
      page: page,
      childContext: childContext,
      router: router);

  factory MatchContext.fromRoute(MatchRoute route,
          {QRouter<dynamic> router, MatchContext childContext}) =>
      MatchContext(
          name: route.route.name,
          isComponent: route.route.isComponent,
          key: route.route.key,
          fullPath: route.route.fullPath,
          page: route.route.page,
          childContext: childContext,
          router: router);

  MaterialPage toMaterialPage() =>
      MaterialPage(name: name, key: ValueKey(fullPath), child: page(router));

  void updatePath(String path){
    cureentPath = path;
    if (childContext!=null) {
      childContext.updatePath(path);
    }
  }

  void triggerChild() {
    if (router == null) {
      return;
    }
    router.routerDelegate.setNewRoutePath(childContext);
  }

  bool isMatch(MatchContext other) => other.isComponent
      ? fullPath == other.fullPath
      : key == other.key;

}
