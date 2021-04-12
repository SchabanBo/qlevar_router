import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'helpers.dart';

void main() {
  group('Nested navigation', () {
    testWidgets('Navigate to child from route with auth', (tester) async {
      var isAuthed = false;
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
            middleware: [
              QMiddlewareBuilder(
                  redirectGuardFunc: (s) async => isAuthed ? null : '/login'),
            ],
            builderChild: (c) => _Dashboard(c),
            initRoute: '/orders',
            children: [QRoute(path: '/orders', builder: () => Text('Orders'))])
      ];
      final delegate = QRouterDelegate(routes, initPath: '/dashboard');
      await tester.pumpWidget(MaterialApp.router(
        routeInformationParser: QRouteInformationParser(),
        routerDelegate: delegate,
      ));
      await tester.pumpAndSettle();
      expect(find.text('login'), findsOneWidget);
      delegate.setNewRoutePath('/dashboard/orders');
      await tester.pumpAndSettle();
      expect(find.text('login'), findsOneWidget);
      isAuthed = true;
      delegate.setNewRoutePath('/dashboard/orders');
      await tester.pumpAndSettle();
      expect(find.text('login'), findsNothing);
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Sidebar'), findsOneWidget);
      expect(find.text('Orders'), findsOneWidget);
    });

    testWidgets('Random Nested Navigation', (tester) async {
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
            builderChild: (c) => _Dashboard(c),
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
      await tester.pumpAndSettle();
      expect(find.text('login'), findsOneWidget);
      // Navigate to all children two times
      for (var t = 0; t < 2; t++) {
        for (var i = 1; i < 7; i++) {
          await QR.to('/dashboard/child-$i');
          await tester.pumpAndSettle();
          expect(find.text('login'), findsNothing);
          expect(find.text('child-$i'), findsOneWidget);
          expectedPath('/dashboard/child-$i');
        }
      }

      // Navigate to children randomly 10 times
      for (var z = 0; z < 10; z++) {
        final i = Random().nextInt(5) + 1;
        await QR.to('/dashboard/child-$i');
        await tester.pumpAndSettle();
        expect(find.text('login'), findsNothing);
        expect(find.text('child-$i'), findsOneWidget);
        expectedPath('/dashboard/child-$i');
      }
    });
  });
}

class _Dashboard extends StatelessWidget {
  final QRouter router;
  _Dashboard(this.router);
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
          centerTitle: true,
        ),
        body: Row(
          children: [
            Flexible(
                child: Container(
              child: Text('Sidebar'),
            )),
            Expanded(flex: 4, child: router)
          ],
        ),
      );
}
