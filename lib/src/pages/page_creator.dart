import 'package:flutter/widgets.dart';

import '../../qlevar_router.dart';
import '../helpers/platform/platform_web.dart'
    if (dart.library.io) '../helpers/platform/platform_io.dart';
import '../routes/qroute_internal.dart';
import 'qpage_internal.dart';

abstract class _PageConverter {
  _PageConverter(this.pageName, this.matchKey, this.pageType);

  late final key = ValueKey<int>(hashCode);
  final QKey matchKey;
  final String? pageName;
  final QPage pageType;

  QPageInternal createWithChild(Widget child) {
    if (pageType is QPlatformPage) {
      if (!QPlatform.isWeb && QPlatform.isIOS) {
        return _getCupertinoPage(pageName, child);
      }
      return _getMaterialPage(child);
    }
    if (pageType is QCupertinoPage) {
      return _getCupertinoPage((pageType as QCupertinoPage).title, child);
    }
    if (pageType is QCustomPage) {
      return _getCustomPage(child);
    }
    return _getMaterialPage(child);
  }

  QMaterialPageInternal _getMaterialPage(Widget child) => QMaterialPageInternal(
        name: pageName,
        child: child,
        maintainState: pageType.maintainState,
        fullScreenDialog: pageType.fullScreenDialog,
        restorationId: pageType.restorationId,
        key: key,
        addMaterialWidget: pageType is QMaterialPage
            ? (pageType as QMaterialPage).addMaterialWidget
            : true,
        matchKey: matchKey,
      );

  QCupertinoPageInternal _getCupertinoPage(String? title, Widget child) =>
      QCupertinoPageInternal(
        name: pageName,
        child: child,
        maintainState: pageType.maintainState,
        fullScreenDialog: pageType.fullScreenDialog,
        restorationId: pageType.restorationId,
        title: title,
        key: key,
        matchKey: matchKey,
      );

  QCustomPageInternal _getCustomPage(Widget child) {
    final page = pageType as QCustomPage;
    return QCustomPageInternal(
      name: pageName,
      child: child,
      maintainState: pageType.maintainState,
      fullScreenDialog: pageType.fullScreenDialog,
      restorationId: pageType.restorationId,
      key: key,
      matchKey: matchKey,
      barrierColor: page.barrierColor,
      barrierDismissible: page.barrierDismissible,
      barrierLabel: page.barrierLabel,
      opaque: page.opaque,
      reverseTransitionDuration: page.reverseTransitionDurationMilliseconds,
      transitionDuration: page.transitionDurationMilliseconds,
      transitionsBuilder: page.transitionsBuilder ?? _buildTransaction,
    );
  }

  Widget _buildTransaction(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      _getTransaction(pageType as QCustomPage, child, animation);

  Widget _getTransaction(
      QCustomPage type, Widget child, Animation<double> animation) {
    switch (type.runtimeType) {
      case QSlidePage:
        final slide = type as QSlidePage;
        child = SlideTransition(
            position: CurvedAnimation(
                    parent: animation, curve: slide.curve ?? Curves.easeIn)
                .drive(Tween<Offset>(
                    end: Offset.zero,
                    begin: slide.offset ?? const Offset(1, 0))),
            child: child);
        break;
      case QFadePage:
        child = FadeTransition(
          opacity: CurvedAnimation(
                  parent: animation,
                  curve: (type as QFadePage).curve ?? Curves.easeIn)
              .drive(Tween<double>(end: 1, begin: 0)),
          child: child,
        );
        break;
    }

    return type.withType == null
        ? child
        : _getTransaction(type.withType!, child, animation);
  }
}

class PageCreator extends _PageConverter {
  PageCreator(this.route)
      : super(route.route.name, route.key,
            route.route.pageType ?? QR.settings.pagesType);

  final QRouteInternal route;

  QRoute get qRoute => route.route;

  QPageInternal create() => super.createWithChild(build());

  Widget build() {
    if (qRoute.withChildRouter) {
      assert(qRoute.children != null,
          'Can not create a navigator to a route without children. $route');
      final router = QR.createNavigator(
        qRoute.name ?? qRoute.path,
        cRoutes: route.children,
        initPath: qRoute.initRoute ?? '/',
        initRoute: route.child,
      );
      if (qRoute.initRoute != null && route.child == null) {
        route.activePath = '${route.activePath}${qRoute.initRoute}';
      }
      return qRoute.builderChild!(router);
    }

    if (qRoute.isDeclarative) {
      return qRoute.declarativeBuilder!(route.key);
    }

    return qRoute.builder!();
  }
}

class DeclarativePageCreator extends _PageConverter {
  DeclarativePageCreator(String? pageName, QKey key, QPage? type)
      : super(pageName, key, type ?? QR.settings.pagesType);
}
