import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:qlevar_router/src/helpers/widgets/stack_tree.dart';
import '../../qlevar_router.dart';

import '../helpers/platform/platform_web.dart'
    if (dart.library.io) '../helpers/platform/platform_io.dart';
import '../match_context.dart';
import '../qpages.dart';
import '../qr.dart';
import '../types.dart';
import 'inner_router_delegate.dart';
import 'navigation_type.dart';
import 'page_types.dart';
import 'router_controller.dart';

class QNavigatorController {
  final _conManeger = _RouterControllerManger();

  void setNewMatch(MatchContext match, NavigationType type, bool justUrl,
      QNaviagtionMode mode) {
    mode ??= _getNaviagtionMode(match);
    switch (mode.type) {
      case QNaviagtionModeType.Child:
        _updatePathAsChild(_conManeger.rootController(), match, type, justUrl);
        break;
      case QNaviagtionModeType.ChildOf:
        // required the parent to be already in the tree.
        final parentController = _conManeger.withName(mode.name);
        if (parentController == null) {
          throw Exception(
              'Route with name ${mode.name} is not in the active tree');
        }
        _updateIfAllowed(parentController, match, type, justUrl);
        break;
      case QNaviagtionModeType.StackTo:
        // required the parent to be already in the old (to get the contoller)
        //and new (to use it as start point) tree.
        _updatePathAsStack(mode.name, match, justUrl);
        break;
      default:
        throw Exception('Unkown QNaviagtionMode');
    }
    //_conManeger.printAllStacksInfo();
  }

  QNaviagtionMode _getNaviagtionMode(MatchContext match) {
    final newRoute = match.getNewMatch();
    return newRoute.route.navigationMode ?? QR.settings.defaultNavigationMode;
  }

  void _updatePathAsChild(RouterController parentController, MatchContext match,
      NavigationType type, bool justUrl) {
    if (match.isNew) {
      _updateIfAllowed(parentController, match, type, justUrl);
      return;
    }
    if (match.childContext != null) {
      QR.log('$match is the old route. checking child', isDebug: true);
      final controller = _conManeger.withKey(match.key);
      controller.childCalled(match.childContext.route);
      _updatePathAsChild(controller, match.childContext, type, justUrl);
      return;
    }
    QR.log('No changes for $match was found');
  }

  void _updatePathAsStack(String name, MatchContext match, bool justUrl) {
    if (match.route.name != name && name != 'Root') {
      if (match.childContext == null) {
        throw Exception('Route with name $name is not in the current tree');
      }
      _updatePathAsStack(name, match.childContext, justUrl);
    }
    final controller = _conManeger.withName(name);
    if (controller == null) {
      throw Exception('Route with name $name is not in the active tree');
    }
    QR.history.removeLast();
    while (match.childContext != null) {
      final matchCopy = match.childContext.copyWith();
      matchCopy.childContext = null;
      _updateIfAllowed(controller, matchCopy, NavigationType.Push,
          match.childContext.childContext == null ? justUrl : true);
      match = match.childContext;
      QR.history.add(match.fullPath);
    }
  }

  void _updateIfAllowed(RouterController parentController, MatchContext match,
      NavigationType type, bool justUrl) {
    if (parentController.routeChild?.canChildNavigation != null) {
      parentController.routeChild.canChildNavigation().then((can) {
        if (can) {
          _update(parentController, match, type, justUrl);
        }
      });
    } else {
      _update(parentController, match, type, justUrl);
    }
  }

  void _update(RouterController parentController, MatchContext match,
      NavigationType type, bool justUrl) {
    QR.log('$match is the new route has the controller $parentController.',
        isDebug: true);
    _conManeger.rootController().updateUrl();
    final cleanupList =
        parentController.updatePage(_getPage(match, justUrl), type, justUrl);
    _conManeger.clean(cleanupList);
    match.treeUpdated();
  }

  QPage _getPage(MatchContext match, bool justUrl) {
    QRouteChild childRoute;
    if (match.childContext != null) {
      childRoute = _getInnerRouter(match, match.childContext, justUrl);
    }
    return _PageCreator(match, childRoute).create();
  }

  QRouteChild _getInnerRouter(
      MatchContext parent, MatchContext match, bool justUrl) {
    QR.log('Get Router for $match', isDebug: true);
    final childController =
        createRouterController(parent.key, parent.route.name, match, justUrl);
    final childRouter =
        QRouter(routerDelegate: InnerRouterDelegate(childController));
    childController.routeChild =
        QRouteChild(childRouter, currentChild: match.route);
    return childController.routeChild;
  }

  RouterController createRouterController(
          int key, String name, MatchContext match, bool justUrl) =>
      _conManeger.create(key, name, _getPage(match, justUrl), justUrl);

  bool back() {
    if (QR.history.length < 2) {
      return false;
    }
    QR.to(QR.history.elementAt(QR.history.length - 2),
        type: NavigationType.PopUntilOrPush);
    QR.history.removeRange(QR.history.length - 2, QR.history.length);
    return true;
  }

  RouterController routerOf(String name) => _conManeger.withName(name);

  DebugStackTree getStackTreeWidget() =>
      DebugStackTree(_conManeger._contollers);
}

class _RouterControllerManger {
  final _contollers = <RouterController>[];

  List<RouterController> get controllers => List.unmodifiable(_contollers);

  RouterController create(int key, String name, QPage page, bool justUrl) {
    if (_contollers.any((element) => element.key == key)) {
      final controller =
          _contollers.firstWhere((element) => element.key == key);
      controller.updatePage(page, NavigationType.PopUntilOrPush, justUrl);
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

  RouterController withName(String name) => _contollers
      .firstWhere((element) => element.name == name, orElse: () => null);

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

  void printAllStacksInfo() {
    for (var item in _contollers) {
      for (var page in item.pages) {
        print(
            '${item.key}-${item.name} Stack has matchKey: ${page.matchKey} and key ${page.key}, NavKey ${item.navKey.hashCode}');
      }
    }
  }
}

class _PageCreator {
  final MatchContext match;
  final QRouteChild childRoute;
  final QRPage pageType;
  final LocalKey key;

  _PageCreator(this.match, this.childRoute)
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
      child: match.route.page(childRoute),
      maintainState: pageType.maintainState,
      fullscreenDialog: pageType.fullscreenDialog,
      restorationId: pageType.restorationId,
      key: key,
      matchKey: match.key);

  QCupertinoPage _getCupertinoPage(String title) => QCupertinoPage(
      name: match.route.name,
      child: match.route.page(childRoute),
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
        child: match.route.page(childRoute),
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
        transitionsBuilder: page.transitionsBuilder ?? _buildTransaction);
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
