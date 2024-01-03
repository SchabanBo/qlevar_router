import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'helpers.dart';
import 'test_widgets/test_widgets.dart';

void main() {
  group('History', () {
    final routes = [
      QRoute(path: '/', builder: () => Container()),
      QRoute.withChild(
          path: '/nested',
          builderChild: (r) => Scaffold(appBar: AppBar(), body: r),
          initRoute: '/child',
          children: [
            QRoute(path: '/child', builder: () => const Text('child')),
            QRoute(path: '/child-1', builder: () => const Text('child 1')),
            QRoute(path: '/child-2', builder: () => const Text('child 2')),
            QRoute(path: '/child-3', builder: () => const Text('child 3')),
          ]),
      QRoute(path: '/two', builder: () => const Scaffold(body: WidgetTwo())),
      QRoute(
          path: '/three', builder: () => const Scaffold(body: WidgetThree())),
    ];
    test('Stack with Nested Route With QR.back()', () async {
      QR.reset();
      final delegate = QRouterDelegate(routes);
      await delegate.setInitialRoutePath('/');
      await QR.to('/nested');
      expectedPath('/nested/child');
      expectedHistoryLength(3);

      await QR.to('/nested/child-1');
      expectedPath('/nested/child-1');
      expectedHistoryLength(4);

      await QR.to('/nested/child-3');
      expectedPath('/nested/child-3');
      expectedHistoryLength(5);

      await QR.back();
      expectedPath('/nested/child-1');
      expectedHistoryLength(4);

      await QR.back();
      expectedPath('/nested/child');
      expectedHistoryLength(3);

      // navigate to route belongs to a different navigator
      await QR.to('/two');
      expectedPath('/two');
      expectedHistoryLength(4);

      await QR.back();
      expectedPath('/nested/child');

      /// test the toString function
      final beforeLast = QR.history.beforeLast;
      expect(beforeLast.toString(),
          'key: ${beforeLast.key}, path: ${beforeLast.path}, navigator: ${beforeLast.navigator}');
      expectedHistoryLength(3);

      await QR.back();
      expectedPath('/');
      expectedHistoryLength(1);
      delegate.dispose();
    });

    testWidgets('Stack with Nested Route when parent pop', (tester) async {
      // When pressing back on the parent all children should be closed
      // and the path should be the previous route in the parent navigator
      QR.reset();
      await tester.pumpWidget(AppWrapper(routes));

      await QR.to('/nested');
      await tester.pumpAndSettle();
      expect(find.text('child'), findsOneWidget);
      expectedPath('/nested/child');
      expectedHistoryLength(3);

      await QR.to('/nested/child-1');
      await tester.pumpAndSettle();
      expect(find.text('child 1'), findsOneWidget);
      expectedPath('/nested/child-1');
      expectedHistoryLength(4);

      await QR.to('/nested/child-3');
      await tester.pumpAndSettle();
      expect(find.text('child 3'), findsOneWidget);
      expectedPath('/nested/child-3');
      expectedHistoryLength(5);

      var backButton = find.byTooltip('Back');
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expectedPath('/');
      expectedHistoryLength(1);
    });

    test('Simple Navigation History', () async {
      QR.reset();
      final delegate = QRouterDelegate(routes);
      await delegate.setInitialRoutePath('/');
      await QR.to('/nested');
      expectedPath('/nested/child');
      expectedHistoryLength(3);

      await QR.to('/nested/child-1');
      expectedPath('/nested/child-1');
      expectedHistoryLength(4);

      await QR.to('/two');
      expectedPath('/two');
      expectedHistoryLength(5);

      await QR.to('/nested/child-1');
      expectedPath('/nested/child-1');
      expectedHistoryLength(4);

      await QR.back();
      expectedPath('/nested/child');
      expectedHistoryLength(3);
    });
  });
}
