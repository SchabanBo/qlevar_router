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
              onEnterFunc: () => counter++,
              onExitFunc: () => counter++,
              onMatchFunc: () => counter++,
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
              onEnterFunc: () => counter++,
              onExitFunc: () => counter++,
              onMatchFunc: () => counter++,
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
      QR.navigator.replaceAll('/three');
      expect(counter, 7); // Nested onExite + Two onExite
    });
  });
}
