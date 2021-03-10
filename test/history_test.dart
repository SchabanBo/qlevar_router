import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

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
            QRoute(path: '/child', builder: () => Text('child')),
            QRoute(path: '/child-1', builder: () => Text('child 1')),
            QRoute(path: '/child-2', builder: () => Text('child 2')),
            QRoute(path: '/child-3', builder: () => Text('child 3')),
          ]),
    ];
    test('Stack with Nested Route With QR.back()', () async {
      QR.reset();
      final _ = QRouterDelegate(routes);
      await QR.to('/nested');
      expect(QR.curremtPath, '/nested/child');
      expect(QR.history.length, 3);

      await QR.to('/nested/child-1');
      expect(QR.curremtPath, '/nested/child-1');
      expect(QR.history.length, 4);

      await QR.to('/nested/child-3');
      expect(QR.curremtPath, '/nested/child-3');
      expect(QR.history.length, 5);

      QR.back();
      expect(QR.curremtPath, '/nested/child-1');
      expect(QR.history.length, 4);

      QR.back();
      expect(QR.curremtPath, '/nested/child');
      expect(QR.history.length, 3);

      QR.back();
      expect(QR.curremtPath, '/');
      expect(QR.history.length, 1);
    });

    testWidgets('Stack with Nested Route when parent pop', (tester) async {
      QR.reset();
      await tester.pumpWidget(AppWarpper(routes));

      await QR.to('/nested');
      await tester.pumpAndSettle();
      expect(QR.curremtPath, '/nested/child');
      expect(find.text('child'), findsOneWidget);
      expect(QR.history.length, 3);

      await QR.to('/nested/child-1');
      await tester.pumpAndSettle();
      expect(QR.curremtPath, '/nested/child-1');
      expect(find.text('child 1'), findsOneWidget);
      expect(QR.history.length, 4);

      await QR.to('/nested/child-3');
      await tester.pumpAndSettle();
      expect(QR.curremtPath, '/nested/child-3');
      expect(find.text('child 3'), findsOneWidget);
      expect(QR.history.length, 5);

      final backButton = find.byTooltip('Back');
      await tester.tap(backButton);
      expect(QR.curremtPath, '/');
      expect(QR.history.length, 1);
    });
  });
}
