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
}

class QMiddlewareBuilder extends QMiddleware {
  final Future<String?> Function(String)? redirectGuardFunc;
  final Future<QNameRedirect?> Function(String)? redirectGuardNameFunc;
  final Future Function()? onMatchFunc;
  final Future Function()? onEnterFunc;
  final Future Function()? onExitFunc;
  final Future<bool> Function()? canPopFunc;

  QMiddlewareBuilder(
      {this.redirectGuardFunc,
      this.redirectGuardNameFunc,
      this.onMatchFunc,
      this.onEnterFunc,
      this.canPopFunc,
      this.onExitFunc});

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
