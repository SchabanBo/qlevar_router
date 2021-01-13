import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../qlevar_router.dart';

/// The match context tree for a route.
class MatchContext {
  final int key;
  final QRoute route;
  final String fullPath;
  final bool isComponent;
  final NaviKey navigatorKey;
  bool isNew;
  MatchContext childContext;

  MatchContext(
      {this.key,
      this.fullPath,
      this.isComponent,
      NaviKey navigatorKey,
      this.route,
      this.isNew = true,
      this.childContext})
      : navigatorKey = navigatorKey ?? NaviKey._();

  MatchContext copyWith({String fullPath, bool isComponent}) => MatchContext(
      key: key,
      fullPath: fullPath ?? this.fullPath,
      isComponent: isComponent ?? this.isComponent,
      navigatorKey: navigatorKey,
      route: route,
      isNew: isNew,
      childContext: childContext);

  void treeUpdated() {
    isNew = false;
    if (childContext != null) {
      childContext.treeUpdated();
    }
  }

  @override
  String toString() => 'Key: $key, path: $fullPath, Name: ${route.name}';

  void printTree({int padding = 0}) {
    QR.log(
        // ignore: prefer_interpolation_to_compose_strings
        ''.padLeft(padding, '-') +
            '${toString()} With key ${navigatorKey.code}');
    if (childContext != null) {
      childContext.printTree(padding: ++padding);
    }
  }
}

class NaviKey {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  NaviKey._();

  NavigatorState get state => navigatorKey.currentState;
  int get code => navigatorKey.hashCode;
}
