import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers.dart';

void main() {
  testWidgets('Issue 111', (widgetTester) async {
    QR.reset();
    await widgetTester.pumpWidget(const App());
    await widgetTester.pumpAndSettle();
    expectedPath('/info');
    await widgetTester.tap(find.text('Orders'));
    await widgetTester.pumpAndSettle();
    expectedPath('/orders');
    await widgetTester.tap(find.text('Items'));
    await widgetTester.pumpAndSettle();
    expectedPath('/items');
  });

  testWidgets('Issue 111 with tow nested routes', (widgetTester) async {
    QR.reset();
    await widgetTester.pumpWidget(const MyApp());
    await widgetTester.pumpAndSettle();
    expectedPath('/info');
    await widgetTester.tap(find.text('Orders'));
    await widgetTester.pumpAndSettle();
    expectedPath('/orders');
    await widgetTester.tap(find.text('Items'));
    await widgetTester.pumpAndSettle();
    expectedPath('/items');
    await widgetTester.tap(find.text('No'));
    await widgetTester.pumpAndSettle();
    expectedPath('/no');
    await widgetTester.tap(find.text('Dash Orders'));
    await widgetTester.pumpAndSettle();
    expectedPath('/dash/orders');
    await widgetTester.tap(find.text('Dash Items'));
    await widgetTester.pumpAndSettle();
    expectedPath('/dash/items');
  });
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routes = [
      QRoute.withChild(
          path: '/',
          builderChild: (c) => Dashboard(c),
          initRoute: '/info',
          children: [
            QRoute(
                path: '/info',
                pageType: const QFadePage(),
                builder: () => DashboardChild('Info', Colors.grey.shade900)),
            QRoute(
                path: '/orders',
                pageType: const QFadePage(),
                builder: () => DashboardChild('Orders', Colors.grey.shade700)),
            QRoute(
                path: '/items',
                pageType: const QFadePage(),
                builder: () => DashboardChild('Items', Colors.grey.shade500)),
          ]),
    ];
    return MaterialApp.router(
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: QRouterDelegate(routes),
      theme: ThemeData.dark(),
    );
  }
}

class Dashboard extends StatelessWidget {
  final QRouter router;
  const Dashboard(this.router, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          centerTitle: true,
        ),
        body: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: const Sidebar(),
            ),
            Expanded(flex: 4, child: router)
          ],
        ),
      );
}

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade800,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            title: const Text('Info'),
            onTap: () => QR.to('/info'),
          ),
          ListTile(
            title: const Text('Orders'),
            onTap: () => QR.to('/orders'),
          ),
          ListTile(
            title: const Text('Items'),
            onTap: () => QR.to('/items'),
          )
        ],
      ),
    );
  }
}

class DashboardChild extends StatelessWidget {
  final String name;
  final Color color;
  const DashboardChild(this.name, this.color, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text(name, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routes = [
      QRoute(
        path: '/no',
        builder: () => const Scaffold(body: DashSidebar()),
      ),
      QRoute.withChild(
          path: '/',
          builderChild: (c) => DashDashboard(c),
          initRoute: '/info',
          children: [
            QRoute(
                path: '/info',
                pageType: const QFadePage(),
                builder: () => DashboardChild('Info', Colors.grey.shade900)),
            QRoute(
                path: '/orders',
                pageType: const QFadePage(),
                builder: () => DashboardChild('Orders', Colors.grey.shade700)),
            QRoute(
                path: '/items',
                pageType: const QFadePage(),
                builder: () => DashboardChild('Items', Colors.grey.shade500)),
          ]),
      QRoute.withChild(
          path: '/dash',
          builderChild: (c) => DashDashboard(c),
          initRoute: '/info',
          children: [
            QRoute(
                path: '/info',
                pageType: const QFadePage(),
                builder: () => DashboardChild('Info', Colors.grey.shade900)),
            QRoute(
                path: '/orders',
                pageType: const QFadePage(),
                builder: () => DashboardChild('Orders', Colors.grey.shade700)),
            QRoute(
                path: '/items',
                pageType: const QFadePage(),
                builder: () => DashboardChild('Items', Colors.grey.shade500)),
          ]),
    ];
    return MaterialApp.router(
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: QRouterDelegate(routes),
      theme: ThemeData.dark(),
    );
  }
}

class DashDashboard extends StatelessWidget {
  final QRouter router;
  const DashDashboard(this.router, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          centerTitle: true,
        ),
        body: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: const DashSidebar(),
            ),
            Expanded(flex: 4, child: router)
          ],
        ),
      );
}

class DashSidebar extends StatelessWidget {
  const DashSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade800,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            title: const Text('Info'),
            onTap: () => QR.to('/info'),
          ),
          ListTile(
            title: const Text('Orders'),
            onTap: () => QR.to('/orders'),
          ),
          ListTile(
            title: const Text('Items'),
            onTap: () => QR.to('/items'),
          ),
          ListTile(
            title: const Text('No'),
            onTap: () => QR.to('/no'),
          ),
          ListTile(
            title: const Text('Dash Info'),
            onTap: () => QR.to('/dash/info'),
          ),
          ListTile(
            title: const Text('Dash Orders'),
            onTap: () => QR.to('/dash/orders'),
          ),
          ListTile(
            title: const Text('Dash Items'),
            onTap: () => QR.to('/dash/items'),
          ),
        ],
      ),
    );
  }
}
