import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'helpers.dart';
import 'test_widgets/test_widgets.dart';

void main() {
  group('Nested navigation', () {
    testWidgets('Navigate to child from route with auth', (tester) async {
      var isAuth = false;
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
                  redirectGuardFunc: (s) async => isAuth ? null : '/login'),
            ],
            builderChild: (c) => TestDashboard(c),
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
      isAuth = true;
      delegate.setNewRoutePath('/dashboard/orders');
      await tester.pumpAndSettle();
      expect(find.text('login'), findsNothing);
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Sidebar'), findsOneWidget);
      expect(find.text('Orders'), findsOneWidget);
      // try to go back
      await delegate.popRoute();
      await tester.pumpAndSettle();
      expect(find.text('login'), findsOneWidget);
    });

    testWidgets('Random Nested Navigation', (tester) async {
      await prepareTest(tester);
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

    testWidgets('ReplaceAll child Navigation', (tester) async {
      await prepareTest(tester);
      await tester.pumpAndSettle();
      expect(find.text('login'), findsOneWidget);
      // We need to call it with QR.to first so the dashboard navigator will
      // got created
      await QR.to('/dashboard/child-1');
      await tester.pumpAndSettle();
      expect(find.text('child-1'), findsOneWidget);
      expectedPath('/dashboard/child-1');
      final navi = QR.navigatorOf('/dashboard');

      for (var z = 0; z < 10; z++) {
        final i = Random().nextInt(5) + 1;
        await navi.replaceAll('/child-$i');
        await tester.pumpAndSettle();
        expect(find.text('login'), findsNothing);
        expect(find.text('child-$i'), findsOneWidget);
        expectedPath('/dashboard/child-$i');
      }
    });
  });
}
