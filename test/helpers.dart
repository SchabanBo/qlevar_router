import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'test_widgets/test_widgets.dart';

void expectedPath(String path) => expect(QR.currentPath, path);
void expectedHistoryLength(int length) => expect(QR.history.length, length);
// ignore: avoid_print
void printCurrentHistory() => print(QR.history.entries.map((e) => e.path));

Future<void> prepareTest(WidgetTester tester) async {
  QR.reset();
  final routes = [
    QRoute(
        path: '/login',
        builder: () => const Scaffold(
              body: Text('login'),
            )),
    QRoute.withChild(
        path: '/dashboard',
        builderChild: (c) => TestDashboard(c),
        initRoute: '/child-1',
        children: [
          QRoute(path: '/child-1', builder: () => const Text('child-1')),
          QRoute(path: '/child-2', builder: () => const Text('child-2')),
          QRoute(path: '/child-3', builder: () => const Text('child-3')),
          QRoute(path: '/child-4', builder: () => const Text('child-4')),
          QRoute(path: '/child-5', builder: () => const Text('child-5')),
          QRoute(path: '/child-6', builder: () => const Text('child-6')),
        ])
  ];
  final delegate = QRouterDelegate(routes, initPath: '/login');
  await tester.pumpWidget(MaterialApp.router(
    routeInformationParser: const QRouteInformationParser(),
    routerDelegate: delegate,
  ));
}
