import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'helpers/text_page.dart';
import 'routes/parent.dart';
import 'screens/add_remove_routes.dart';
import 'screens/declarative_page.dart';
import 'screens/home_page.dart';
import 'screens/nested_route.dart';
import 'screens/overlays_page.dart';

class AppRoutes {
  static const nested = 'Nested';
  static const nestedChild = 'Nested Child';
  static const nestedChild1 = 'Nested Child 1';
  static const nestedChild2 = 'Nested Child 2';
  static const nestedChild3 = 'Nested Child 3';

  ///
  static const app = 'App';
  static const home = 'Home';
  static const settings = 'Settings';
  static const login = 'Login';

  List<QRoute> routes() => [
        QRoute(path: '/', builder: () => HomePage()),
        QRoute(path: '/overlays', builder: () => OverlaysPage()),
        QRoute.declarative(
            path: '/declarative',
            declarativeBuilder: (k) => DeclarativePage(k)),
        ParentRoutes().route(),
        QRoute(
            path: '/:id',
            pageType: QFadePage(),
            builder: () => TextPage('the id is ${QR.params['id']}')),
        QRoute(
            path: '/params',
            builder: () => TextPage(
                  // ignore: lines_longer_than_80_chars
                  'params are: test is${QR.params['test']} and go is ${QR.params['go']}',
                  extra: [
                    TextButton(
                        onPressed: () => QR.to(
                            "/params?test=${Random().nextInt(1000)}&go=${Random().nextInt(1000)}"),
                        child: Text('New param')),
                    TextButton(
                        onPressed: () =>
                            QR.to(QR.currentPath, ignoreSamePath: false),
                        child: Text('Refresh'))
                  ],
                )),
        QRoute.withChild(
            path: '/add-remove-routes',
            builderChild: (child) => AddRemoveRoutes(child),
            initRoute: '/child',
            children: [
              QRoute(path: '/child', builder: () => AddRemoveChild('Hi child')),
              QRoute(
                  path: '/child-1',
                  builder: () => AddRemoveChild('Hi child 1')),
              QRoute(
                  path: '/child-2',
                  builder: () => AddRemoveChild('Hi child 2')),
              QRoute(
                  path: '/child-3',
                  builder: () => AddRemoveChild('Hi child 3')),
            ]),
        QRoute.withChild(
            name: nested,
            path: '/nested',
            builderChild: (r) => NestedRoutePage(r),
            initRoute: '/child',
            children: [
              QRoute(
                  name: nestedChild,
                  path: '/child',
                  builder: () => NestedChild('child')),
              QRoute(
                  name: nestedChild1,
                  path: '/child-1',
                  builder: () => NestedChild('child 1'),
                  pageType: QSlidePage()),
              QRoute(
                  name: nestedChild2,
                  path: '/child-2',
                  builder: () => NestedChild('child 2')),
              QRoute(
                  name: nestedChild3,
                  path: '/child-3',
                  builder: () => NestedChild('child 3')),
            ]),
      ];
}
