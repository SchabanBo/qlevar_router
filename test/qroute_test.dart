import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'test_widgets/test_widgets.dart';

void main() {
  testWidgets(
    'QRoute assert',
    (tester) async {
      expect(() => QRoute(path: '/'), throwsAssertionError);
      expect(() => QRoute(page: (s) => s, path: null), throwsAssertionError);
      expect(() => QRoute(redirectGuard: (s) => '/', path: null),
          throwsAssertionError);
    },
  );

  testWidgets("onInit / onDispose", (tester) async {
    var initCounter = 1;
    var disposeCounter = 1;
    await tester.pumpWidget(AppWarpper([
      QRoute(
          path: '/',
          onInit: () => initCounter++,
          onDispose: () => disposeCounter++,
          page: (c) => Scaffold(
                body: WidgetOne(),
              )),
      QRoute(
          path: '/tow',
          onInit: () => initCounter++,
          onDispose: () => disposeCounter++,
          page: (c) => Scaffold(
                body: WidgetTwo(),
              )),
      QRoute(
          path: '/three',
          onDispose: () => disposeCounter++,
          page: (c) => Scaffold(
                body: WidgetTwo(),
              ))
    ]));
    expect(initCounter, 2);
    expect(disposeCounter, 1);
    QR.to('/tow');
    expect(initCounter, 3);
    expect(disposeCounter, 2);
    QR.back();
    expect(initCounter, 4);
    expect(disposeCounter, 3);
    QR.to('/three');
    expect(initCounter, 4);
    expect(disposeCounter, 4);
  });
}
