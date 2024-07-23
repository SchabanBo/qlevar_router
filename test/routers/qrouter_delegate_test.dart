import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers.dart';
import '../test_widgets/test_widgets.dart';

void main() {
  group('PopRoute', () {
    // [#69]
    test(
        'Android app should exist with back button with no navigation before [#69]',
        () async {
      QR.reset();
      final delegate = QRouterDelegate([
        QRoute(path: '/', builder: () => const Scaffold(body: WidgetOne())),
        QRoute(path: '/tow', builder: () => const Scaffold(body: WidgetTwo()))
      ]);
      await delegate.setInitialRoutePath('/');
      final isPopped = await delegate.popRoute();
      expect(isPopped, false); // when return false then the app will close
    });

    // [#69]
    test(
        'Android app should exist with back button with navigation before [#69]',
        () async {
      QR.reset();
      final delegate = QRouterDelegate([
        QRoute(path: '/', builder: () => const Scaffold(body: WidgetOne())),
        QRoute(path: '/tow', builder: () => const Scaffold(body: WidgetTwo()))
      ]);
      await delegate.setInitialRoutePath('/');
      await QR.to('/tow');
      expectedPath('/tow');
      final isPopped = await delegate.popRoute();
      expect(isPopped, true); // page return to previous page
      expectedPath('/');
      final isPopped1 = await delegate.popRoute();
      expect(isPopped1, false); // when return false then the app will close
    });

    test(
        'Android app should exist with back button with QRoute.withChild [#72]',
        () async {
      QR.reset();
      final delegate = QRouterDelegate([
        QRoute(
          path: '/login',
          builder: () => const Scaffold(body: WidgetOne()),
        ),
        QRoute.withChild(
            path: '/dashboard',
            name: 'dashboard',
            initRoute: '/first',
            builderChild: (router) => Scaffold(body: Center(child: router)),
            children: [
              QRoute(
                path: '/first',
                name: 'first',
                builder: () => const WidgetOne(),
              ),
            ])
      ]);
      await delegate.setInitialRoutePath('/login');
      await QR.navigator.replaceLastName('dashboard');
      // wait for the child to be added
      await Future.delayed(const Duration(milliseconds: 1000));
      expectedPath('/dashboard/first');
      expect(QR.history.length, 2); // The dashboard and the first page
      final isPopped = await delegate.popRoute();
      expect(isPopped, false); // when return false then the app will close
    });
  });
}
