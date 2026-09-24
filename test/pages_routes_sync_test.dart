import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'test_widgets/test_widgets.dart';

void main() {
  testWidgets('Switching tabs while a page is still entering keeps pages in sync',
      (tester) async {
    QR.reset();
    final entering = Completer<void>();
    final routes = [
      QRoute.withChild(
        path: '/home',
        name: 'home',
        builderChild: (c) => TestDashboard(c),
        initRoute: '/main',
        children: [
          QRoute(path: '/main', name: 'main', builder: () => const Text('main')),
          QRoute(path: '/cart', name: 'cart', builder: () => const Text('cart')),
        ],
      ),
      QRoute(
        path: '/slow',
        name: 'slow',
        middleware: [QMiddlewareBuilder(onEnterFunc: () => entering.future)],
        builder: () => const Text('slow'),
      ),
    ];
    final delegate = QRouterDelegate(routes, initPath: '/home');
    await tester.pumpWidget(MaterialApp.router(
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: delegate,
    ));
    await tester.pumpAndSettle();

    // '/slow' is in the root routes while its onEnter runs, but has no page yet.
    unawaited(QR.to('/slow'));
    await tester.pump();

    // Each tab switch brings 'home' to the top of the root stack. The second
    // one used to read pages[1] of a one-page list: RangeError.
    await QR.toName('cart');
    await QR.toName('main');

    entering.complete();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    // 'home' was brought above '/slow'; the late page still lands in the stack.
    expect(find.text('main'), findsOneWidget);
    expect(find.text('slow'), findsNothing);
    expect(find.text('slow', skipOffstage: false), findsOneWidget);
  });
}
