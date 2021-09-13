import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'helpers.dart';
import 'test_widgets/test_widgets.dart';

void main() {
  group('Middlewares', () {
    var isAuthed = false;
    var counter = 0;
    final routes = [
      QRoute(path: '/', builder: () => Container()),
      QRoute.withChild(
          path: '/nested',
          builderChild: (r) => Scaffold(appBar: AppBar(), body: r),
          initRoute: '/child',
          middleware: [
            QMiddlewareBuilder(redirectGuardFunc: (s) async {
              print('From redirect guard: $s');
              return await Future.delayed(
                  Duration(milliseconds: 500), () => isAuthed ? null : '/two');
            }),
            QMiddlewareBuilder(
              onEnterFunc: () async => counter++,
              onExitFunc: () async => counter++,
              onMatchFunc: () async => counter++,
            )
          ],
          children: [
            QRoute(path: '/child', builder: () => Text('child')),
            QRoute(path: '/child-1', builder: () => Text('child 1')),
            QRoute(path: '/child-2', builder: () => Text('child 2')),
            QRoute(path: '/child-3', builder: () => Text('child 3')),
          ]),
      QRoute(
          path: '/two',
          middleware: [
            QMiddlewareBuilder(
              onEnterFunc: () async => counter++,
              onExitFunc: () async => counter++,
              onMatchFunc: () async => counter++,
            )
          ],
          builder: () => Scaffold(body: WidgetTwo())),
      QRoute(path: '/three', builder: () => Scaffold(body: WidgetThree())),
    ];
    test('Redirect / onEnter / onMatch / onExite', () async {
      QR.reset();
      final _ = QRouterDelegate(routes);
      await QR.to('/nested');
      expectedPath('/two');
      isAuthed = true;
      expect(counter, 3); // Nested onMatch + Two onMatch + Two onEnter
      await QR.to(
          '/nested'); // Here to() is used then the Two onExit will not be called
      expect(counter, 5); // Nested onMatch + Nested onEnter
      expectedPath('/nested/child');
      await QR.navigator.replaceAll('/three');
      expect(counter, 7); // Nested onExite + Two onExite
    });

    test('Redirectguard has the right path and param', () async {
      QR.reset();
      var pathFromGuard = '';
      var paramFromGuard = '';
      final _ = QRouterDelegate([
        QRoute(
            path: '/:doaminId/dashboard',
            builder: () => Container(),
            middleware: [
              QMiddlewareBuilder(redirectGuardFunc: (s) async {
                pathFromGuard = s;
                print(s);
                paramFromGuard = QR.params['doaminId'].toString();
                return null;
              })
            ])
      ], initPath: '/domain1/dashboard');
      await _.setInitialRoutePath('/');
      expect(pathFromGuard, '/domain1/dashboard');
      expect(paramFromGuard, 'domain1');

      for (var i = 0; i < 5; i++) {
        await QR.to('/dd$i/dashboard');
        expect(pathFromGuard, '/dd$i/dashboard');
        expect(paramFromGuard, 'dd$i');
      }
    });

    testWidgets('Can Pop with dialog', (widgetTester) async {
      QR.reset();
      final routes = [
        QRoute(
            path: '/',
            builder: () => Scaffold(appBar: AppBar(), body: WidgetOne())),
        QRoute(path: '/two', builder: () => WidgetTwo(), middleware: [
          QMiddlewareBuilder(canPopFunc: () async {
            final result = await QR.show<bool>(QDialog(
                widget: (pop) => AlertDialog(
                      title: Text('Do you want to go back?'),
                      actions: [
                        TextButton(
                            onPressed: () => pop(true), child: Text('Yes')),
                        TextButton(
                            onPressed: () => pop(false), child: Text('No'))
                      ],
                    )));

            return result ?? false;
          })
        ])
      ];
      final delegate = QRouterDelegate(routes);
      await widgetTester.pumpWidget(MaterialApp.router(
          routeInformationParser: const QRouteInformationParser(),
          routerDelegate: delegate));
      await widgetTester.pumpAndSettle();
      expectedPath('/');
      expect(find.byType(WidgetOne), findsOneWidget);
      await QR.to('/two');
      await widgetTester.pumpAndSettle();
      expectedPath('/two');
      expect(find.byType(WidgetTwo), findsOneWidget);
      var firstDialogDone = false;
      delegate.popRoute().whenComplete(() {
        firstDialogDone = true;
      });
      await widgetTester.pumpAndSettle();
      expect(find.text('No'), findsOneWidget);
      await widgetTester.tap(find.text('No'));
      await widgetTester.pumpAndSettle();
      expectedPath('/two');
      expect(find.byType(WidgetTwo), findsOneWidget);
      expect(find.text('No'), findsNothing);
      expect(true, firstDialogDone);

      var secondDialogDone = false;
      delegate.popRoute().whenComplete(() {
        secondDialogDone = true;
      });
      await widgetTester.pumpAndSettle();
      expect(find.text('Yes'), findsOneWidget);
      await widgetTester.tap(find.text('Yes'));
      await widgetTester.pumpAndSettle();
      expect(find.text('Yes'), findsNothing);
      expectedPath('/');
      expect(find.byType(WidgetOne), findsOneWidget);
      expect(true, secondDialogDone);
    });
  });
}
