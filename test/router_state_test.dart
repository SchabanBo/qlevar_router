import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'helpers.dart';

const _tabs = [
  'mobile_stores',
  'mobile_products',
  'mobile_settings',
];

void main() {
  testWidgets('Router state', (tester) async {
    final routes = [
      QRoute(path: '/', builder: () => const Text('Hi')),
      QRoute.withChild(
          path: '/mobile',
          initRoute: '/stores',
          builderChild: (router) => _MobileView(router),
          children: [
            QRoute(
              path: '/stores',
              name: _tabs[0],
              pageType: const QFadePage(),
              builder: () => Text(_tabs[0]),
            ),
            QRoute(
              path: '/products',
              name: _tabs[1],
              pageType: const QFadePage(),
              builder: () => Text(_tabs[1]),
            ),
            QRoute(
              path: '/settings',
              name: _tabs[2],
              pageType: const QFadePage(),
              builder: () => Text(_tabs[2]),
            ),
          ])
    ];
    QR.reset();
    final delegate = QRouterDelegate(routes);
    await tester.pumpWidget(MaterialApp.router(
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: delegate,
    ));
    await tester.pumpAndSettle();
    expect(find.text('Hi'), findsOneWidget);
    expectedPath('/');
    await QR.to('/mobile');
    await tester.pumpAndSettle();
    expect(find.text('Mobile'), findsOneWidget);
    expect(find.text(_tabs[0]), findsOneWidget);
    expectedPath('/mobile/stores');
    await tester.tap(find.text('products'));
    await tester.pumpAndSettle();
    expect(find.text(_tabs[1]), findsOneWidget);
    expectedPath('/mobile/products');
    await tester.tap(find.text('settings'));
    await tester.pumpAndSettle();
    expect(find.text(_tabs[2]), findsOneWidget);
    expectedPath('/mobile/settings');
    QR.back();
    await tester.pumpAndSettle();
    expect(find.text(_tabs[1]), findsOneWidget);
    expectedPath('/mobile/products');
    await delegate.setNewRoutePath('/mobile/stores'); // send route from browser
    await tester.pumpAndSettle();
    expect(find.text('Mobile'), findsOneWidget);
    expect(find.text(_tabs[0]), findsOneWidget);
    expectedPath('/mobile/stores');
    await QR.to('/');
    await tester.pumpAndSettle();
    expect(find.text('Hi'), findsOneWidget);
    expectedPath('/');
  });
}

class _MobileView extends StatefulWidget {
  final QRouter router;
  const _MobileView(this.router);
  @override
  State<_MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends RouterState<_MobileView> {
  @override
  QRouter get router => widget.router;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile'),
        centerTitle: true,
      ),
      body: router,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'store',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'settings',
          )
        ],
        currentIndex: _tabs.indexWhere((e) => e == router.routeName),
        onTap: (v) => QR.toName(_tabs[v]),
      ),
    );
  }
}
