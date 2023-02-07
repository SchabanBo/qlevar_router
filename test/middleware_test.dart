import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'helpers.dart';
import 'test_widgets/test_widgets.dart';

void main() {
  var isAuth = false;
  var counter = 0;
  final routes = [
    QRoute(path: '/', builder: () => Container()),
    QRoute.withChild(
        path: '/nested',
        builderChild: (r) => Scaffold(appBar: AppBar(), body: r),
        initRoute: '/child',
        middleware: [
          QMiddleware(),
          QMiddlewareBuilder(redirectGuardFunc: (s) async {
            if (kDebugMode) {
              print('From redirect guard: $s');
            }
            return await Future.delayed(const Duration(milliseconds: 500),
                () => isAuth ? null : '/two');
          }),
          QMiddlewareBuilder(
            onEnterFunc: () async => counter++,
            onExitFunc: () async => counter++,
            onMatchFunc: () async => counter++,
          )
        ],
        children: [
          QRoute(path: '/child', builder: () => const Text('child')),
          QRoute(path: '/child-1', builder: () => const Text('child 1')),
          QRoute(path: '/child-2', builder: () => const Text('child 2')),
          QRoute(path: '/child-3', builder: () => const Text('child 3')),
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
        builder: () => const Scaffold(body: WidgetTwo())),
    QRoute(path: '/three', builder: () => const Scaffold(body: WidgetThree())),
  ];
  test('Redirect / onEnter / onMatch / onExit', () async {
    QR.reset();
    QRouterDelegate(routes);
    await QR.to('/nested');
    expectedPath('/two');
    isAuth = true;
    expect(counter, 3); // Nested onMatch + Two onMatch + Two onEnter
    // Here to() is used then the Two onExit will not be called
    await QR.to('/nested');
    expect(counter, 5); // Nested onMatch + Nested onEnter
    expectedPath('/nested/child');
    await QR.navigator.replaceAll('/three');
    expect(counter, 7); // Nested onExit + Two onExit
  });

  testWidgets('onExited with replaceLast & replaceLastName',
      (widgetTester) async {
    QR.reset();
    var counter = 0;
    final routes = [
      QRoute(
        path: '/',
        builder: () => Scaffold(appBar: AppBar(), body: const WidgetOne()),
      ),
      QRoute.withChild(
          path: '/nested',
          builderChild: (r) => Scaffold(appBar: AppBar(), body: r),
          initRoute: '/child',
          middleware: [
            QMiddlewareBuilder(onExitedFunc: () => counter++),
          ],
          children: [
            QRoute(
                path: '/child',
                middleware: [
                  QMiddlewareBuilder(onExitedFunc: () => counter++),
                ],
                builder: () => const Text('child')),
            QRoute(
                path: '/child-1',
                middleware: [
                  QMiddlewareBuilder(onExitedFunc: () => counter++),
                ],
                builder: () => const Text('child 1')),
          ]),
      QRoute(
        path: '/two',
        middleware: [
          QMiddlewareBuilder(onExitedFunc: () => counter++),
        ],
        builder: () => const Scaffold(body: WidgetTwo()),
      ),
      QRoute(
          path: '/three',
          middleware: [
            QMiddlewareBuilder(onExitedFunc: () => counter++),
          ],
          builder: () => const Scaffold(
                body: WidgetThree(),
              )),
    ];
    final delegate = QRouterDelegate(routes);
    await widgetTester.pumpWidget(MaterialApp.router(
        routeInformationParser: const QRouteInformationParser(),
        routerDelegate: delegate));
    await widgetTester.pumpAndSettle();
    expectedPath('/');
    expect(find.byType(WidgetOne), findsOneWidget);

    await QR.to('/nested');
    expectedPath('/nested/child');
    widgetTester.binding.scheduleFrame();
    await widgetTester.pumpAndSettle();
    expect(counter, 0);

    await QR.to('/nested/child-1');
    expectedPath('/nested/child-1');
    widgetTester.binding.scheduleFrame();
    await widgetTester.pumpAndSettle();
    expect(counter, 0);

    await QR.back(); // removes child-1 from the stack
    expectedPath('/nested/child');
    expect(counter, 0); // as frame was not schedule, counter will be 0

    widgetTester.binding.scheduleFrame();
    await widgetTester.pumpAndSettle();
    expectedPath('/nested/child');
    // counter should be 1, because frame has been scheduled above
    expect(counter, 1);

    await QR.navigator.replaceLast('two');
    expectedPath('/two');
    // as frame was not schedule, counter will be not be updated
    expect(counter, 1);

    widgetTester.binding.scheduleFrame();
    await widgetTester.pumpAndSettle();
    expectedPath('/two');
    // counter should be updated, because frame has been scheduled above
    expect(counter, 3); // child + nested

    await QR.navigator.replaceAll('three');
    expectedPath('/three');
    // as frame was not schedule, counter will be not be updated
    expect(counter, 3);

    widgetTester.binding.scheduleFrame();
    await widgetTester.pumpAndSettle();
    expectedPath('/three');
    // counter should be updated, because frame has been scheduled above
    expect(counter, 4);
  });

  test('Redirect guard has the right path and param', () async {
    QR.reset();
    var pathFromGuard = '';
    var paramFromGuard = '';
    final delegate = QRouterDelegate([
      QRoute(
          path: '/:domainId/dashboard',
          builder: () => Container(),
          middleware: [
            QMiddlewareBuilder(redirectGuardFunc: (s) async {
              pathFromGuard = s;
              if (kDebugMode) {
                print(s);
              }
              paramFromGuard = QR.params['domainId'].toString();
              return null;
            })
          ])
    ], initPath: '/domain1/dashboard');
    await delegate.setInitialRoutePath('/');
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
        builder: () => Scaffold(appBar: AppBar(), body: const WidgetOne()),
      ),
      QRoute(path: '/two', builder: () => const WidgetTwo(), middleware: [
        QMiddlewareBuilder(canPopFunc: () async {
          final result = await showDialog<bool>(
              context: QR.context!,
              builder: (context) => AlertDialog(
                    title: const Text('Do you want to go back?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('No'),
                      )
                    ],
                  ));

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

  testWidgets('middleware run in the right order', (widgetTester) async {
    final now = DateTime.now();
    var onMatch = now;
    var redirect = now;
    var onEnter = now;
    var canPop = now;
    var onExit = now;
    var onExited = now;

    QR.reset();
    const duration = Duration(milliseconds: 1000);
    final delegate = QRouterDelegate([
      QRoute(path: '/', builder: () => const SizedBox()),
      QRoute(path: '/two', builder: () => const SizedBox(), middleware: [
        QMiddlewareBuilder(
          canPopFunc: () async {
            canPop = DateTime.now();
            await widgetTester.pumpAndSettle(duration);
            return true;
          },
          onEnterFunc: () async {
            await widgetTester.pumpAndSettle(duration);
            onEnter = DateTime.now();
          },
          onExitFunc: () async {
            await widgetTester.pumpAndSettle(duration);
            onExit = DateTime.now();
          },
          onExitedFunc: () {
            onExited = DateTime.now();
          },
          onMatchFunc: () async {
            await widgetTester.pumpAndSettle(duration);
            onMatch = DateTime.now();
          },
          redirectGuardFunc: (p0) async {
            await widgetTester.pumpAndSettle(duration);
            redirect = DateTime.now();
            return null;
          },
        )
      ]),
    ]);

    await widgetTester.pumpWidget(MaterialApp.router(
        routeInformationParser: const QRouteInformationParser(),
        routerDelegate: delegate));
    await widgetTester.pumpAndSettle();
    widgetTester.binding.scheduleFrame();
    expectedPath('/');

    await QR.to('/two');
    await widgetTester.pumpAndSettle();
    expectedPath('/two');
    await QR.back();
    await widgetTester.pumpAndSettle();
    expectedPath('/');

    // Ensure all values are set
    expect(now.isBeforeOrSame(onMatch), true);
    expect(now.isBeforeOrSame(redirect), true);
    expect(now.isBeforeOrSame(onEnter), true);
    expect(now.isBeforeOrSame(canPop), true);
    expect(now.isBeforeOrSame(onExit), true);
    expect(now.isBeforeOrSame(onExited), true);
    // ensure the right order
    expect(onMatch.isBeforeOrSame(redirect), true);
    expect(redirect.isBeforeOrSame(onEnter), true);
    expect(onEnter.isBeforeOrSame(canPop), true);
    expect(canPop.isBeforeOrSame(onExit), true);
    expect(onExit.isBeforeOrSame(onExited), true);
  });
}

extension DateOrder on DateTime {
  bool isBeforeOrSame(DateTime other) {
    final def = difference(other);
    return def.isNegative || def.inMilliseconds == 0;
  }
}
