import 'dart:async';

import 'package:qlevar_router/qlevar_router.dart';

import 'helpers/database.dart';
import 'helpers/text_page.dart';
import 'screens/add_remove_routes.dart';
import 'screens/declarative_page.dart';
import 'screens/home_page.dart';
import 'screens/nested_route.dart';
import 'screens/overlays_page.dart';
import 'screens/parent_page.dart';

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
        QRoute(
            path: '/parent',
            builder: () {
              print('-- Build Parent page --');
              return ParentPage();
            },
            middleware: [
              QMiddlewareBuilder(
                  onEnterFunc: () => print('-- Enter Parent page --'),
                  onExitFunc: () => print('-- Exit Parent page --'),
                  onMatchFunc: () => print('-- Parent page Matched --'))
            ],
            children: [
              QRoute(path: '/child', builder: () => TextPage('Hi child')),
              QRoute(path: '/child-1', builder: () => TextPage('Hi child 1')),
              QRoute(path: '/child-2', builder: () => TextPage('Hi child 2')),
              QRoute(path: '/child-3', builder: () => TextPage('Hi child 3')),
              QRoute(
                  path: '/child-4',
                  middleware: [
                    QMiddlewareBuilder(
                        redirectGuardFunc: (s) => Future.delayed(
                            Duration(milliseconds: 100),
                            () => Database.canChildNavigate
                                ? null
                                : '/parent/child-2'))
                  ],
                  builder: () => TextPage('Hi child 4')),
            ]),
        QRoute(
            path: '/:id',
            builder: () => TextPage('the id is ${QR.params['id']}')),
        QRoute(path: '/params', builder: () => TextPage(
            // ignore: lines_longer_than_80_chars
            'params are: test is${QR.params['test']} and go is ${QR.params['go']}')),
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
