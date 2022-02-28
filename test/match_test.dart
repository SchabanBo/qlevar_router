import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'helpers.dart';
import 'test_widgets/test_widgets.dart';

void main() {
  group('Match Test', () {
    final routes = [
      QRoute(path: '/', builder: () => Container()),
      QRoute(path: '/zero', builder: () => Scaffold(body: Container())),
      QRoute(
          path: '/two/one',
          builder: () => Scaffold(body: WidgetTwo()),
          children: [
            QRoute(path: 'three', builder: () => Scaffold(body: WidgetThree())),
          ]),
      QRoute(
          path: '/two/:id',
          builder: () => Scaffold(body: WidgetTwo()),
          children: [
            QRoute(
                path: '/three', builder: () => Scaffold(body: WidgetThree())),
          ]),
      QRoute.withChild(
          path: 'this/extra',
          builderChild: (child) => Scaffold(body: child),
          children: [
            QRoute(path: '/', builder: () => Scaffold(body: WidgetOne())),
            QRoute(
                path: '/slash', builder: () => Scaffold(body: WidgetThree())),
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
              builder: () => Scaffold(body: WidgetTwo()),
              children: [
                QRoute(
                    path: '/three',
                    builder: () => Scaffold(body: WidgetThree())),
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
                QRoute(path: '/', builder: () => Scaffold()),
                QRoute(
                    path: '/slash',
                    builder: () => Scaffold(body: WidgetThree())),
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
                QRoute(path: '/', builder: () => Scaffold()),
                QRoute(
                    path: '/slash/extra',
                    builder: () => Scaffold(body: WidgetThree())),
              ]),
        ],
        initPath: '/this/extra/slash/extra?id=200',
      ));
      await tester.pumpAndSettle();
      expectedPath('/this/extra/slash/extra?id=200');
      expect(QR.history.entries[0].path, '/this/extra');
    });
  });
}
