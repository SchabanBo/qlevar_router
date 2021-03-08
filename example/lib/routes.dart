import 'package:qlevar_router/qlevar_router.dart';

import 'helpers/database.dart';
import 'helpers/text_page.dart';
import 'screens/home_page.dart';
import 'screens/nested_route.dart';
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
        QRoute(
            path: '/:id',
            builder: () => TextPage('the id is ${QR.params['id']}')),
        QRoute(path: '/params', builder: () => TextPage(
            // ignore: lines_longer_than_80_chars
            'params are: test is${QR.params['test']} and go is ${QR.params['go']}')),
        QRoute.withChild(
            path: '/nested',
            builderChild: (r) => NestedRoutePage(r),
            initRoute: '/child',
            children: [
              QRoute(path: '/child', builder: () => NestedChild('child')),
              QRoute(
                  path: '/child-1',
                  builder: () => NestedChild('child 1'),
                  pageType: QSlidePage()),
              QRoute(path: '/child-2', builder: () => NestedChild('child 2')),
              QRoute(path: '/child-3', builder: () => NestedChild('child 3')),
            ]),
      ];
}
