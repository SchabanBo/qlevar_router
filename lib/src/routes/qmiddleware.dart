import 'package:flutter/material.dart';

class QMiddleware {
  /// This function will be called before [onEnter] and after [onMatch]
  /// if the result from this page is null the page will be created
  /// or the result should be the path to redirect to.
  Future<String?> redirectGuard(String path) async => null;

  /// This function will be called before [onEnter] and after [onMatch]
  /// if the result from this page is null the page will be created
  /// or the result should be the name of the page to redirect to.
  Future<QNameRedirect?> redirectGuardToName(String path) async => null;

  /// can this route pop, called when trying to remove the page.
  Future<bool> canPop() async => true;

  /// This method will be called every time a path match it.
  Future onMatch() async {}

  /// This method will be called before adding the page to the stack
  ///  and before the page building
  Future onEnter() async {}

  /// This method will be called before removing the page from the stack
  Future onExit() async {}

  /// This method will be called one frame after the page was removed from the stack
  void onExited() {}
}

class QMiddlewareBuilder extends QMiddleware {
  /// This function will be called before [onEnter] and after [onMatch]
  /// if the result from this page is null the navigation will continue and
  /// the page will be created or the result should be the path to redirect to.
  /// ````
  /// redirectGuardFunc: (s) async => isAuthed ? null : '/login',
  /// ````
  final Future<String?> Function(String)? redirectGuardFunc;

  /// This function will be called before [onEnter] and after [onMatch]
  /// if the result from this page is null the page will be created
  /// or the result should be the name of the page to redirect to.
  /// but here you can redirect to name with params instead of path.
  /// ````
  /// redirectGuardNameFunc: (s) async =>
  ///     isAuthed ? null : QNameRedirect(name: Routes.login),
  /// ````
  final Future<QNameRedirect?> Function(String)? redirectGuardNameFunc;

  /// This method will be called every time a path matches the assigned route.
  final Future Function()? onMatchFunc;

  /// This method will be called before adding the page to the stack
  /// and before the page building function is called.
  final Future Function()? onEnterFunc;

  /// This method will be called before removing the page from the stack
  final Future Function()? onExitFunc;

  // This method will be called one frame after the page was removed from the stack
  final VoidCallback? onExitedFunc;

  /// Can this route pop, called when trying to remove the page.
  /// ````
  /// // if you want to allow the page to pop only when user saves the data
  /// canPopFunc: () async {
  ///      return Storage.isDataSaved();
  /// }
  /// ````
  final Future<bool> Function()? canPopFunc;

  QMiddlewareBuilder({
    this.redirectGuardFunc,
    this.redirectGuardNameFunc,
    this.onMatchFunc,
    this.onEnterFunc,
    this.canPopFunc,
    this.onExitFunc,
    this.onExitedFunc,
  });

  @override
  Future onEnter() async {
    if (onEnterFunc != null) {
      await onEnterFunc!();
    }
  }

  @override
  Future onExit() async {
    if (onExitFunc != null) {
      await onExitFunc!();
    }
  }

  @override
  void onExited() {
    if (onExitedFunc != null) {
      onExitedFunc!();
    }
  }

  @override
  Future onMatch() async {
    if (onMatchFunc != null) {
      await onMatchFunc!();
    }
  }

  @override
  Future<String?> redirectGuard(String path) async {
    if (redirectGuardFunc != null) {
      return redirectGuardFunc!(path);
    }
    return null;
  }

  @override
  Future<QNameRedirect?> redirectGuardToName(String path) async {
    if (redirectGuardNameFunc != null) {
      return redirectGuardNameFunc!(path);
    }
    return null;
  }

  @override
  Future<bool> canPop() async {
    if (canPopFunc != null) {
      return await canPopFunc!();
    }
    return true;
  }
}

/// use this object with `QMiddleware.redirectGuardToName`
/// to redirect to page with name and params
class QNameRedirect {
  final String name;
  final Map<String, Object>? params;
  const QNameRedirect({required this.name, this.params});
}
