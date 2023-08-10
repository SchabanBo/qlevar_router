import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'helpers.dart';

void main() {
  group('Test waiting for result while navigating', () {
    test('using QR.to', () async {
      QR.reset();
      final delegate = QRouterDelegate([
        const QRoute(path: '/', builder: SizedBox.shrink),
        const QRoute(path: '/tow', builder: SizedBox.shrink),
      ]);
      await delegate.setInitialRoutePath('/');
      Future.delayed(const Duration(milliseconds: 500), () {
        expectedPath('/tow');
        QR.back('waited result');
      });
      final result = await QR
          .to('/tow', waitForResult: true)
          .timeout(const Duration(seconds: 1));
      expect(result, 'waited result');
    });

    test('using QR.toName', () async {
      QR.reset();
      final delegate = QRouterDelegate([
        const QRoute(path: '/', builder: SizedBox.shrink),
        const QRoute(path: '/tow', name: 'Tow', builder: SizedBox.shrink),
      ]);
      await delegate.setInitialRoutePath('/');
      Future.delayed(const Duration(milliseconds: 500), () {
        expectedPath('/tow');
        QR.back('waited result');
      });
      final result = await QR
          .toName('Tow', waitForResult: true)
          .timeout(const Duration(seconds: 1));
      expect(result, 'waited result');
    });

    test('using QR.to has children', () async {
      QR.reset();
      final delegate = QRouterDelegate([
        const QRoute(path: '/', builder: SizedBox.shrink),
        const QRoute(
          path: '/tow',
          name: 'Tow',
          builder: SizedBox.shrink,
          children: [
            QRoute(path: '/child', name: 'Child', builder: SizedBox.shrink),
          ],
        ),
      ]);
      await delegate.setInitialRoutePath('/');
      await QR.to('/tow');
      Future.delayed(const Duration(milliseconds: 500), () {
        expectedPath('/tow/child');
        QR.back('waited result');
      });
      final result = await QR
          .to('/tow/child', waitForResult: true)
          .timeout(const Duration(seconds: 1));
      expect(result, 'waited result');
    });

    test('using QR.toName has children', () async {
      QR.reset();
      final delegate = QRouterDelegate([
        const QRoute(path: '/', builder: SizedBox.shrink),
        const QRoute(
          path: '/tow',
          name: 'Tow',
          builder: SizedBox.shrink,
          children: [
            QRoute(path: '/child', name: 'Child', builder: SizedBox.shrink),
          ],
        ),
      ]);
      await delegate.setInitialRoutePath('/');
      await QR.toName('Tow');
      Future.delayed(const Duration(milliseconds: 500), () {
        expectedPath('/tow/child');
        QR.back('waited result');
      });
      final result = await QR
          .toName('Child', waitForResult: true)
          .timeout(const Duration(seconds: 1));
      expect(result, 'waited result');
    });
  });
}
