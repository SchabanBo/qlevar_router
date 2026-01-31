import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'helpers.dart';
import 'test_widgets/test_widgets.dart';

void main() {
  group('Params', () {
    test('Query Params', () async {
      QR.reset();
      final delegate = QRouterDelegate([
        QRoute(path: '/', builder: () => const Scaffold(body: WidgetOne())),
        QRoute(path: '/tow', builder: () => const Scaffold(body: WidgetTwo()))
      ]);
      await delegate.setInitialRoutePath('/');
      await QR.to('/tow?param1=45&param2=not');
      expect(QR.currentPath, '/tow?param1=45&param2=not');
      expect(QR.params['param1']!.asInt, 45);
      expect(QR.params['param2'].toString(), 'not');
      await QR.back();
      expect(QR.params.length, 0);
    });

    test('Hidden Params', () async {
      QR.reset();
      final delegate = QRouterDelegate([
        QRoute(path: '/', builder: () => const Scaffold(body: WidgetOne())),
        QRoute(path: '/tow', builder: () => const Scaffold(body: WidgetTwo()))
      ]);
      await delegate.setInitialRoutePath('/');
      QR.params.addAsHidden('param2', 'not');
      QR.params.addAsHidden('param3', true, cleanUpAfter: 2);
      await QR.to('/tow?param1=45');
      expect(QR.currentPath, '/tow?param1=45');
      expect(QR.params['param1']!.asInt, 45);
      expect(QR.params['param2'].toString(), 'not');
      expect(QR.params['param3']!.valueAs<bool>(), true);
      await QR.back();
      expect(QR.params.length, 1);
      await QR.to('/tow');
      expect(QR.params.length, 0);
    });

    test('Path Params', () async {
      QR.reset();
      final delegate = QRouterDelegate([
        QRoute(path: '/', builder: () => const Scaffold(body: WidgetOne())),
        QRoute(
            path: '/:userId', builder: () => const Scaffold(body: WidgetTwo()))
      ]);
      await delegate.setInitialRoutePath('/');
      for (var i = 0; i < 5; i++) {
        await QR.to('/$i');
        expect(QR.currentPath, '/$i');
        expect(QR.params['userId']!.asInt, i);
        await QR.back();
        expect(QR.params.length, 0);
      }
    });

    test('Nested Component Test', () async {
      QR.reset();
      final delegate = QRouterDelegate([
        QRoute(path: '/', builder: () => const Scaffold(body: WidgetOne())),
        QRoute(
            path: '/user',
            builder: () => Scaffold(body: Container()),
            children: [
              QRoute(path: '/:userId', builder: () => Container(), children: [
                QRoute(path: '/info', builder: () => const WidgetTwo()),
              ]),
            ]),
      ]);
      await delegate.setInitialRoutePath('/');
      await QR.to('/user/5/info');
      expect(QR.currentPath, '/user/5/info');
      expect(QR.params['userId']!.asInt, 5);
      await QR.back(); // /user/5
      expect(QR.currentPath, '/user/5');
      expect(QR.params['userId']!.asInt, 5);
      expect(QR.params.length, 1);
      await QR.back(); // /user
      expect(QR.currentPath, '/user');
      expect(QR.params.length, 0);
    });

    test('Multi Component Test', () async {
      QR.reset();
      final delegate = QRouterDelegate([
        QRoute(path: '/', builder: () => const Scaffold(body: WidgetOne())),
        QRoute(
            path: '/user',
            builder: () => Scaffold(body: Container()),
            children: [
              QRoute(path: '/:userId', builder: () => Container(), children: [
                QRoute(path: '/', builder: () => const WidgetOne()),
                QRoute(path: '/info', builder: () => Container(), children: [
                  QRoute(path: '/', builder: () => const WidgetOne()),
                  QRoute(path: '/:companyId', builder: () => const WidgetTwo())
                ]),
              ]),
            ]),
        QRoute(path: '/:categoryId/items', builder: () => Container())
      ]);
      await delegate.setInitialRoutePath('/');
      await QR.to('/user/5/info/7?hi=tt');
      expect(QR.currentPath, '/user/5/info/7?hi=tt');
      expect(QR.params['userId']!.asInt, 5);
      expect(QR.params['companyId']!.asInt, 7);
      expect(QR.params['hi']!.toString(), 'tt');
      await QR.back();
      expect(QR.currentPath, '/user/5/info');
      expect(QR.params['userId']!.asInt, 5);
      expect(QR.params.length, 1);
      await QR.back();
      expect(QR.currentPath, '/user/5');
      expect(QR.params.length, 1);
      await QR.back();
      expect(QR.currentPath, '/user');
      expect(QR.params.length, 0);
      await QR.back();
      expect(QR.currentPath, '/');
      expect(QR.params.length, 0);
    });

    test('Multi path Test', () async {
      QR.reset();
      final delegate = QRouterDelegate([
        QRoute(path: '/', builder: () => const Scaffold(body: WidgetOne())),
        QRoute(path: '/:categoryId/items', builder: () => Container())
      ]);
      await delegate.setInitialRoutePath('/');
      await QR.to('/4/items');
      expectedPath('/4/items');
      expect(QR.params['categoryId']!.asInt, 4);
    });

    testWidgets('Regex Component Test', (tester) async {
      QR.reset();
      await tester.pumpWidget(AppWrapper([
        QRoute(path: '/', builder: () => const Scaffold(body: WidgetOne())),
        QRoute.withChild(
            path: '/user',
            builderChild: (c) => Scaffold(body: Container(child: c)),
            children: [
              QRoute(
                  path: '/:id(^[0-9]\$)', builder: () => const Text('Case 1')),
              QRoute(
                  path: '/:id(^[0-9]+\$)', builder: () => const Text('Case 2')),
              QRoute(path: '/:id(a|b|c)', builder: () => const Text('Case 3'))
            ]),
      ]));

      await QR.to('/user/5');
      await tester.pumpAndSettle();
      expectedPath('/user/5');
      expect(QR.params['id']!.asInt, 5);
      expect(find.text('Case 1'), findsOneWidget);

      await QR.to('/user/665');
      await tester.pumpAndSettle();
      expectedPath('/user/665');
      expect(QR.params['id']!.asInt, 665);
      expect(find.text('Case 2'), findsOneWidget);

      await QR.to('/user/a');
      await tester.pumpAndSettle();
      expectedPath('/user/a');
      expect(QR.params['id']!.value.toString(), 'a');
      expect(find.text('Case 3'), findsOneWidget);

      await QR.to('/user/w');
      await tester.pumpAndSettle();
      expectedPath('/user/w');
      expect(QR.params['id'], null);
    });

    test('Test params with toName', () async {
      QR.reset();
      final delegate = QRouterDelegate([
        QRoute(
            path: '/',
            name: 'home',
            builder: () => const Scaffold(body: WidgetOne())),
        QRoute(
            path: '/:categoryId',
            name: 'component-params',
            builder: () => Container()),
        QRoute(
            path: '/params', name: 'path-params', builder: () => Container()),
      ]);

      await delegate.setInitialRoutePath('/');
      expect(0, QR.params.length);
      final testObj = TestObject('name', 15);

      // Test component params with toName
      await QR.toName('component-params', params: {
        'categoryId': testObj,
        'in': 3,
        'str': 'test',
        'bool': true
      });
      expect(4, QR.params.length);
      expectedPath('/TestObject{name: name, age: 15}?in=3&str=test&bool=true');
      expect(testObj, QR.params['categoryId']!.value!);
      expect(3, QR.params['in']!.value!);
      expect('test', QR.params['str']!.value!);
      expect(true, QR.params['bool']!.value!);
      // Reset
      await QR.toName('home');
      expect(0, QR.params.length);
      expectedPath('/');

      // Test path params with toName
      await QR.navigator.pushName('path-params',
          params: {'obj': testObj, 'in': 3, 'str': 'test', 'bool': true});
      expect(4, QR.params.length);
      expectedPath(
          '/params?obj=TestObject{name: name, age: 15}&in=3&str=test&bool=true');
      expect(testObj, QR.params['obj']!.value!);
      expect(3, QR.params['in']!.value!);
      expect('test', QR.params['str']!.value!);
      expect(true, QR.params['bool']!.value!);
    });

    testWidgets('Navigate to multi component param and back with QR.back',
        (tester) async {
      // The navigation should be:
      // to :/store/2
      // to :/store/1
      // to :/store/1/product/1
      // to :/store/1/product/2
      // to :/store/1/product/3
      // back: /store/1/product/2
      // back: /store/1/product/1
      // back: /store/1
      // back: /store/2

      QR.reset();
      final routes = [
        QRoute(path: '/', builder: () => const Scaffold(body: WidgetOne())),
        QRoute(
          path: '/store',
          builder: () => const Scaffold(body: Text('Stores')),
          children: [
            QRoute(
              path: '/:id',
              builder: () => Scaffold(
                body: Text('Store ${QR.params['id']!.value}'),
              ),
              children: [
                QRoute(
                  path: '/product/:product_id',
                  builder: () => Scaffold(
                    body: Text('Product ${QR.params['product_id']!.value}'),
                  ),
                ),
              ],
            ),
          ],
        )
      ];

      await tester.pumpWidget(AppWrapper(routes));
      await QR.to('/store/2');
      await tester.pumpAndSettle();
      expect(find.text('Store 2'), findsOneWidget);
      await QR.to('/store/1');
      await tester.pumpAndSettle();
      expect(find.text('Store 1'), findsOneWidget);
      await QR.to('/store/1/product/1');
      await tester.pumpAndSettle();
      expect(find.text('Product 1'), findsOneWidget);
      await QR.to('/store/1/product/2');
      await tester.pumpAndSettle();
      expect(find.text('Product 2'), findsOneWidget);
      await QR.to('/store/1/product/3');
      await tester.pumpAndSettle();
      expect(find.text('Product 3'), findsOneWidget);

      await QR.back();
      await tester.pumpAndSettle();
      expect(find.text('Product 2'), findsOneWidget);
      await QR.back();
      await tester.pumpAndSettle();
      expect(find.text('Product 1'), findsOneWidget);

      await QR.back();
      await tester.pumpAndSettle();
      expect(find.text('Store 1'), findsOneWidget);
      await QR.back();
      await tester.pumpAndSettle();
      expect(find.text('Store 2'), findsOneWidget);
      await QR.back();
      await tester.pumpAndSettle();
      expect(find.text('Stores'), findsOneWidget);
    });

    testWidgets(
        'Navigate to multi component param and back with appBar back button',
        (tester) async {
      // The navigation should be:
      // to :/store/2
      // to :/store/1
      // to :/store/1/product/1
      // to :/store/1/product/2
      // to :/store/1/product/3
      // back: /store/1/product/2
      // back: /store/1/product/1
      // back: /store/1
      // back: /store/2

      QR.reset();
      final routes = [
        QRoute(path: '/', builder: () => const Scaffold(body: WidgetOne())),
        QRoute(
          path: '/store',
          builder: () => const Scaffold(body: Text('Stores')),
          children: [
            QRoute(
              path: '/:id',
              builder: () => Scaffold(
                appBar: AppBar(),
                body: Text('Store ${QR.params['id']!.value}'),
              ),
              children: [
                QRoute(
                  path: '/product/:product_id',
                  builder: () => Scaffold(
                    appBar: AppBar(),
                    body: Text('Product ${QR.params['product_id']!.value}'),
                  ),
                ),
              ],
            ),
          ],
        )
      ];

      await tester.pumpWidget(AppWrapper(routes));
      await QR.to('/store/2');
      await tester.pumpAndSettle();
      expect(find.text('Store 2'), findsOneWidget);
      await QR.to('/store/1');
      await tester.pumpAndSettle();
      expect(find.text('Store 1'), findsOneWidget);
      await QR.to('/store/1/product/1');
      await tester.pumpAndSettle();
      expect(find.text('Product 1'), findsOneWidget);
      await QR.to('/store/1/product/2');
      await tester.pumpAndSettle();
      expect(find.text('Product 2'), findsOneWidget);
      await QR.to('/store/1/product/3');
      await tester.pumpAndSettle();
      expect(find.text('Product 3'), findsOneWidget);

      var backButton = find.byTooltip('Back');
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();
      expect(find.text('Product 2'), findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();
      expect(find.text('Product 1'), findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();
      expect(find.text('Store 1'), findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();
      expect(find.text('Store 2'), findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();
      expect(find.text('Stores'), findsOneWidget);
    });

    testWidgets(
        'Navigate to multi component param and back with browser back button',
        (tester) async {
      // The navigation should be:
      // to :/store/2
      // to :/store/1
      // to :/store/1/product/1
      // to :/store/1/product/2
      // to :/store/1/product/3
      // back: /store/1/product/2
      // back: /store/1/product/1
      // back: /store/1
      // back: /store/2

      QR.reset();
      final routes = [
        QRoute(path: '/', builder: () => const Scaffold(body: WidgetOne())),
        QRoute(
          path: '/store',
          builder: () => const Scaffold(body: Text('Stores')),
          children: [
            QRoute(
              path: '/:id',
              builder: () => Scaffold(
                appBar: AppBar(),
                body: Text('Store ${QR.params['id']!.value}'),
              ),
              children: [
                QRoute(
                  path: '/product/:product_id',
                  builder: () => Scaffold(
                    appBar: AppBar(),
                    body: Text('Product ${QR.params['product_id']!.value}'),
                  ),
                ),
              ],
            ),
          ],
        )
      ];
      final router = QRouterDelegate(routes);
      await tester.pumpWidget(
        MaterialApp.router(
          routeInformationParser: const QRouteInformationParser(),
          routerDelegate: router,
        ),
      );

      await QR.to('/store/2');
      await tester.pumpAndSettle();
      expect(find.text('Store 2'), findsOneWidget);
      await QR.to('/store/1');
      await tester.pumpAndSettle();
      expect(find.text('Store 1'), findsOneWidget);
      await QR.to('/store/1/product/1');
      await tester.pumpAndSettle();
      expect(find.text('Product 1'), findsOneWidget);
      await QR.to('/store/1/product/2');
      await tester.pumpAndSettle();
      expect(find.text('Product 2'), findsOneWidget);
      await QR.to('/store/1/product/3');
      await tester.pumpAndSettle();
      expect(find.text('Product 3'), findsOneWidget);

      router.setNewRoutePath('/store/1/product/2');
      await tester.pumpAndSettle();
      expect(find.text('Product 2'), findsOneWidget);

      router.setNewRoutePath('/store/1/product/1');
      await tester.pumpAndSettle();
      expect(find.text('Product 1'), findsOneWidget);

      router.setNewRoutePath('/store/1');
      await tester.pumpAndSettle();
      expect(find.text('Store 1'), findsOneWidget);

      router.setNewRoutePath('/store/2');
      await tester.pumpAndSettle();
      expect(find.text('Store 2'), findsOneWidget);

      router.setNewRoutePath('/store');
      await tester.pumpAndSettle();
      expect(find.text('Stores'), findsOneWidget);
    });
  });

  test('Deep link path test', () async {
    QR.reset();
    final delegate = QRouterDelegate([
      QRoute(path: '/', builder: () => const Scaffold(body: WidgetOne())),
      QRoute(path: '/info', builder: () => const SizedBox()),
      QRoute(path: '/cart/:id', builder: () => const SizedBox()),
      QRoute(path: '/order', builder: () => const SizedBox()),
    ]);
    await delegate.setInitialRoutePath('/order?id=55');
    expect(QR.currentPath, '/order?id=55');
    expect(QR.params['id']!.toString(), '55');
    await delegate.setNewRoutePath('/cart/5');
    expect(QR.currentPath, '/cart/5');
    expect(QR.params['id']!.asInt, 5);
    const url = "https://www.example.com/#";
    await delegate.setNewRoutePath('$url/order?id=56');
    expect(QR.currentPath, '/order?id=56');
    expect(QR.params['id']!.toString(), '56');
    await delegate.setNewRoutePath('$url/cart/4');
    expect(QR.currentPath, '/cart/4');
    expect(QR.params['id']!.asInt, 4);
  });

  test('ensureExist / updateParam', () async {
    QR.reset();
    int? oldValue;
    int? newValue;
    bool deleted = false;

    QR.params.ensureExist(
      'TestParam',
      initValue: 5,
      onChange: (o, n) {
        oldValue = o as int;
        newValue = n as int;
      },
      onDelete: () {
        deleted = true;
      },
      cleanupAfter: 2, // one for the '/' path and one for the '/info' path
    );

    final delegate = QRouterDelegate([
      QRoute(path: '/', builder: () => const Scaffold(body: WidgetOne())),
      QRoute(path: '/info', builder: () => const WidgetTwo())
    ]);
    await delegate.setInitialRoutePath('/');
    expect(QR.params['TestParam']!.asInt, 5);
    await QR.to('/info');
    expect(QR.currentPath, '/info');
    expect(QR.params.isNotEmpty, true);
    expect(QR.params['TestParam']!.asInt, 5);
    QR.params.updateParam('TestParam', 6);

    expect(QR.params['TestParam']!.valueAs<int>(), 6);
    expect(oldValue, 5);
    expect(newValue, 6);

    await QR.to('/');
    expect(QR.params['TestParam'], null);
    expect(QR.params.isEmpty, true);
    expect(deleted, true);
  });
}

class TestObject {
  final String name;
  final int age;
  TestObject(this.name, this.age);

  @override
  String toString() {
    return 'TestObject{name: $name, age: $age}';
  }
}
