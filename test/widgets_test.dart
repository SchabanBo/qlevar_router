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
            QRoute(
                path: '/three', builder: () => Scaffold(body: WidgetThree())),
          ]),
      QRoute(
          path: '/two/:id',
          builder: () => Scaffold(body: WidgetTwo()),
          children: [
            QRoute(
                path: '/three', builder: () => Scaffold(body: WidgetThree())),
          ]),
      QRoute.withChild(
          path: '/this/extra',
          builderChild: (child) => Scaffold(body: child),
          children: [
            QRoute(
                path: '/',
                builder: () => Scaffold(
                        body: Column(
                      children: [
                        SizedBox(),
                        QR.history.debug(),
                        QR.getActiveTree(),
                      ],
                    ))),
            QRoute(
                path: '/slash', builder: () => Scaffold(body: WidgetThree())),
          ]),
    ];

    testWidgets('Active Tree Widget', (tester) async {
      QR.reset();
      await tester.pumpWidget(AppWarpper(routes));

      await QR.to('/two/one');
      await tester.pumpAndSettle();
      await QR.to('/this/extra');
      await tester.pumpAndSettle();
      expectedPath('/this/extra');
      expect(find.byType(SizedBox), findsOneWidget);
      await tester.tap(find.text('Show Active Tree'));
      await tester.pumpAndSettle();
      expect(find.text('Stack Tree:'), findsOneWidget);
    });

    testWidgets('Show Navigation History', (tester) async {
      QR.reset();
      await tester.pumpWidget(AppWarpper(routes));

      await QR.to('/two/one');
      await tester.pumpAndSettle();
      await QR.to('/this/extra');
      await tester.pumpAndSettle();
      expectedPath('/this/extra');
      expect(find.byType(SizedBox), findsOneWidget);
      await tester.tap(find.text('Show Navigation History'));
      await tester.pumpAndSettle();
      expect(find.text('History:'), findsOneWidget);
    });
  });
}
