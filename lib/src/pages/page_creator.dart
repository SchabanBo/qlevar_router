import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../qlevar_router.dart';
import '../routes/qroute_internal.dart';
import 'qpage_internal.dart';

abstract class _PageConverter {
  _PageConverter(this.pageName, this.matchKey, this.pageType, {LocalKey? key})
      : key = key ?? UniqueKey();

  final LocalKey key;
  final QKey matchKey;
  final String? pageName;
  final QPage pageType;

  static bool get _isApple =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  QPageInternal createWithChild(Widget child) {
    if (pageType is QPlatformPage) {
      if (_isApple) {
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
    if (pageType is QModalBottomSheetPage) {
      return _getModalBottomSheetPage(child);
    }
    return _getMaterialPage(child);
  }

  String? _getRestorationId() {
    var id = pageType.restorationId;
    if (id == null && QR.settings.autoRestoration) {
      id = 'page:${matchKey.name}';
    }
    return id;
  }

  QMaterialPageInternal _getMaterialPage(Widget child) => QMaterialPageInternal(
        name: pageName,
        child: child,
        maintainState: pageType.maintainState,
        fullScreenDialog: pageType.fullScreenDialog,
        restorationId: _getRestorationId(),
        key: key,
        addMaterialWidget: pageType is QMaterialPage
            ? (pageType as QMaterialPage).addMaterialWidget
            : true,
        matchKey: matchKey,
        canPop: pageType.canPop,
        onPopInvoked: pageType.onPopInvoked,
      );

  QCupertinoPageInternal _getCupertinoPage(String? title, Widget child) =>
      QCupertinoPageInternal(
        name: pageName,
        child: child,
        maintainState: pageType.maintainState,
        fullScreenDialog: pageType.fullScreenDialog,
        restorationId: _getRestorationId(),
        title: title,
        key: key,
        matchKey: matchKey,
        canPop: pageType.canPop,
        onPopInvoked: pageType.onPopInvoked,
      );

  QCustomPageInternal _getCustomPage(Widget child) {
    final page = pageType as QCustomPage;
    return QCustomPageInternal(
      name: pageName,
      child: child,
      maintainState: pageType.maintainState,
      fullScreenDialog: pageType.fullScreenDialog,
      restorationId: _getRestorationId(),
      key: key,
      matchKey: matchKey,
      canPop: pageType.canPop,
      onPopInvoked: pageType.onPopInvoked,
      barrierColor: page.barrierColor,
      barrierDismissible: page.barrierDismissible,
      barrierLabel: page.barrierLabel,
      opaque: page.opaque,
      transitionDuration: page.transitionDuration,
      reverseTransitionDuration: page.reverseTransitionDuration,
      transitionsBuilder: page.transitionsBuilder ?? _buildTransaction,
    );
  }

  QModalBottomSheetPageInternal _getModalBottomSheetPage(Widget child) {
    final page = pageType as QModalBottomSheetPage;
    return QModalBottomSheetPageInternal(
      name: pageName,
      child: child,
      restorationId: _getRestorationId(),
      key: key,
      matchKey: matchKey,
      canPop: pageType.canPop,
      onPopInvoked: pageType.onPopInvoked,
      isScrollControlled: page.isScrollControlled,
      isDismissible: page.isDismissible,
      enableDrag: page.enableDrag,
      showDragHandle: page.showDragHandle,
      useSafeArea: page.useSafeArea,
      barrierOnTapHint: page.barrierOnTapHint,
      barrierLabel: page.barrierLabel,
      anchorPoint: page.anchorPoint,
    );
  }

  Widget _buildTransaction(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      _getTransaction(pageType as QCustomPage, child, animation);

  Widget _getTransaction(
      QCustomPage type, Widget child, Animation<double> animation) {
    if (type is QSlidePage) {
      child = SlideTransition(
        position: CurvedAnimation(
                parent: animation, curve: type.curve ?? Curves.easeIn)
            .drive(Tween<Offset>(
                end: Offset.zero, begin: type.offset ?? const Offset(1, 0))),
        child: child,
      );
    } else if (type is QFadePage) {
      child = FadeTransition(
        opacity: CurvedAnimation(
                parent: animation, curve: type.curve ?? Curves.easeIn)
            .drive(Tween<double>(end: 1, begin: 0)),
        child: child,
      );
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

  Future<QPageInternal> create() async => super.createWithChild(await build());

  Future<Widget> build() async {
    if (qRoute.withChildRouter) {
      assert(qRoute.children != null,
          'Can not create a navigator to a route without children. $route');
      final router = await QR.createNavigator(
        qRoute.name ?? qRoute.path,
        cRoutes: route.children,
        initPath: qRoute.initRoute ?? '/',
        initRoute: route.child,
        observers: qRoute.observers,
        restorationId: qRoute.restorationId,
        isTemporary: false,
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
  /// Give the [pageKey] of the old page to update it instead of pushing a new one
  DeclarativePageCreator(String? pageName, QKey key, QPage? type,
      {LocalKey? pageKey})
      : super(pageName, key, type ?? QR.settings.pagesType, key: pageKey);
}
