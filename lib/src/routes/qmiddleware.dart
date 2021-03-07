abstract class QMiddleware {
  /// This function will be called before [onEnter] and after [onMatch]
  /// if the result from this page is null the page will be created
  /// or the result should be the path to redirect to.
  Future<String?> redirectGuard();

  /// This method will be called ervery time a path match it.
  void onMatch();

  /// This method will be called before adding the page to the stack
  ///  and before the page building
  void onEnter();

  /// This method will be called before removeimg the page from the stack
  void onExit();
}

class QMiddlewareBuilder extends QMiddleware {
  final Future<String?> Function()? redirectGuardFunc;
  final Function? onMatchFunc;
  final Function? onEnterFunc;
  final Function? onExitFunc;

  QMiddlewareBuilder(
      {this.redirectGuardFunc,
      this.onMatchFunc,
      this.onEnterFunc,
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
  Future<String?> redirectGuard() async {
    if (redirectGuardFunc != null) {
      return redirectGuardFunc!();
    }
    return null;
  }
}
