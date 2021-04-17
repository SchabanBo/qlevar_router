import 'package:flutter/cupertino.dart';

import '../../qlevar_router.dart';
import '../pages/page_creator.dart';
import '../pages/qpage_internal.dart';
import '../routes/qroute_internal.dart';
import '../types/qroute_key.dart';
import 'middleware_controller.dart';

class PagesController {
  final routes = <QRouteInternal>[];
  final pages = <QPageInternal>[
    QMaterialPageInternal(child: Container(), matchKey: QKey('Init Page'))
  ];

  bool exist(QRouteInternal route) =>
      routes.any((element) => element.key.isSame(route.key));

  void add(QRouteInternal route) {
    routes.add(route);
    MiddlewareController(route).runOnEnter();
    pages.add(PageCreator(route).create());
    if (pages.any((element) => element.matchKey.hasName('Init Page'))) {
      pages.removeWhere((element) => element.matchKey.hasName('Init Page'));
    }
  }

  bool removeLast() {
    final route = routes.last; // find the page
    final middleware = MiddlewareController(route);
    if (!middleware.runCanPop()) {
      return false;
    }
    middleware.runOnExit(); // run on exit
    if (QR.removeNavigator(route.name)) {
      // if this route has navigator then remove it to remove this route too.
      // and remove all histories to this route
      QR.history.removeWithNavigator(route.name);
    }
    QR.history.removeLast(); // remove history for this route
    routes.removeLast(); // remove from the routes
    pages.removeLast(); // reomve from the pages
    return true;
  }

  void removeIndex(int index) {
    final route = routes[index]; // find the page
    MiddlewareController(route).runOnExit(); // run on exit
    QR.removeNavigator(route.name); // remove navigator if exist
    QR.history.remove(route); // remove history for this route
    routes.removeAt(index); // remove from the routes
    pages.removeAt(index); // reomve from the pages
  }

  void removeAll() {
    for (var i = 0; i < pages.length; i++) {
      removeLast();
      i--;
    }
  }
}
