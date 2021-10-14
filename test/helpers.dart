import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'test_widgets/test_widgets.dart';

void expectedPath(String path) => expect(QR.currentPath, path);
void expectedHistoryLength(int length) => expect(QR.history.length, length);
void printCurrentHistory() => print(QR.history.entries.map((e) => e.path));

Future<void> prepareTest(WidgetTester tester) async {
  QR.reset();
  final routes = [
    QRoute(
        path: '/login',
        builder: () => Scaffold(
                body: Container(
              child: Text('login'),
            ))),
    QRoute.withChild(
        path: '/dashboard',
        builderChild: (c) => TestDashboard(c),
        initRoute: '/child-1',
        children: [
          QRoute(path: '/child-1', builder: () => Text('child-1')),
          QRoute(path: '/child-2', builder: () => Text('child-2')),
          QRoute(path: '/child-3', builder: () => Text('child-3')),
          QRoute(path: '/child-4', builder: () => Text('child-4')),
          QRoute(path: '/child-5', builder: () => Text('child-5')),
          QRoute(path: '/child-6', builder: () => Text('child-6')),
        ])
  ];
  final delegate = QRouterDelegate(routes, initPath: '/login');
  await tester.pumpWidget(MaterialApp.router(
    routeInformationParser: QRouteInformationParser(),
    routerDelegate: delegate,
  ));
}
