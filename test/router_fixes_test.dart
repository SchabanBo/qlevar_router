import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'helpers.dart';

void main() {
  testWidgets('A second back while a canPop dialog is open dismisses it',
      (tester) async {
    QR.reset();
    final delegate = QRouterDelegate([
      QRoute(path: '/', builder: () => const Text('home')),
      QRoute(
        path: '/edit',
        middleware: [
          QMiddlewareBuilder(
            canPopFunc: () async =>
                await showDialog<bool>(
                  context: QR.context!,
                  builder: (_) => const Text('discard?'),
                ) ??
                false,
          ),
        ],
        builder: () => const Text('edit'),
      ),
    ]);
    await tester.pumpWidget(MaterialApp.router(
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: delegate,
    ));
    await tester.pumpAndSettle();
    await QR.to('/edit');
    await tester.pumpAndSettle();

    bool? first, second;
    delegate.popRoute().then((r) => first = r);
    await tester.pumpAndSettle();
    expect(find.text('discard?'), findsOneWidget);

    delegate.popRoute().then((r) => second = r);
    await tester.pumpAndSettle();
    // false here makes Flutter close the app
    expect(second, isTrue);
    expect(first, isTrue);
    expect(find.text('discard?'), findsNothing);
    expect(find.text('edit'), findsOneWidget);
  });

  test('Deep link keeps escaped &, # and + inside query values', () async {
    QR.reset();
    final delegate = QRouterDelegate([
      const QRoute(path: '/', builder: SizedBox.shrink),
      const QRoute(path: '/search', builder: SizedBox.shrink),
    ]);
    await delegate.setInitialRoutePath(
        'https://example.com/search?q=salt%20%26%20pepper%20%231%2B');
    expect(QR.params['q'].toString(), 'salt & pepper #1+');
  });

  test('valueAs returns null for a null value', () {
    expect(ParamValue(null).valueAs<bool>(), isNull);
  });

  test('Removing a nested navigator keeps the other history entries', () async {
    QR.reset();
    final delegate = QRouterDelegate([
      const QRoute(path: '/', builder: SizedBox.shrink),
      QRoute.withChild(
        path: '/home',
        name: 'home',
        builderChild: (r) => r,
        initRoute: '/a',
        children: [
          const QRoute(path: '/a', builder: SizedBox.shrink),
          const QRoute(path: '/b', builder: SizedBox.shrink),
        ],
      ),
      const QRoute(path: '/settings', builder: SizedBox.shrink),
      const QRoute(path: '/other', builder: SizedBox.shrink),
    ]);
    await delegate.setInitialRoutePath('/');
    await QR.to('/home/a');
    await QR.to('/home/b');
    await QR.to('/settings');

    await QR.replace('/home', '/other');
    final paths = QR.history.entries.map((e) => e.path).toList();
    expect(paths, containsAllInOrder(['/', '/settings', '/other']));
    expect(paths.where((p) => p.startsWith('/home')), isEmpty);
  });

  test('A replaced page completes its waitForResult future', () async {
    QR.reset();
    final delegate = QRouterDelegate([
      const QRoute(path: '/', builder: SizedBox.shrink),
      const QRoute(path: '/tow', builder: SizedBox.shrink),
      const QRoute(path: '/three', builder: SizedBox.shrink),
    ]);
    await delegate.setInitialRoutePath('/');
    final waiting = QR.to('/tow', waitForResult: true);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expectedPath('/tow');
    await QR.replace('/tow', '/three');
    expect(await waiting.timeout(const Duration(seconds: 1)), isNull);
  });

  test('switchTo brings only the route and its children to the top', () async {
    QR.reset();
    final delegate = QRouterDelegate([
      const QRoute(path: '/', builder: SizedBox.shrink),
      const QRoute(path: '/home', builder: SizedBox.shrink),
      const QRoute(path: '/homepage', builder: SizedBox.shrink),
    ]);
    await delegate.setInitialRoutePath('/');
    await QR.to('/home');
    await QR.to('/homepage');
    await QR.switchTo('/home');
    expect(QR.rootNavigator.currentRoute.path, '/home');
  });

  test('pushName in a nested navigator finds a child named like its parent',
      () async {
    QR.reset();
    final delegate = QRouterDelegate([
      const QRoute(path: '/', builder: SizedBox.shrink),
      QRoute.withChild(
        path: '/shop',
        name: 'shop',
        builderChild: (r) => r,
        initRoute: '/start',
        children: [
          const QRoute(path: '/start', builder: SizedBox.shrink),
          const QRoute(
              path: '/shop-items', name: 'shopItems', builder: SizedBox.shrink),
        ],
      ),
    ]);
    await delegate.setInitialRoutePath('/');
    await QR.to('/shop');
    await QR.navigatorOf('shop').pushName('shopItems');
    expect(QR.navigatorOf('shop').currentRoute.name, 'shopItems');
  });

  test('Creating the same navigator twice at once returns one navigator',
      () async {
    QR.reset();
    QR.treeInfo.namePath['tabs'] = '/tabs';
    final routes = [const QRoute(path: '/', builder: SizedBox.shrink)];
    final first = QR.createRouterController('tabs', routes: routes);
    final second = QR.createRouterController('tabs', routes: routes);
    expect(identical(await first, await second), isTrue);
  });

  testWidgets('TemporaryQRouter disposed while creating does not stay active',
      (tester) async {
    QR.reset();
    final show = ValueNotifier(true);
    final entering = Completer<void>();
    await tester.pumpWidget(MaterialApp.router(
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: QRouterDelegate([
        QRoute(
          path: '/',
          builder: () => ValueListenableBuilder<bool>(
            valueListenable: show,
            builder: (_, visible, __) => visible
                ? TemporaryQRouter(
                    path: '/temp',
                    initPath: '/',
                    routes: [
                      QRoute(
                        path: '/',
                        middleware: [
                          QMiddlewareBuilder(
                              onEnterFunc: () => entering.future),
                        ],
                        builder: () => const Text('temp'),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ]),
    ));
    await tester.pump();

    show.value = false; // disposed while its first page is still entering
    await tester.pump();
    entering.complete();
    await tester.pumpAndSettle();

    expect(QR.activeNavigatorName, QRContext.rootRouterName);
    expect(QR.hasNavigator('/temp'), isFalse);
  });
}
