import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../types/qroute_key.dart';

abstract class QPageInternal<T> extends Page {
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

  final QKey matchKey;

  bool sameKey(QPageInternal other) => matchKey == other.matchKey;
}

class QMaterialPageInternal<T> extends QPageInternal<T> {
  const QMaterialPageInternal({
    required this.child,
    required QKey matchKey,
    this.maintainState = true,
    this.addMaterialWidget = true,
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

  final Color? barrierColor;
  final bool? barrierDismissible;
  final String? barrierLabel;
  final Widget child;
  final bool fullScreenDialog;
  final bool maintainState;
  final bool? opaque;
  final int reverseTransitionDuration;
  final int transitionDuration;
  final RouteTransitionsBuilder transitionsBuilder;

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
