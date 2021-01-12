import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../qlevar_router.dart';

/// The match context tree for a route.
class MatchContext {
  final int key;
  final QRoute route;
  final String fullPath;
  final bool isComponent;
  final GlobalKey<NavigatorState> navigatorKey;
  MatchContext childContext;

  MatchContext(
      {this.key,
      this.fullPath,
      this.isComponent,
      GlobalKey<NavigatorState> navigatorKey,
      this.route,
      this.childContext})
      : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();

  MatchContext copyWith({String fullPath, bool isComponent}) => MatchContext(
      key: key,
      fullPath: fullPath ?? this.fullPath,
      isComponent: isComponent ?? this.isComponent,
      navigatorKey: navigatorKey,
      route: route,
      childContext: childContext);

  bool isMatch(MatchContext other) =>
      other.isComponent ? fullPath == other.fullPath : key == other.key;
}
