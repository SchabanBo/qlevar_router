import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../qlevar_router.dart';
import '../../qr.dart';

/// The match context for a route.
class MatchContext {
  final int key;
  final String name;
  final String fullPath;
  final bool isComponent;
  final QRoutePage page;
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
