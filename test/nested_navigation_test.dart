import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

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
