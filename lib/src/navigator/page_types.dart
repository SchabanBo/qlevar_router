import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class QPage<T> extends Page {
  final int matchKey;

  const QPage(
      {this.matchKey,
      LocalKey key,
      String restorationId,
      String name,
      Object arguments})
      : super(
            //restorationId: restorationId,
            arguments: arguments,
            key: key,
            name: name);

  bool sameMatchKey(int other) => matchKey == other;
}

class QMaterialPage<T> extends QPage<T> {
  const QMaterialPage({
    this.child,
    this.maintainState = true,
    this.fullscreenDialog = false,
    int matchKey,
    String restorationId,
    LocalKey key,
    String name,
    Object arguments,
  }) : super(
            matchKey: matchKey,
            key: key,
            name: name,
            arguments: arguments,
            restorationId: restorationId);

  final Widget child;
  final bool maintainState;
  final bool fullscreenDialog;

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
    QMaterialPage<T> page,
  })  : assert(page != null),
        super(settings: page) {
    assert(opaque);
  }

  QMaterialPage<T> get _page => settings as QMaterialPage<T>;

  @override
  Widget buildContent(BuildContext context) {
    return _page.child;
  }

  @override
  bool get maintainState => _page.maintainState;

  @override
  bool get fullscreenDialog => _page.fullscreenDialog;

  @override
  String get debugLabel => '${super.debugLabel}(${_page.name})';
}

class QCupertinoPage<T> extends QPage<T> {
  const QCupertinoPage({
    this.child,
    this.maintainState = true,
    this.title,
    this.fullscreenDialog = false,
    int matchKey,
    String restorationId,
    LocalKey key,
    String name,
    Object arguments,
  })  : assert(child != null),
        assert(maintainState != null),
        assert(fullscreenDialog != null),
        super(
            key: key,
            name: name,
            arguments: arguments,
            matchKey: matchKey,
            restorationId: restorationId);

  final Widget child;
  final String title;
  final bool maintainState;
  final bool fullscreenDialog;

  @override
  Route<T> createRoute(BuildContext context) {
    return _PageBasedCupertinoPageRoute<T>(page: this);
  }
}

class _PageBasedCupertinoPageRoute<T> extends PageRoute<T>
    with CupertinoRouteTransitionMixin<T> {
  _PageBasedCupertinoPageRoute({
    QCupertinoPage<T> page,
  })  : assert(page != null),
        super(settings: page) {
    assert(opaque);
  }

  QCupertinoPage<T> get _page => settings as QCupertinoPage<T>;

  @override
  Widget buildContent(BuildContext context) => _page.child;

  @override
  String get title => _page.title;

  @override
  bool get maintainState => _page.maintainState;

  @override
  bool get fullscreenDialog => _page.fullscreenDialog;

  @override
  String get debugLabel => '${super.debugLabel}(${_page.name})';
}

class QCustomPage extends QPage {
  final Widget child;
  final bool maintainState;
  final bool fullscreenDialog;
  final int transitionDuration;
  final int reverseTransitionDuration;
  final bool opaque;
  final bool barrierDismissible;
  final Color barrierColor;
  final String barrierLabel;
  final RouteTransitionsBuilder transitionsBuilder;

  const QCustomPage({
    String restorationId,
    int matchKey,
    LocalKey key,
    String name,
    Object arguments,
    this.child,
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.barrierColor,
    this.barrierDismissible,
    this.barrierLabel,
    this.opaque,
    this.reverseTransitionDuration,
    this.transitionDuration,
    this.transitionsBuilder,
  })  : assert(child != null),
        assert(maintainState != null),
        assert(fullscreenDialog != null),
        super(
            key: key,
            name: name,
            arguments: arguments,
            matchKey: matchKey,
            restorationId: restorationId);

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
      fullscreenDialog: fullscreenDialog,
      maintainState: maintainState,
    );
  }
}
