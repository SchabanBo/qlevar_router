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

  Future<void> add(QRouteInternal route) async {
    routes.add(route);
    await MiddlewareController(route).runOnEnter();
    await _notifyObserverOnNavigation(route);
    pages.add(await PageCreator(route).create());
    if (pages.any((element) => element.matchKey.hasName(_initPageKey))) {
      pages.removeWhere((element) => element.matchKey.hasName(_initPageKey));
    }
  }

  bool exist(QRouteInternal route) =>
      routes.any((element) => element.key.isSame(route.key));

  Future<PopResult> removeAll() async {
    for (var i = 0; i < routes.length; i++) {
      final popResult = await removeLast(allowEmptyPages: true);
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

    QR.removeNavigator(route.name); // remove navigator if exist
    QR.history.remove(route); // remove history for this route
    await _notifyObserverOnPop(route);
    if (routes.isNotEmpty) routes.removeAt(index); // remove from the routes
    if (pages.isNotEmpty) pages.removeAt(index); // remove from the pages
    _checkEmptyStack();
    return true;
  }

  Future<PopResult> removeLast(
      {dynamic result, bool allowEmptyPages = false}) async {
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
    QR.history.removeLast(); // remove history for this route
    if (QR.history.hasLast && QR.history.current.path == route.activePath) {
      QR.history.removeLast();
    }
    await _notifyObserverOnPop(route);
    if (routes.isNotEmpty) routes.removeLast(); // remove from the routes
    if (pages.isNotEmpty) pages.removeLast(); // remove from the pages
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
