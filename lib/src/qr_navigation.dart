part of 'qr.dart';

extension QRNavigation on QRContext {
  /// try to pop the last active navigator or go to last path in the history
  Future<PopResult> back([dynamic result]) async {
    // Prevent concurrent back() calls (e.g. double-tap)
    if (_backLock != null) {
      await _backLock!.future;
      return PopResult.NotPopped;
    }
    _backLock = Completer<void>();
    try {
      return await _backInternal(result);
    } finally {
      _backLock!.complete();
      _backLock = null;
    }
  }

  /// {@macro q.navigator.popUntilOrPush}
  Future<void> popUntilOrPush(String path) => navigator.popUntilOrPush(path);

  /// {@macro q.navigator.popUntilOrPushName}
  Future<void> popUntilOrPushName(String name,
          {Map<String, dynamic>? params}) =>
      navigator.popUntilOrPushName(name, params: params);

  /// {@macro q.navigator.push}
  Future<void> push(String path) => navigator.push(path);

  /// {@macro q.navigator.pushName}
  Future<void> pushName(String name, {Map<String, dynamic>? params}) =>
      navigator.pushName(name, params: params);

  /// {@macro q.navigator.replace}
  Future<void> replace(String path, String withPath) =>
      navigator.replace(path, withPath);

  /// {@macro q.navigator.replaceAll}
  Future<void> replaceAll(String path) => navigator.replaceAll(path);

  /// {@macro q.navigator.replaceAllWithName}
  Future<void> replaceAllWithName(String name,
          {Map<String, dynamic>? params}) =>
      navigator.replaceAllWithName(name, params: params);

  /// {@macro q.navigator.replaceLast}
  Future<void> replaceLast(String path) => navigator.replaceLast(path);

  /// {@macro q.navigator.replaceLastName}
  Future<void> replaceLastName(String name, {Map<String, dynamic>? params}) =>
      navigator.replaceLastName(name, params: params);

  /// {@macro q.navigator.replaceName}
  Future<void> replaceName(String name, String withName,
          {Map<String, dynamic>? params, Map<String, dynamic>? withParams}) =>
      navigator.replaceName(name, withName,
          params: params, withParams: withParams);

  /// {@macro q.navigator.switchTo}
  Future<void> switchTo(String path) => navigator.switchTo(path);

  /// {@macro q.navigator.switchToName}
  Future<void> switchToName(String name, {Map<String, dynamic>? params}) =>
      navigator.switchToName(name, params: params);

  /// Navigate to this path.
  /// The package will try to get the right navigator to this path.
  /// Set [ignoreSamePath] to true to ignore the navigation if the current path
  /// is the same as the route path
  /// Use [pageAlreadyExistAction](https://github.com/SchabanBo/qlevar_router#pagealreadyexistaction) to define what to do when
  /// page already is in the stack you can remove the page
  /// or just bring it to the top
  Future<T?> to<T>(
    String path, {
    bool ignoreSamePath = true,
    PageAlreadyExistAction? pageAlreadyExistAction,
    bool waitForResult = false,
  }) async {
    if (ignoreSamePath && isCurrentPath(path)) {
      return null;
    }
    final controller = _manager.withName(activeNavigatorName);
    var match = await controller.findPath(path);
    await _toMatch(match, activeNavigatorName, pageAlreadyExistAction);
    if (waitForResult) return match.getFuture();
    return null;
  }

  /// Go to a route with given [name] and [params]
  /// Set [ignoreSamePath] to true to ignore the navigation if the current path
  /// is the same as the route path
  /// Use [pageAlreadyExistAction](https://github.com/SchabanBo/qlevar_router#pagealreadyexistaction) to define what to do when
  /// page already is in the stack you can remove the page
  /// or just bring it to the top
  Future<T?> toName<T>(
    String name, {
    Map<String, dynamic>? params,
    bool ignoreSamePath = true,
    PageAlreadyExistAction? pageAlreadyExistAction,
    bool waitForResult = false,
  }) async {
    if (ignoreSamePath && isCurrentName(name, params: params)) {
      return null;
    }
    final controller = _manager.withName(activeNavigatorName);
    var match = await controller.findName(name, params: params);
    await _toMatch(match, activeNavigatorName, pageAlreadyExistAction);
    if (waitForResult) return match.getFuture();
    return null;
  }

