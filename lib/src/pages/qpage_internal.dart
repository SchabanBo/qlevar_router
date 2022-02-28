import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../types/qroute_key.dart';

abstract class QPageInternal<T> extends Page {
  final QKey matchKey;

  const QPageInternal(
      {required this.matchKey,
      LocalKey? key,
      String? restorationId,
      String? name,
      Object? arguments})
      : super(
          arguments: arguments,
          key: key,
          name: name,
          restorationId: restorationId,
        );

  bool sameKey(QPageInternal other) => matchKey == other.matchKey;
}

class QMaterialPageInternal<T> extends QPageInternal<T> {
  const QMaterialPageInternal({
    required this.child,
    required QKey matchKey,
    this.maintainState = true,
    this.fullScreenDialog = false,
    LocalKey? key,
    String? restorationId,
    String? name,
    Object? arguments,
  }) : super(
          matchKey: matchKey,
          key: key,
          name: name,
          arguments: arguments,
          restorationId: restorationId,
        );

  final Widget child;
  final bool maintainState;
  final bool fullScreenDialog;

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

  QMaterialPageInternal<T> get _page => settings as QMaterialPageInternal<T>;

  @override
  Widget buildContent(BuildContext context) {
    return _page.child;
  }

  @override
  bool get maintainState => _page.maintainState;

  @override
  bool get fullscreenDialog => _page.fullScreenDialog;

  @override
  String get debugLabel => '${super.debugLabel}(${_page.name})';
}

class QCupertinoPageInternal<T> extends QPageInternal<T> {
  const QCupertinoPageInternal({
    required QKey matchKey,
    required this.child,
    this.title,
    this.maintainState = true,
    this.fullScreenDialog = false,
    LocalKey? key,
    String? restorationId,
    String? name,
    Object? arguments,
  }) : super(
          key: key,
          name: name,
          restorationId: restorationId,
          arguments: arguments,
          matchKey: matchKey,
        );

  final Widget child;
  final String? title;
  final bool maintainState;
  final bool fullScreenDialog;

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

  QCupertinoPageInternal<T> get _page => settings as QCupertinoPageInternal<T>;

  @override
  Widget buildContent(BuildContext context) => _page.child;

  @override
  String? get title => _page.title;

  @override
  bool get maintainState => _page.maintainState;

  @override
  bool get fullscreenDialog => _page.fullScreenDialog;

  @override
  String get debugLabel => '${super.debugLabel}(${_page.name})';
}

class QCustomPageInternal extends QPageInternal {
  final Widget child;
  final bool maintainState;
  final bool fullScreenDialog;
  final int transitionDuration;
  final int reverseTransitionDuration;
  final RouteTransitionsBuilder transitionsBuilder;
  final bool? opaque;
  final bool? barrierDismissible;
  final Color? barrierColor;
  final String? barrierLabel;

  const QCustomPageInternal({
    required this.child,
    required QKey matchKey,
    required this.transitionDuration,
    required this.reverseTransitionDuration,
    required this.transitionsBuilder,
    this.maintainState = true,
    this.fullScreenDialog = false,
    this.barrierColor,
    this.barrierLabel,
    this.barrierDismissible,
    this.opaque,
    LocalKey? key,
    String? restorationId,
    String? name,
    Object? arguments,
  }) : super(
          key: key,
          name: name,
          arguments: arguments,
          matchKey: matchKey,
          restorationId: restorationId,
        );

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      pageBuilder: (c, a1, a2) => child,
      settings: this,
      opaque: opaque ?? true,
      transitionDuration: Duration(milliseconds: transitionDuration),
      reverseTransitionDuration:
          Duration(milliseconds: reverseTransitionDuration),
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible ?? false,
      barrierLabel: barrierLabel,
      transitionsBuilder: transitionsBuilder,
      fullscreenDialog: fullScreenDialog,
      maintainState: maintainState,
    );
  }
}
