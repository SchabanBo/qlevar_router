import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../types/qroute_key.dart';

abstract class QPageInternal<T> extends Page {
  const QPageInternal(
      {required this.matchKey,
      super.key,
      super.restorationId,
      super.name,
      super.arguments});

  final QKey matchKey;

  bool sameKey(QPageInternal other) => matchKey == other.matchKey;
}

class QMaterialPageInternal<T> extends QPageInternal<T> {
  const QMaterialPageInternal({
    required this.child,
    required super.matchKey,
    this.maintainState = true,
    this.addMaterialWidget = true,
    this.fullScreenDialog = false,
    super.key,
    super.restorationId,
    super.name,
    super.arguments,
  });

  final bool addMaterialWidget;
  final Widget child;
  final bool fullScreenDialog;
  final bool maintainState;

  @override
  Route<T> createRoute(BuildContext context) {
    return _PageBasedMaterialPageRoute<T>(page: this);
  }
}

// A page-based version of MaterialPageRoute.
//
// This route uses the builder from the page to build its content. This ensures
// the content is up to date after page updates.
class _PageBasedMaterialPageRoute<T> extends PageRoute<T>
    with MaterialRouteTransitionMixin<T> {
  _PageBasedMaterialPageRoute({
    required QMaterialPageInternal<T> page,
  }) : super(settings: page) {
    assert(opaque);
  }

  @override
  Widget buildContent(BuildContext context) {
    return _page.addMaterialWidget ? Material(child: _page.child) : _page.child;
  }

  @override
  String get debugLabel => '${super.debugLabel}(${_page.name})';

  @override
  bool get fullscreenDialog => _page.fullScreenDialog;

  @override
  bool get maintainState => _page.maintainState;

  QMaterialPageInternal<T> get _page => settings as QMaterialPageInternal<T>;
}

class QCupertinoPageInternal<T> extends QPageInternal<T> {
  const QCupertinoPageInternal({
    required super.matchKey,
    required this.child,
    this.title,
    this.maintainState = true,
    this.fullScreenDialog = false,
    super.key,
    super.restorationId,
    super.name,
    super.arguments,
  });

  final Widget child;
  final bool fullScreenDialog;
  final bool maintainState;
  final String? title;

  @override
  Route<T> createRoute(BuildContext context) {
    return _PageBasedCupertinoPageRoute<T>(page: this);
  }
}

class _PageBasedCupertinoPageRoute<T> extends PageRoute<T>
    with CupertinoRouteTransitionMixin<T> {
  _PageBasedCupertinoPageRoute({
    required QCupertinoPageInternal<T> page,
  }) : super(settings: page) {
    assert(opaque);
  }

  @override
  Widget buildContent(BuildContext context) => _page.child;

  @override
  String get debugLabel => '${super.debugLabel}(${_page.name})';

  @override
  bool get fullscreenDialog => _page.fullScreenDialog;

  @override
  bool get maintainState => _page.maintainState;

  @override
  String? get title => _page.title;

  QCupertinoPageInternal<T> get _page => settings as QCupertinoPageInternal<T>;
}

class QCustomPageInternal extends QPageInternal {
  const QCustomPageInternal({
    required this.child,
    required super.matchKey,
    required this.transitionDuration,
    required this.reverseTransitionDuration,
    required this.transitionsBuilder,
    this.maintainState = true,
    this.fullScreenDialog = false,
    this.barrierColor,
    this.barrierLabel,
    this.barrierDismissible,
    this.opaque,
    super.key,
    super.restorationId,
    super.name,
    super.arguments,
  });

  final Color? barrierColor;
  final bool? barrierDismissible;
  final String? barrierLabel;
  final Widget child;
  final bool fullScreenDialog;
  final bool maintainState;
  final bool? opaque;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
  final RouteTransitionsBuilder transitionsBuilder;

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      pageBuilder: (c, a1, a2) => child,
      settings: this,
      opaque: opaque ?? true,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible ?? false,
      barrierLabel: barrierLabel,
      transitionsBuilder: transitionsBuilder,
      fullscreenDialog: fullScreenDialog,
      maintainState: maintainState,
    );
  }
}
