import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:qlevar_router/src/controllers/qrouter_controller.dart';
import 'package:qlevar_router/src/pages/page_creator.dart';
import 'package:qlevar_router/src/pages/qpage_internal.dart';
import 'package:qlevar_router/src/routes/qroute_internal.dart';

import 'helpers.dart';

Future<void> _pumpApp(WidgetTester tester, List<QRoute> routes) async {
  QR.reset();
  await tester.pumpWidget(MaterialApp.router(
    routeInformationParser: const QRouteInformationParser(),
    routerDelegate: QRouterDelegate(routes),
  ));
  await tester.pumpAndSettle();
}

Future<QPageInternal> _createPage(QPage pageType) {
  final route = QRouteInternal.from(
      QRoute(path: '/', builder: () => Container(), pageType: pageType), '/');
  return PageCreator(route).create();
}

void main() {
  testWidgets('A popup removed below the top is not taken as open',
      (tester) async {
    await _pumpApp(tester, [
      QRoute(path: '/', builder: () => const Text('home')),
      QRoute(
        path: '/sheet',
        pageType: const QModalBottomSheetPage(),
        builder: () => const Text('sheet'),
      ),
      QRoute(path: '/detail', builder: () => const Text('detail')),
    ]);
    await QR.to('/sheet');
    await tester.pumpAndSettle();
    await QR.to('/detail');
    await tester.pumpAndSettle();
    // removes detail and the sheet under it in one frame
    await QR.to('/');
    await tester.pumpAndSettle();
    final root = QR.rootNavigator as QRouterController;
    expect(root.observer.hasPopupRoute(), isFalse);

    await QR.to('/detail');
    await tester.pumpAndSettle();
    expect(await QR.back(), PopResult.Popped);
    await tester.pumpAndSettle();
    expectedPath('/');
  });

  testWidgets('Params with reserved characters survive toName', (tester) async {
    await _pumpApp(tester, [
      QRoute(path: '/', builder: () => const Text('home')),
      QRoute(path: '/search', name: 'search', builder: () => const Text('s')),
      QRoute(path: '/item/:id', name: 'item', builder: () => const Text('i')),
    ]);
    await QR.toName('search', params: {'q': 'a&b=c d', 'p': '50%'});
    expect(QR.params['q']!.value, 'a&b=c d');
    expect(QR.params['p']!.value, '50%');
    expect(QR.params['b'], isNull);
    expect(QR.isCurrentName('search', params: {'q': 'a&b=c d', 'p': '50%'}),
        isTrue);
    // refresh, browser back and the back fallback parse it again
    expect(Uri.parse(QR.currentPath).queryParameters,
        {'q': 'a&b=c d', 'p': '50%'});
    final restored =
        const QRouteInformationParser().restoreRouteInformation(QR.currentPath);
    expect(restored.uri.queryParameters, {'q': 'a&b=c d', 'p': '50%'});
    // params that give the same decoded path are not the same
    expect(QR.isCurrentName('search', params: {'q': 'a', 'b': 'c d'}), isFalse);

    await QR.toName('item', params: {'id': 'a b'});
    expect(QR.params['id']!.value, 'a b');
    expect(QR.isCurrentName('item', params: {'id': 'a b'}), isTrue);
  });

  test('An unknown route name throws a clear error', () {
    QR.reset();
    expect(() => QR.isCurrentName('nope'), throwsArgumentError);
  });

  testWidgets('A regex param has to match the whole segment', (tester) async {
    await _pumpApp(tester, [
      QRoute(path: '/', builder: () => const Text('home')),
      QRoute(path: '/user/:id([0-9]+)', builder: () => const Text('user')),
    ]);
    await QR.to('/user/12');
    await tester.pumpAndSettle();
    expect(find.text('user'), findsOneWidget);
    expect(QR.params['id']!.value, '12');

    await QR.to('/user/ab12');
    await tester.pumpAndSettle();
    expect(find.text('user'), findsNothing);
    expect(QR.currentRoute.path, QR.settings.notFoundPage.path);
  });

  test('onDelete is called only when the param is deleted', () {
    final params = QParams();
    var kept = 0, cleaned = 0;
    params.ensureExist('kept',
        initValue: 1, keepAlive: true, onDelete: () => kept++);
    params.ensureExist('cleaned',
        initValue: 1, cleanupAfter: 1, onDelete: () => cleaned++);

    params.updateParams(QParams());
    expect(params['cleaned'], isNotNull);
    expect(cleaned, 0);
    params.updateParams(QParams());
    params.updateParams(QParams());
    expect(params['cleaned'], isNull);
    expect(cleaned, 1);
    expect(params['kept'], isNotNull);
    expect(kept, 0);
  });

  testWidgets('A declarative route with a relative path works', (tester) async {
    await _pumpApp(tester, [
      QRoute(path: '/', builder: () => const Text('home')),
      QRoute.declarative(
        path: 'decl',
        declarativeBuilder: (key) => QDeclarative(
          routeKey: key,
          builder: () => [
            QDRoute(
                name: 'one',
                builder: () => const Text('one'),
                when: () => true),
          ],
        ),
      ),
    ]);
    await QR.to('/decl');
    await tester.pumpAndSettle();
    expect(find.text('one'), findsOneWidget);

    final controller =
        tester.state<QDeclarativeController>(find.byType(QDeclarative));
    for (var i = 0; i < 3; i++) {
      controller.update();
      await tester.pump();
    }
    // one page, one route, it does not grow on every build
    expect(controller.routes.length, 1);
    // no onPop, the declarative router can not pop
    expect(controller.pop(), isFalse);
  });

  test('Bottom sheet page gets its own barrierLabel', () async {
    QR.reset();
    final page = await _createPage(const QModalBottomSheetPage(
        barrierLabel: 'label', barrierOnTapHint: 'hint'));
    page as QModalBottomSheetPageInternal;
    expect(page.barrierLabel, 'label');
    expect(page.barrierOnTapHint, 'hint');
  });

  test('canPop and onPopInvoked reach the Flutter page', () async {
    QR.reset();
    void onPopInvoked(bool didPop, dynamic result) {}
    for (final type in [
      QMaterialPage(canPop: false, onPopInvoked: onPopInvoked),
      QCupertinoPage(canPop: false, onPopInvoked: onPopInvoked),
      QSlidePage(canPop: false, onPopInvoked: onPopInvoked),
      QModalBottomSheetPage(canPop: false, onPopInvoked: onPopInvoked),
    ]) {
      final page = await _createPage(type);
      expect(page.canPop, isFalse, reason: '$type');
      expect(page.onPopInvoked, onPopInvoked, reason: '$type');
    }
    expect((await _createPage(const QMaterialPage())).canPop, isTrue);
  });

  test('Every page gets its own key', () async {
    QR.reset();
    final keys = <LocalKey?>{};
    for (var i = 0; i < 100; i++) {
      keys.add((await _createPage(const QMaterialPage())).key);
    }
    expect(keys.length, 100);
  });

  test('A disposed delegate removes the root navigator', () async {
    QR.reset();
    final delegate =
        QRouterDelegate([QRoute(path: '/', builder: () => Container())]);
    await delegate.setInitialRoutePath('/');
    expect(QR.hasNavigator(QRContext.rootRouterName), isTrue);
    delegate.dispose();
    await pumpEventQueue();
    expect(QR.hasNavigator(QRContext.rootRouterName), isFalse);
  });

  test('An error creating the root navigator is not swallowed', () async {
    QR.reset();
    final delegate = QRouterDelegate([]);
    await expectLater(delegate.setInitialRoutePath('/'), throwsA(anything));
  });

  test('reset restores the defaults', () {
    QR.activeNavigatorName = 'other';
    QR.settings.autoRestoration = true;
    QR.history.allowDuplications = true;
    QR.reset();
    expect(QR.activeNavigatorName, QRContext.rootRouterName);
    expect(QR.settings.autoRestoration, isFalse);
    expect(QR.history.allowDuplications, isFalse);
  });

  test('parseRouteInformation answers synchronously', () {
    final result = const QRouteInformationParser()
        .parseRouteInformation(RouteInformation(uri: Uri.parse('/a?b=c')));
    expect(result, isA<SynchronousFuture<String>>());
  });
  testWidgets('toName replaces whole path params', (tester) async {
    await _pumpApp(tester, [
      QRoute(path: '/', builder: () => const Text('home')),
      QRoute(path: '/a/:id/:idType', name: 'a', builder: () => const Text('a')),
      QRoute(
          path: '/user/:id([0-9]+)',
          name: 'user',
          builder: () => const Text('user')),
    ]);
    await QR.toName('a', params: {'id': 5, 'idType': 'x'});
    expectedPath('/a/5/x');
    expect(QR.params['idType']!.value, 'x');

    await QR.toName('user', params: {'id': 12});
    expectedPath('/user/12');
  });

  testWidgets('QR.back respects the page canPop', (tester) async {
    final invoked = <bool>[];
    await _pumpApp(tester, [
      QRoute(path: '/', builder: () => const Text('home')),
      QRoute(
        path: '/checkout',
        pageType: QMaterialPage(
            canPop: false,
            onPopInvoked: (didPop, result) => invoked.add(didPop)),
        builder: () => const Text('checkout'),
      ),
    ]);
    await QR.to('/checkout');
    await tester.pumpAndSettle();
    expect(await QR.back(), PopResult.NotAllowedToPop);
    await tester.pumpAndSettle();
    expect(invoked, [false]);
    expectedPath('/checkout');
    expect(find.text('checkout'), findsOneWidget);
  });

  test('onDelete can still read its param', () {
    final params = QParams();
    Object? seen;
    params.ensureExist('ctrl',
        initValue: 'value', onDelete: () => seen = params['ctrl']?.value);
    params.updateParams(QParams());
    expect(seen, 'value');
    expect(params['ctrl'], isNull);
  });

  test('A delegate made after dispose gets a new root navigator', () async {
    QR.reset();
    final routes = [QRoute(path: '/', builder: () => Container())];
    final first = QRouterDelegate(routes);
    await first.setInitialRoutePath('/');
    final old = QR.rootNavigator;
    first.dispose();

    final second = QRouterDelegate(routes);
    await second.setInitialRoutePath('/');
    await pumpEventQueue();
    expect(QR.hasNavigator(QRContext.rootRouterName), isTrue);
    expect(identical(QR.rootNavigator, old), isFalse);
    expect((QR.rootNavigator as QRouterController).isDisposed, isFalse);
  });

  test('Disposing an old delegate after reset keeps the new one', () async {
    QR.reset();
    final routes = [QRoute(path: '/', builder: () => Container())];
    final old = QRouterDelegate(routes);
    await old.setInitialRoutePath('/');

    QR.reset();
    final current = QRouterDelegate(routes);
    await current.setInitialRoutePath('/');
    final root = QR.rootNavigator as QRouterController;
    old.dispose();
    await pumpEventQueue();
    expect(identical(QR.rootNavigator, root), isTrue);
    expect(root.isDisposed, isFalse);
  });

  test('A navigator created before reset is not added after it', () async {
    QR.reset();
    QR.treeInfo.namePath['nav'] = '/nav';
    final routes = [QRoute(path: '/', builder: () => Container())];
    final old = QR.createRouterController('nav', routes: routes);
    QR.reset();
    QR.treeInfo.namePath['nav'] = '/nav';
    final fresh = QR.createRouterController('nav', routes: routes);
    expect(identical(await old, await fresh), isFalse);
    expect(identical(QR.navigatorOf('nav'), await fresh), isTrue);
  });

  group('Declarative', () {
    late int step;
    late bool Function() canPopLast;

    Future<QDeclarativeController> pumpSteps(WidgetTester tester,
        {required bool withOnPop}) async {
      step = 0;
      canPopLast = () => true;
      await _pumpApp(tester, [
        QRoute(path: '/', builder: () => const Text('home')),
        QRoute.declarative(
          path: '/steps',
          declarativeBuilder: (key) => QDeclarative(
            routeKey: key,
            builder: () => [
              for (var i = 2; i >= 0; i--)
                QDRoute(
                  name: 's$i',
                  builder: () => Text('s$i'),
                  when: () => step == i,
                  pageType: QMaterialPage(canPop: i < 2 || canPopLast()),
                  onPop: withOnPop ? () => step-- > 0 : null,
                ),
            ],
          ),
        ),
      ]);
      await QR.to('/steps');
      await tester.pumpAndSettle();
      final controller =
          tester.state<QDeclarativeController>(find.byType(QDeclarative));
      for (var i = 1; i <= 2; i++) {
        step = i;
        controller.update();
        await tester.pumpAndSettle();
      }
      expect(controller.routes.length, 3);
      return controller;
    }

    Navigator navigatorOf(
            WidgetTester tester, QDeclarativeController controller) =>
        tester.widget<Navigator>(find.byWidgetPredicate(
            (w) => w is Navigator && w.key == controller.navKey));

    testWidgets('A page it removed itself is not popped again', (tester) async {
      final controller = await pumpSteps(tester, withOnPop: true);
      final top = navigatorOf(tester, controller).pages.last;
      expect(await QR.back(), PopResult.Popped);
      await tester.pumpAndSettle();
      expect(step, 1);
      // older Flutter versions report the pages removed from the list too
      navigatorOf(tester, controller).onDidRemovePage!(top);
      await tester.pumpAndSettle();
      expect(step, 1);
      expect(controller.routes.length, 2);
      expect(find.text('s1'), findsOneWidget);
    });

    testWidgets('A page Flutter popped without onPop leaves the stack',
        (tester) async {
      final controller = await pumpSteps(tester, withOnPop: false);
      controller.navKey.currentState!.pop();
      await tester.pumpAndSettle();
      expect(controller.routes.map((r) => r.name), ['s0', 's1']);
      expect(find.text('s1'), findsOneWidget);
    });

    testWidgets('An updated route updates its page', (tester) async {
      final controller = await pumpSteps(tester, withOnPop: true);
      final before = navigatorOf(tester, controller).pages.last;
      expect(before.canPop, isTrue);
      canPopLast = () => false;
      controller.update();
      await tester.pumpAndSettle();
      final after = navigatorOf(tester, controller).pages.last;
      expect(after.canPop, isFalse);
      // the same key, the page is updated and not pushed again
      expect(after.key, before.key);
    });
  });
}
