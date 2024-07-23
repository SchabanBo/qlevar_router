/// QMiddleware is a class that can be used to add middleware to a route
/// you can use it to to run code on different route events like onEnter, onExit, onMatch
class QMiddleware {
  /// {@template QMiddleware.priority}
  /// The priority of the middleware, the lower the number the higher the priority
  /// Middleware with the same priority will be executed in the order they were added
  /// Middleware with higher priority will be executed first
  /// {@endtemplate}
  final int priority;

  /// QMiddleware constructor
  const QMiddleware({this.priority = 500});

  /// {@template QMiddleware.redirectGuard}
  /// This function will be called before [onEnter] and after [onMatch]
  /// if the result from this page is null the page will be created
  /// or the result should be the path to redirect to.
  /// {@endtemplate}
  Future<String?> redirectGuard(String path) async => null;

  /// {@template QMiddleware.redirectGuardToName}
  /// This function will be called before [onEnter] and after [onMatch]
  /// if the result from this page is null the page will be created
  /// or the result should be the name of the page to redirect to.
  /// but here you can redirect to name with params instead of path.
  /// {@endtemplate}
  Future<QNameRedirect?> redirectGuardToName(String path) async => null;

  /// {@template QMiddleware.canPop}
  /// can this route pop, called when trying to remove the page.
  /// if this function returns false the page will not be removed
  /// and the navigation will not continue
  /// this is useful for example if you want to show a dialog to the user
  /// to confirm that he wants to leave the page
  /// and if he doesn't want to leave the page you can return false
  /// and the page will not be removed
  ///{@endtemplate}
  /// ````dart
  /// canPop: () async => await showDialog<bool>(
  ///   context: context,
  ///   builder: (context) => AlertDialog(
  ///     title: Text('Are you sure?'),
  ///     actions: [
  ///       TextButton(
  ///         child: Text('Yes'),
  ///         onPressed: () => Navigator.of(context).pop(true),
  ///       ),
  ///       TextButton(
  ///         child: Text('No'),
  ///         onPressed: () => Navigator.of(context).pop(false),
  ///       ),
  ///     ],
  ///   ),
  /// ) ?? false,
  /// ````
  Future<bool> canPop() async => true;

  /// {@template QMiddleware.onMatch}
  /// This method will be called every time a path match it.
  /// {@endtemplate}
  Future onMatch() async {}

  /// {@template QMiddleware.redirectGuard}
  /// This method will be called before adding the page to the stack
  ///  and before the page building
  /// this is useful for creating the resources needed for the page
  /// like opening a stream or a controller
  /// {@endtemplate}
  Future onEnter() async {}

  /// {@template QMiddleware.onExit}
  /// This method will be called before removing the page from the stack
  /// and before the page is disposed
  /// this is useful for saving data before the page is removed
  /// {@endtemplate}
  Future onExit() async {}

  /// {@template QMiddleware.onExited}
  /// This method will be called after one frame after removing the page from the stack
  /// this is useful for cleaning up resources that are not needed anymore
  /// like closing a stream or a controller
  /// or for example if you want to show a snackbar after the page was removed
  /// you can use this method to show the snackbar
  /// {@endtemplate}
  void onExited() {}
}

/// QMiddlewareBuilder is a class that can be used to add middleware to a route
/// it can be used for quick creation of middleware
class QMiddlewareBuilder extends QMiddleware {
  /// {@macro QMiddleware.redirectGuard}
  final Future<String?> Function(String)? redirectGuardFunc;

  /// {@macro QMiddleware.redirectGuardName}
  final Future<QNameRedirect?> Function(String)? redirectGuardNameFunc;

  /// {@macro QMiddleware.onMatch}
  final Future Function()? onMatchFunc;

  /// {@macro QMiddleware.onEnter}
  final Future Function()? onEnterFunc;

  /// {@macro QMiddleware.onExit}
  final Future Function()? onExitFunc;

  /// {@macro QMiddleware.onExited}
  final Function? onExitedFunc;

  /// {@macro QMiddleware.canPop}
  final Future<bool> Function()? canPopFunc;

  /// QMiddlewareBuilder constructor
  QMiddlewareBuilder({
    this.redirectGuardFunc,
    this.redirectGuardNameFunc,
    this.onMatchFunc,
    this.onEnterFunc,
    this.canPopFunc,
    this.onExitFunc,
    this.onExitedFunc,
    super.priority,
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

  @override
  String toString() {
    return 'QNameRedirect(name: $name, params: $params)';
  }
}
