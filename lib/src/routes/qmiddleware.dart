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
  bool canPop() => true;

  /// This method will be called every time a path match it.
  void onMatch() {}

  /// This method will be called before adding the page to the stack
  ///  and before the page building
  void onEnter() {}

  /// This method will be called before removing the page from the stack
  void onExit() {}
}

class QMiddlewareBuilder extends QMiddleware {
  final Future<String?> Function(String)? redirectGuardFunc;
  final Future<QNameRedirect?> Function(String)? redirectGuardNameFunc;
  final Function? onMatchFunc;
  final Function? onEnterFunc;
  final Function? onExitFunc;
  final bool Function()? canPopFunc;

  QMiddlewareBuilder(
      {this.redirectGuardFunc,
      this.redirectGuardNameFunc,
      this.onMatchFunc,
      this.onEnterFunc,
      this.canPopFunc,
      this.onExitFunc});

  @override
  void onEnter() {
    if (onEnterFunc != null) {
      onEnterFunc!();
    }
  }

  @override
  void onExit() {
    if (onExitFunc != null) {
      onExitFunc!();
    }
  }

  @override
  void onMatch() {
    if (onMatchFunc != null) {
      onMatchFunc!();
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
  bool canPop() {
    if (canPopFunc != null) {
      return canPopFunc!();
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
