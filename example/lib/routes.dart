import 'package:qlevar_router/qlevar_router.dart';

import 'helpers/database.dart';
import 'helpers/text_page.dart';
import 'screens/home_page.dart';
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
      ];
}
