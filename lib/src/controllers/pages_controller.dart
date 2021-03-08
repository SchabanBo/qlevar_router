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
    QR.params.updateParams(route.params!);
    MiddlewareController(route).runOnEnter();
    pages.add(PageCreator(route).create());
    if (pages.any((element) => element.matchKey.hasName('Init Page'))) {
      pages.removeWhere((element) => element.matchKey.hasName('Init Page'));
    }
  }

  void removeLast() {
    final route = routes.last;
    MiddlewareController(route).runOnExit();
    QR.removeNavigator(route.name);
    routes.removeLast();
    pages.removeLast();
  }

  void removeIndex(int index) {
    final route = routes[index];
    MiddlewareController(route).runOnExit();
    QR.removeNavigator(route.name);
    routes.removeAt(index);
    pages.removeAt(index);
  }

  void removeAll() {
    for (var i = 0; i < pages.length - 1; i++) {
      removeLast();
    }
  }
}
