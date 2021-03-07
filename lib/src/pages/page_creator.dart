import 'dart:math';

import 'package:flutter/widgets.dart';

import '../../qlevar_router.dart';
import '../helpers/platform/platform_web.dart'
    if (dart.library.io) '../helpers/platform/platform_io.dart';
import '../routes/qroute_internal.dart';
import 'qpage_internal.dart';

class PageCreator {
  final QRouteInternal route;
  final key = ValueKey<int>(Random().nextInt(1000));
  QRoute get qRoute => route.route;
  final QPage pageType;
  PageCreator(this.route) : pageType = route.route.pageType ?? QPlatformPage();

  QPageInternal create() {
    if (pageType is QPlatformPage) {
      if (!QPlatform.isWeb && QPlatform.isIOS) {
        return _getCupertinoPage(qRoute.name);
      }
      return _getMaterialPage();
    }
    if (pageType is QCupertinoPage) {
      return _getCupertinoPage((pageType as QCupertinoPage).title);
    }
    if (pageType is QCustomPage) {
      return _getCustomPage();
    }
    return _getMaterialPage();
  }

  QMaterialPageInternal _getMaterialPage() => QMaterialPageInternal(
      name: qRoute.name,
      child: build(),
      maintainState: pageType.maintainState,
      fullscreenDialog: pageType.fullscreenDialog,
      restorationId: pageType.restorationId,
      key: key,
      matchKey: route.key);

  QCupertinoPageInternal _getCupertinoPage(String? title) =>
      QCupertinoPageInternal(
          name: qRoute.name,
          child: build(),
          maintainState: pageType.maintainState,
          fullscreenDialog: pageType.fullscreenDialog,
          restorationId: pageType.restorationId,
          title: title,
          key: key,
          matchKey: route.key);

  QCustomPageInternal _getCustomPage() {
    final page = pageType as QCustomPage;
    return QCustomPageInternal(
        name: qRoute.name,
        child: build(),
        maintainState: pageType.maintainState,
        fullscreenDialog: pageType.fullscreenDialog,
        restorationId: pageType.restorationId,
        key: key,
        matchKey: route.key,
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
    if (pageType is QSlidePage) {
      final slide = pageType as QSlidePage;
      return SlideTransition(
          child: child,
          position: CurvedAnimation(
                  parent: animation, curve: slide.curve ?? Curves.easeIn)
              .drive(Tween<Offset>(
                  end: Offset.zero, begin: slide.offset ?? Offset(1, 0))));
    }
    return child;
  }

  Widget build() {
    if (!qRoute.withChildRouter) {
      return qRoute.builder!();
    }
    assert(qRoute.children != null,
        'Can not create a navigator to a route without children. $route');
    final router = QR.createNavigator(
        qRoute.name ?? qRoute.path, qRoute.children!,
        initPaht: qRoute.initRoute);
    return qRoute.builderChild!(router);
  }
}
