import '../../qlevar_router.dart';
import '../pages/page_creator.dart';
import '../pages/qpage_internal.dart';
import '../routes/qroute_internal.dart';
import 'middleware_controller.dart';

class PagesController {
  static const String _initPageKey = 'Init Page';
  final routes = <QRouteInternal>[];

  late final pages = <QPageInternal>[_initPage];

  QMaterialPageInternal get _initPage => QMaterialPageInternal(
      child: QR.settings.initPage, matchKey: QKey(_initPageKey));

  // Routes whose [add] is still awaiting middleware or page creation. They are
  // in [routes] but have no page in [pages] yet, so a route index is not a
  // page index: translate with [_pageIndex] (RangeError in _bringPageToTop).
  final _entering = <QRouteInternal>{};

  int _pageIndex(int routeIndex) =>
      routeIndex - routes.take(routeIndex).where(_entering.contains).length;

  Future<void> add(QRouteInternal route) async {
    routes.add(route);
    _entering.add(route);
    try {
      await MiddlewareController(route).runOnEnter();
      await _notifyObserverOnNavigation(route);
      final page = await PageCreator(route).create();
      final index = routes.indexOf(route);
      if (index == -1) return; // popped while its page was being created
      pages.insert(_pageIndex(index), page);
    } catch (_) {
      routes.remove(route);
      rethrow;
    } finally {
      _entering.remove(route);
    }
    if (pages.any((element) => element.matchKey.hasName(_initPageKey))) {
      pages.removeWhere((element) => element.matchKey.hasName(_initPageKey));
    }
  }

  /// Moves [route] and its page (if already created) to the top.
  void moveToTop(QRouteInternal route) {
    final page = _entering.contains(route)
        ? null
        : pages.removeAt(_pageIndex(routes.indexOf(route)));
    routes.remove(route);
    routes.add(route);
    if (page != null) pages.add(page);
  }

  void _remove(QRouteInternal route) {
    final index = routes.indexOf(route);
    if (index == -1) return;
    final pageIndex = _pageIndex(index);
    if (!_entering.contains(route) && pageIndex < pages.length) {
      pages.removeAt(pageIndex);
    }
    routes.removeAt(index);
  }

  bool exist(QRouteInternal route) =>
      routes.any((element) => element.key.isSame(route.key));

  /// [updateHistory] is false when the navigator is being disposed: the
  /// history entries of a navigator are removed by its name afterwards, and
  /// popping the newest entries here removed other navigators' entries.
  Future<PopResult> removeAll({bool updateHistory = true}) async {
    for (var i = 0; i < routes.length; i++) {
      final popResult =
          await removeLast(allowEmptyPages: true, updateHistory: updateHistory);
      if (popResult != PopResult.Popped) {
        return popResult;
      }
      i--;
    }
    return PopResult.Popped;
  }

  Future<bool> removeIndex(int index) async {
    final route = routes[index]; // find the page

    final middleware = MiddlewareController(route);
    if (!await middleware.runCanPop()) return false;
    await middleware.runOnExit(); // run on exit
    middleware.scheduleOnExited(); // schedule on exited

    await QR.removeNavigator(route.name); // remove navigator if exist
    QR.history.remove(route); // remove history for this route
    await _notifyObserverOnPop(route);
    _remove(route);
    route.complete(null); // release anyone waiting for a result
    _checkEmptyStack();
    return true;
  }

  Future<PopResult> removeLast({
    dynamic result,
    bool allowEmptyPages = false,
    bool updateHistory = true,
  }) async {
    if (routes.isEmpty) {
      return PopResult.NotPopped;
    }
    final route = routes.last; // find the page
    final middleware = MiddlewareController(route);
    if (!await middleware.runCanPop()) return PopResult.NotAllowedToPop;

    if (!allowEmptyPages && routes.length == 1) {
      return PopResult.NotPopped;
    }

    await middleware.runOnExit(); // run on exit
    middleware.scheduleOnExited(); // schedule on exited
    await QR.removeNavigator(route.name); // remove navigator if exist
    if (updateHistory) {
      QR.history.removeLast(); // remove history for this route
      if (QR.history.hasLast && QR.history.current.path == route.activePath) {
        QR.history.removeLast();
      }
    }
    await _notifyObserverOnPop(route);
    _remove(route);
    route.complete(result);
    _checkEmptyStack();
    return PopResult.Popped;
  }

  /// show init page when a middleware has something to do,
  /// so no red screen will be showed
  void _checkEmptyStack() {
    if (pages.isEmpty) {
      pages.add(_initPage);
    }
  }

  Future _notifyObserverOnNavigation(QRouteInternal route) async {
    for (var onNavigate in QR.observer.onNavigate) {
      await onNavigate(route.activePath!, route.route);
    }
  }

  Future _notifyObserverOnPop(QRouteInternal route) async {
    for (var onPop in QR.observer.onPop) {
      await onPop(route.activePath!, route.route);
    }
  }
}
