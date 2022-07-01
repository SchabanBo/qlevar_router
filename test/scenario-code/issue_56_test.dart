import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers.dart';

void main() {
  testWidgets('Issue 56', (tester) async {
    QR.reset();
    final router = [
      QRoute.withChild(
        name: 'home',
        path: '/home',
        builderChild: (router) {
          return Container(
            child: router,
          );
        },
        initRoute: '/login',
        children: [
          QRoute(
            name: 'home_login',
            path: '/login',
            builder: () {
              return Center(
                child: MaterialButton(
                  child: const Text('Go to vendor login'),
                  onPressed: () {
                    QR.to('/vendor');
                  },
                ),
              );
            },
          ),
        ],
      ),
      QRoute.withChild(
          name: 'vendor',
          path: '/vendor',
          builderChild: (router) {
            return Container(
              child: router,
            );
          },
          initRoute: '/login',
          children: [
            QRoute(
              name: 'vendor_login',
              path: '/login',
              builder: () {
                return Center(
                  child: MaterialButton(
                    onPressed: QR.back,
                    child: const Text('back'),
                  ),
                );
              },
            ),
          ])
    ];
    final delegate = QRouterDelegate(
      router,
      initPath: '/home',
    );
    await tester.pumpWidget(MaterialApp.router(
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: delegate,
    ));
    await tester.pumpAndSettle();
    expectedPath('/home/login');

    await tester.tap(find.text('Go to vendor login'));
    await tester.pumpAndSettle();
    expectedPath('/vendor/login');

    await delegate.setNewRoutePath('/home/login');
    await tester.pumpAndSettle();
    expectedPath('/home/login');
    expect(find.text('Go to vendor login'), findsOneWidget);
  });
}
