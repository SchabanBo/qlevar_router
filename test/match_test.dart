import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:qlevar_router/src/routes/qroute_internal.dart';

import 'helpers.dart';
import 'test_widgets/test_widgets.dart';

void main() {
  group('Match Test', () {
    final routes = [
      QRoute(path: '/', builder: () => Container()),
      QRoute(path: '/zero', builder: () => Scaffold(body: Container())),
      QRoute(
          path: '/two/one',
          builder: () => const Scaffold(body: WidgetTwo()),
          children: [
            QRoute(
                path: 'three',
                builder: () => const Scaffold(body: WidgetThree())),
          ]),
      QRoute(
          path: '/two/:id',
          builder: () => const Scaffold(body: WidgetTwo()),
          children: [
            QRoute(
                path: '/three',
                builder: () => const Scaffold(body: WidgetThree())),
          ]),
      QRoute.withChild(
          path: 'this/extra',
          builderChild: (child) => Scaffold(body: child),
          children: [
            QRoute(path: '/', builder: () => const Scaffold(body: WidgetOne())),
            QRoute(
                path: '/slash',
                builder: () => const Scaffold(body: WidgetThree())),
          ]),
    ];

    testWidgets('Find Multi component', (tester) async {
      QR.reset();
      await tester.pumpWidget(AppWrapper(routes));

      await QR.to('/two/one/');
      await tester.pumpAndSettle();
      expectedPath('/two/one');
      expect(find.byType(WidgetTwo), findsOneWidget);

      await QR.to('/zero');
      await tester.pumpAndSettle();
      expectedPath('/zero');
      expect(find.byType(WidgetTwo), findsNothing);

      await QR.to('/two/one/three');
      await tester.pumpAndSettle();
      expectedPath('/two/one/three');
      expect(find.byType(WidgetThree), findsOneWidget);
    });

    testWidgets('Find Multi component with path param', (tester) async {
      QR.reset();
      await tester.pumpWidget(AppWrapper(routes));

      await QR.to('/two/5');
      await tester.pumpAndSettle();
      expectedPath('/two/5');
      expect(find.byType(WidgetTwo), findsOneWidget);

      await QR.to('/zero');
      await tester.pumpAndSettle();
      expectedPath('/zero');
      expect(find.byType(WidgetTwo), findsNothing);

      await QR.to('/two/7/three');
      await tester.pumpAndSettle();
      expectedPath('/two/7/three');
      expect(find.byType(WidgetThree), findsOneWidget);
    });

    testWidgets('No Extra Slash at the end', (tester) async {
      QR.reset();
      await tester.pumpWidget(AppWrapper(routes));

      await QR.to('/this/extra');
      await tester.pumpAndSettle();
      expectedPath('/this/extra');
      expect(find.byType(WidgetOne), findsOneWidget);

      await QR.to('/this/extra/slash');
      await tester.pumpAndSettle();
      expectedPath('/this/extra/slash');
      expect(find.byType(WidgetThree), findsOneWidget);

      await QR.back();
      await tester.pumpAndSettle();
      expectedPath('/this/extra');
      expect(find.byType(WidgetOne), findsOneWidget);
    });

    testWidgets('Multi path init route', (tester) async {
      QR.reset();
      await tester.pumpWidget(AppWrapper(
        [
          QRoute(path: '/', builder: () => Container()),
          QRoute(path: '/zero', builder: () => Scaffold(body: Container())),
          QRoute(
              path: '/two/one',
              builder: () => const Scaffold(body: WidgetTwo()),
              children: [
                QRoute(
                    path: '/three',
                    builder: () => const Scaffold(body: WidgetThree())),
              ])
        ],
        initPath: '/two/one',
      ));
      await tester.pumpAndSettle();
      expectedPath('/two/one');
      expect(find.byType(WidgetTwo), findsOneWidget);
    });

    testWidgets('Multi path with child init route', (tester) async {
      QR.reset();
      await tester.pumpWidget(AppWrapper(
        [
          QRoute(path: '/', builder: () => Container()),
          QRoute(path: '/zero', builder: () => Scaffold(body: Container())),
          QRoute.withChild(
              path: '/this/extra',
              builderChild: (child) => Scaffold(body: child),
              children: [
                QRoute(path: '/', builder: () => const Scaffold()),
                QRoute(
                    path: '/slash',
                    builder: () => const Scaffold(body: WidgetThree())),
              ]),
        ],
        initPath: '/this/extra/slash',
      ));
      await tester.pumpAndSettle();
      expectedPath('/this/extra/slash');
      expect(find.byType(WidgetThree), findsOneWidget);
    });

    testWidgets('Path query should only append to the last match',
        (tester) async {
      QR.reset();
      await tester.pumpWidget(AppWrapper(
        [
          QRoute(path: '/', builder: () => Container()),
          QRoute(path: '/zero', builder: () => Scaffold(body: Container())),
          QRoute.withChild(
              path: '/this/extra',
              builderChild: (child) => Scaffold(body: child),
              children: [
                QRoute(path: '/', builder: () => const Scaffold()),
                QRoute(
                    path: '/slash/extra',
                    builder: () => const Scaffold(body: WidgetThree())),
              ]),
        ],
        initPath: '/this/extra/slash/extra?id=200',
      ));
      await tester.pumpAndSettle();
      expectedPath('/this/extra/slash/extra?id=200');
      expect(QR.history.entries[0].path, '/this/extra');
    });

    test('Throw error when the route name is not unique', () {
      final route = QRoute(
        path: '/test',
        builder: () => Scaffold(body: Container()),
        children: [
          QRoute(
              path: '/zero',
              builder: () => Scaffold(body: Container()),
              name: 'zero'),
          QRoute(
              path: '/one',
              builder: () => Scaffold(body: Container()),
              name: 'zero'),
        ],
      );
      expect(() => QRouteInternal.from(route, '/'),
          throwsA(isA<AssertionError>()));
    });

    testWidgets('#124', (tester) async {
      QR.reset();
      await tester.pumpWidget(AppWrapper([
        QRoute(path: '/', builder: () => const Scaffold(body: WidgetOne())),
        QRoute(
            name: 'two',
            path: '/two/:id',
            builder: () => const Scaffold(body: WidgetTwo())),
        QRoute(
            name: 'three',
            path: '/three',
            builder: () => const Scaffold(body: WidgetThree())),
      ]));
      await QR.navigator.push('/two/1');
      QR.updateUrlInfo('/two/1/test');
      QR.updateUrlInfo('/two/1');
      await QR.navigator.push('/three');
      await QR.back();
      await QR.back();
      printCurrentHistory();
    });

    testWidgets('#154', (tester) async {
      QR.reset();
      await tester.pumpWidget(AppWrapper([
        QRoute(
          path: '/',
          builder: () => const Scaffold(body: WidgetOne()),
        ),
        QRoute.withChild(
          path: '/auth',
          children: [
            QRoute(
              path: 'login',
              builder: () => const Text("login"),
            )
          ],
          builderChild: (r) {
            return Scaffold(body: r);
          },
        ),
        QRoute(
          path: '/auth/home',
          builder: () => const Text("home"),
        ),
      ]));
      await QR.to('/auth/login');
      await tester.pumpAndSettle();
      expect(find.text('login'), findsOneWidget);
      expectedPath('/auth/login');
      await QR.to('/auth/home');
      await tester.pumpAndSettle();
      expect(find.text('home'), findsOneWidget);
      expectedPath('/auth/home');
    });
  });
}