  Future<PopResult> _backInternal([dynamic result]) async {
    log('Back to previous path');
    if (history.isEmpty) return PopResult.NotPopped;

    // is processed by declarative
    if (_manager.isDeclarative(history.current.key.key)) {
      final dCon = _manager.getDeclarative(history.current.key.key);
      if (dCon.pop()) return PopResult.Popped;
    }

    final lastNavigator = history.current.navigator;
    if (_manager.hasController(lastNavigator)) {
      final popNavigatorOptions = [lastNavigator];
      // Should navigator be removed? if the last path in history is the last
      // path in the navigator then we need to pop the navigator before it and
      // close this one
      if (history.hasLast && lastNavigator != history.last.navigator) {
        popNavigatorOptions.add(history.last.navigator);
      }

      for (final navigator in popNavigatorOptions) {
        final controller = navigatorOf(navigator) as QRouterController;
        if (!controller.isTemporary) {
          // check if there is any popups to close, Check [#101]
          final popupController = _manager.controllerWithPopup();
          if (popupController != null) {
            popupController.closePopup(result);
            QR.updateUrlInfo(QR.currentPath, addHistory: false);
            return PopResult.PopupDismissed;
          }
        }
        final popResult = await controller.removeLast(result: result);

        switch (popResult) {
          case PopResult.NotPopped:
            // If this is the only navigator and didn't pop and there is no history
            // then we need to close the app &
            // is this the last navigator?
            if (navigator == popNavigatorOptions.last) {
              if (history.hasLast) {
                // there is a history, go to the last path
                continue;
              }
              // Close the app, there is nothing to get back to see [#69].
              return popResult;
            }
            // this navigator can't pop, so remove it from the history see [#72]
            if (_isOnlyNavigatorLeft(popNavigatorOptions)) {
              history.removeWithNavigator(navigator);
            }
            // if this navigator is temporary then remove it, because it can't pop
            if (controller.isTemporary) {
              await removeNavigator(navigator);
            }
            break;
          case PopResult.Popped:
            // if this navigator popped and was not the root navigator then
            // notify the root navigator to update the UI
            if (navigator != QRContext.rootRouterName) {
              (rootNavigator as QRouterController).update(withParams: false);
            }
            return PopResult.Popped;
          default:
            return popResult;
        }
      }
    }

    if (!history.hasLast) {
      return PopResult.NotPopped;
    }

    await to(history.last.path);
    history.removeLast(count: 2);
    return PopResult.Popped;
  }

  /// check if the given navigator is the only one in the history
  bool _isOnlyNavigatorLeft(List<String> navigators) {
    for (var navigator in navigators) {
      if (history.entries.where((h) => h.navigator == navigator).length > 1) {
        return false;
      }
    }
    return true;
  }

  Future<void> _toMatch(QRouteInternal match, String forController,
      PageAlreadyExistAction? pageAlreadyExistAction) async {
    final controller = _manager.withName(forController);
    await controller.popUntilOrPushMatch(
      match,
      checkChild: false,
      pageAlreadyExistAction:
          pageAlreadyExistAction ?? PageAlreadyExistAction.Remove,
    );
    if (match.hasChild && !match.isProcessed) {
      final newControllerName =
          _manager.hasController(match.name) ? match.name : forController;
      await _toMatch(match.child!, newControllerName, pageAlreadyExistAction);
      return;
    }

    if (match.isProcessed) return;
    if (currentPath != match.activePath!) {
      // See [#18]
      final samePathFromInit = match.route.withChildRouter &&
          match.route.initRoute != null &&
          currentPath == (match.activePath! + match.route.initRoute!);
      if (!samePathFromInit) {
        updateUrlInfo(match.activePath!,
            mKey: match.key,
            params: match.params!.asValueMap,
            // The history should be added for the child init route
            // so use the parent name as navigator
            navigator: match.route.name ?? match.route.path,
            // Add history so currentPath become like activePath
            addHistory: true);
        return;
      }
    }
    if (forController != QRContext.rootRouterName) {
      (rootNavigator as QRouterController).update(withParams: false);
    }
  }
}
