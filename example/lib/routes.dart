import 'package:example/screens/nested_route.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'helpers/database.dart';
import 'helpers/text_page.dart';
import 'screens/home_page.dart';
import 'screens/order_page.dart';
import 'screens/parent_page.dart';

class AppRoutes {
  List<QRoute> routes() => [
        QRoute(path: '/', builder: () => HomePage()),
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
                        redirectGuardFunc: () => Future.delayed(
                            Duration(milliseconds: 100),
                            () => Database.canChildNavigate
                                ? null
                                : '/parent/child-2'))
                  ],
                  builder: () => TextPage('Hi child 4')),
            ]),
        QRoute(path: '/:id', builder: () => TextPage('Hi ${QR.params['id']}')),
        QRoute(
            path: '/params',
            builder: () => TextPage(
                'Hi test is${QR.params['test']} and go is ${QR.params['go']}')),
        QRoute.withChild(
            path: '/nested',
            builderChild: (r) => NestedRoutePage(r),
            initRoute: '/child',
            children: [
              QRoute(
                  path: '/child',
                  builder: () => Center(child: Text('Hi nesated child'))),
              QRoute(
                  path: '/child-1',
                  builder: () => Center(child: Text('Hi nesated child 1'))),
              QRoute(
                  path: '/child-2',
                  builder: () => Center(child: Text('Hi nesated child 2'))),
              QRoute(
                  path: '/child-3',
                  builder: () => Center(child: Text('Hi nesated child 3'))),
            ]),
      ];
}
