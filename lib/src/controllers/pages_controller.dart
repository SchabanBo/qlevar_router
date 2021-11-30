import '../../qlevar_router.dart';
import '../pages/page_creator.dart';
import '../pages/qpage_internal.dart';
import '../routes/qroute_internal.dart';
import 'middleware_controller.dart';

class PagesController {
  final routes = <QRouteInternal>[];
  final pages = <QPageInternal>[
    QMaterialPageInternal(
        child: QR.settings.iniPage, matchKey: QKey('Init Page'))
  ];

  bool exist(QRouteInternal route) =>
      routes.any((element) => element.key.isSame(route.key));

  Future<void> add(QRouteInternal route) async {
    routes.add(route);
    await MiddlewareController(route).runOnEnter();
    await _notifyObserverOnNavigation(route);
    pages.add(PageCreator(route).create());
    if (pages.any((element) => element.matchKey.hasName('Init Page'))) {
      pages.removeWhere((element) => element.matchKey.hasName('Init Page'));
    }
  }

  Future<PopResult> removeLast({bool allowEmptyPages = false}) async {
    if (routes.isEmpty) {
      return PopResult.NotPoped;
    }
    final route = routes.last; // find the page
    final middleware = MiddlewareController(route);
    if (!await middleware.runCanPop()) return PopResult.NotAllowedToPop;

    if (allowEmptyPages == false && routes.length == 1) {
      return PopResult.NotPoped;
    }

    await middleware.runOnExit(); // run on exit
    if (QR.removeNavigator(route.name)) {
      // if this route has navigator then remove it to remove this route too.
      // and remove all histories to this route
      QR.history.removeWithNavigator(route.name);
    }
    QR.history.removeLast(); // remove history for this route
    if (QR.history.hasLast && QR.history.current.path == route.fullPath) {
      QR.history.removeLast();
    }
    await _notifyObserverOnPop(route);
    routes.removeLast(); // remove from the routes
    pages.removeLast(); // reomve from the pages
    return PopResult.Poped;
  }

  Future<bool> removeIndex(int index) async {
    final route = routes[index]; // find the page

    final middleware = MiddlewareController(route);
    if (!await middleware.runCanPop()) return false;
    await middleware.runOnExit(); // run on exit

    QR.removeNavigator(route.name); // remove navigator if exist
    QR.history.remove(route); // remove history for this route
    await _notifyObserverOnPop(route);
    routes.removeAt(index); // remove from the routes
    pages.removeAt(index); // reomve from the pages
    return true;
  }

  Future<bool> removeFullPathSame(QRouteInternal route) async {
    for(var i = routes.length-1; i >= 0; i--){
      var oldRoute = routes[i];
      if (oldRoute.activePath == route.activePath) {
        routes.removeAt(i);
        pages.removeAt(i);
        return true;
      }
    }
    return true;
  }

  Future<bool> removeAllKeySame(QRouteInternal route) async {
    for(var i = routes.length-1; i >= 0; i--){
      var oldRoute = routes[i];
      if (oldRoute.key == route.key) {
        routes.removeAt(i);
        pages.removeAt(i);
      }
    }
    return true;
  }

  Future<PopResult> removeAll() async {
    for (var i = 0; i < pages.length; i++) {
      final result = await removeLast(allowEmptyPages: true);
      if (result != PopResult.Poped) return result;
      i--;
    }
    return PopResult.Poped;
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
