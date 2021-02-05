import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../helpers/platform/platform_web.dart'
    if (dart.library.io) '../helpers/platform/platform_io.dart';
import '../match_context.dart';
import '../qpages.dart';
import '../qr.dart';
import '../types.dart';
import 'navigation_mode.dart';
import 'navigator.dart';
import 'pages.dart';
import 'router_controller.dart';

class QNavigatorController {
  final _conManeger = _RouterControllerManger();

  void setNewMatch(MatchContext match, NavigationType mode, bool justUrl) {
    _updatePath(_conManeger.rootController(), match, mode, justUrl);
  }

  void _updatePath(RouterController parentRequest, MatchContext match,
      NavigationType mode, bool justUrl) {
    if (match.isNew) {
      QR.log('$match is the new route has the reqest $parentRequest.',
          isDebug: true);
      final cleanupList =
          parentRequest.updatePage(_getPage(match), mode, justUrl);
      _conManeger.clean(cleanupList);
      _conManeger.rootController().updateUrl();
      match.treeUpdated();
      return;
    }
    if (match.childContext != null) {
      QR.log('$match is the old route. checking child', isDebug: true);
      final request = _conManeger.withKey(match.key);
      _updatePath(request, match.childContext, mode, justUrl);
      return;
    }
    QR.log('No changes for $match was found');
  }

  QPage _getPage(MatchContext match) {
    final childRouter = match.childContext == null
        ? null
        : _getInnerRouter(match, match.childContext);

    return _PageCreator(match, childRouter).create();
  }

  QRouter _getInnerRouter(MatchContext parent, MatchContext match) {
    QR.log('Get Router for $match', isDebug: true);
    return QRouter(
      routerDelegate: InnerRouterDelegate(
          createRouterController(parent.key, parent.route.name, match)),
    );
  }

  RouterController createRouterController(
          int key, String name, MatchContext match) =>
      _conManeger.create(key, name, _getPage(match));

  bool pop() {
    if (QR.history.length < 2) {
      return false;
    }
    QR.to(QR.history.elementAt(QR.history.length - 2));
    QR.history.removeRange(QR.history.length - 2, QR.history.length);
    return true;
  }
}

class _RouterControllerManger {
  final _contollers = <RouterController>[];

  RouterController create(int key, String name, QPage page) {
    if (_contollers.any((element) => element.key == key)) {
      final controller =
          _contollers.firstWhere((element) => element.key == key);
      controller.updatePage(page, NavigationType.PopUntilOrPush, false);
      return controller;
    }
    final controller = RouterController(key: key, name: name, initPage: page);
    _contollers.add(controller);
    return controller;
  }

  RouterController rootController() => _contollers
      .firstWhere((element) => element.key == -1, orElse: () => null);

  RouterController withKey(int key) => _contollers
      .firstWhere((element) => element.key == key, orElse: () => null);

  void clean(List<int> cleanup) {
    for (var key in cleanup) {
      if (_contollers.any((element) => element.key == key)) {
        clean(withKey(key).pages.map((e) => e.matchKey).toList());
      }
      _cleanIfExist(key);
    }
  }

  void _cleanIfExist(int key) {
    if (_contollers.any((element) => element.key == key)) {
      final controller =
          _contollers.firstWhere((element) => element.key == key);
      _contollers.remove(controller);
      QR.log('Controller ${controller.toString()} is Deleted', isDebug: true);
    }
  }
}

class _PageCreator {
  final MatchContext match;
  final QRouter childRouter;
  final QRPage pageType;
  final LocalKey key;

  _PageCreator(this.match, this.childRouter)
      : pageType = match.route.pageType,
        key = ValueKey<int>(Random().nextInt(10000));
  QPage create() {
    if (pageType is QRPlatformPage) {
      if (!QPlatform.isWeb && QPlatform.isIOS) {
        return _getCupertinoPage(match.route.name);
      }
      return _getMaterialPage();
    }
    if (pageType is QRCupertinoPage) {
      return _getCupertinoPage((pageType as QRCupertinoPage).title);
    }
    if (pageType is QRCustomPage) {
      return _getCustomPage();
    }
    return _getMaterialPage();
  }

  QMaterialPage _getMaterialPage() => QMaterialPage(
      name: match.route.name,
      child: match.route.page(childRouter),
      maintainState: pageType.maintainState,
      fullscreenDialog: pageType.fullscreenDialog,
      restorationId: pageType.restorationId,
      key: key,
      matchKey: match.key);

  QCupertinoPage _getCupertinoPage(String title) => QCupertinoPage(
      name: match.route.name,
      child: match.route.page(childRouter),
      maintainState: pageType.maintainState,
      fullscreenDialog: pageType.fullscreenDialog,
      restorationId: pageType.restorationId,
      title: title,
      key: key,
      matchKey: match.key);

  QCustomPage _getCustomPage() {
    final page = pageType as QRCustomPage;
    return QCustomPage(
        name: match.route.name,
        child: match.route.page(childRouter),
        maintainState: pageType.maintainState,
        fullscreenDialog: pageType.fullscreenDialog,
        restorationId: pageType.restorationId,
        key: key,
        matchKey: match.key,
        barrierColor: page.barrierColor,
        barrierDismissible: page.barrierDismissible,
        barrierLabel: page.barrierLabel,
        opaque: page.opaque,
        reverseTransitionDuration: page.reverseTransitionDurationmilliseconds,
        transitionDuration: page.transitionDurationmilliseconds,
        transitionsBuilder: _buildTransaction);
  }

  Widget _buildTransaction(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (pageType is QRSlidePage) {
      final slide = pageType as QRSlidePage;
      return SlideTransition(
          child: child,
          position: CurvedAnimation(
                  parent: animation, curve: slide.curve ?? Curves.easeIn)
              .drive(Tween<Offset>(
                  end: Offset.zero, begin: slide.offset ?? Offset(1, 0))));
    }
    return child;
  }
}
