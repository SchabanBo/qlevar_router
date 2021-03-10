import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'test_widgets/test_widgets.dart';

void main() {
  group('Params', () {
    test('Query Params', () {
      QR.reset();
      final _ = QRouterDelegate([
        QRoute(path: '/', builder: () => Scaffold(body: WidgetOne())),
        QRoute(path: '/tow', builder: () => Scaffold(body: WidgetTwo()))
      ]);
      QR.to('/tow?param1=45&param2=not');
      expect(QR.currentPath, '/tow?param1=45&param2=not');
      expect(QR.params['param1']!.asInt, 45);
      expect(QR.params['param2'].toString(), 'not');
      QR.back();
      expect(QR.params.length, 0);
    });
    test('Path Params', () {
      QR.reset();
      final _ = QRouterDelegate([
        QRoute(path: '/', builder: () => Scaffold(body: WidgetOne())),
        QRoute(path: '/:userId', builder: () => Scaffold(body: WidgetTwo()))
      ]);
      for (var i = 0; i < 5; i++) {
        QR.to('/$i');
        expect(QR.currentPath, '/$i');
        expect(QR.params['userId']!.asInt, i);
        QR.back();
        expect(QR.params.length, 0);
      }
    });

    test('Nested Compoent Test', () async {
      QR.reset();
      final _ = QRouterDelegate([
        QRoute(path: '/', builder: () => Scaffold(body: WidgetOne())),
        QRoute(
            path: '/user',
            builder: () => Scaffold(body: Container()),
            children: [
              QRoute(path: '/:userId', builder: () => Container(), children: [
                QRoute(path: '/info', builder: () => WidgetTwo()),
              ]),
            ]),
      ]);
      await QR.to('/user/5/info');
      expect(QR.currentPath, '/user/5/info');
      expect(QR.params['userId']!.asInt, 5);
      QR.back(); // /user/5
      expect(QR.currentPath, '/user/5');
      expect(QR.params['userId']!.asInt, 5);
      expect(QR.params.length, 1);
      QR.back(); // /user
      expect(QR.currentPath, '/user');
      expect(QR.params.length, 0);
    });

    test('Multi Compoent Test', () async {
      QR.reset();
      final _ = QRouterDelegate([
        QRoute(path: '/', builder: () => Scaffold(body: WidgetOne())),
        QRoute(
            path: '/user',
            builder: () => Scaffold(body: Container()),
            children: [
              QRoute(path: '/:userId', builder: () => Container(), children: [
                QRoute(path: '/', builder: () => WidgetOne()),
                QRoute(path: '/info', builder: () => Container(), children: [
                  QRoute(path: '/', builder: () => WidgetOne()),
                  QRoute(path: '/:companyId', builder: () => WidgetTwo())
                ]),
              ]),
            ]),
      ]);

      await QR.to('/user/5/info/7?hi=tt');
      expect(QR.currentPath, '/user/5/info/7?hi=tt');
      expect(QR.params['userId']!.asInt, 5);
      expect(QR.params['companyId']!.asInt, 7);
      expect(QR.params['hi']!.toString(), 'tt');
      QR.back();
      expect(QR.currentPath, '/user/5/info');
      expect(QR.params['userId']!.asInt, 5);
      expect(QR.params.length, 1);
      QR.back();
      expect(QR.currentPath, '/user/5');
      expect(QR.params.length, 1);
      QR.back();
      expect(QR.currentPath, '/user');
      expect(QR.params.length, 0);
      QR.back();
      expect(QR.currentPath, '/');
      expect(QR.params.length, 0);
    });
  });
}
