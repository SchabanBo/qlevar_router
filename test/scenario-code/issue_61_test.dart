import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers.dart';
import '../test_widgets/test_widgets.dart';

void main() {
  final routes = [
    QRoute(
      path: '/',
      builder: () => const WidgetOne(),
    ),
    DashboardRoutes().route,
  ];

  Future<void> navigateUntilProduct(WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(AppWrapper(routes));
    await widgetTester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsOneWidget);
    expectedPath('/');
    await QR.to('/dashboard');
    await widgetTester.pumpAndSettle();
    expect(find.byType(DashboardView), findsOneWidget);
    expectedPath('/dashboard/home');
    // tab store in sidebar
    await widgetTester.tap(find.text('Stores'));
    await widgetTester.pumpAndSettle();
    expect(find.byType(StoreWidget), findsOneWidget);
    expect(find.text('Store id: -1'), findsOneWidget);
    expectedPath('/dashboard/stores');
    await QR.to('/dashboard/stores/1');
    await widgetTester.pumpAndSettle();
    expect(find.byType(StoreWidget), findsOneWidget);
    expect(find.text('Store id: 1'), findsOneWidget);
    expectedPath('/dashboard/stores/1');
    // tab to product 1
    await widgetTester.tap(find.text('Go to product1 1'));
    await widgetTester.pumpAndSettle();
    expect(find.text('Store id: 1'), findsOneWidget);
    expect(find.text('Product id: 1'), findsOneWidget);
    expectedPath('/dashboard/stores/1/product/1');
  }

  testWidgets('issue 61 - without saving state', (widgetTester) async {
    shouldSaveState = false;
    QR.reset();
    await navigateUntilProduct(widgetTester);
    // tab to home
    await widgetTester.tap(find.text('Home'));
    await widgetTester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsOneWidget);
    expectedPath('/dashboard/home');
    // tab to stores
    await widgetTester.tap(find.text('Stores'));
    await widgetTester.pumpAndSettle();
    expect(find.byType(StoreWidget), findsOneWidget);
    expect(find.text('Store id: -1'), findsOneWidget);
    expectedPath('/dashboard/stores');
    await QR.back();
    await widgetTester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsOneWidget);
    expectedPath('/dashboard/home');
  });

  testWidgets('issue 61-  with saving state', (widgetTester) async {
    /// Test when state is saved
    shouldSaveState = true;
    QR.reset();
    await navigateUntilProduct(widgetTester);
    // tab to home
    await widgetTester.tap(find.text('Home'));
    await widgetTester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsOneWidget);
    expectedPath('/dashboard/home');
    // tab to stores
    await widgetTester.tap(find.text('Stores'));
    await widgetTester.pumpAndSettle();
    expect(find.text('Store id: 1'), findsOneWidget);
    expect(find.text('Product id: 1'), findsOneWidget);
    expectedPath('/dashboard/stores/1/product/1');
    await QR.back();
    await widgetTester.pumpAndSettle();
    expect(find.byType(StoreWidget), findsOneWidget);
    expect(find.text('Store id: 1'), findsOneWidget);
    expectedPath('/dashboard/stores/1');
    await QR.back();
    await widgetTester.pumpAndSettle();
    expect(find.byType(StoreWidget), findsOneWidget);
    expect(find.text('Store id: -1'), findsOneWidget);
    expectedPath('/dashboard/stores');
    await QR.back();
    await widgetTester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsOneWidget);
    expectedPath('/dashboard/home');
  });
}

class DashboardRoutes {
  static const String dashboard = 'dashboard';
  static const String dashboardHome = 'dashboard_home';
  static const String dashboardStores = 'dashboard_stores';
  static const String dashboardStoresId = 'dashboard_stores_id';
  static const String dashboardStoreIdProduct = 'dashboard_store_id_product';
  static const String dashboardProducts = 'dashboard_products';

  final route = QRoute.withChild(
    path: '/dashboard',
    name: dashboard,
    initRoute: '/home',
    builderChild: (router) => DashboardView(router: router),
    children: [
      QRoute(
        path: '/home',
        name: dashboardHome,
        builder: () => const WidgetOne(),
      ),
      QRoute(
        path: '/stores',
        name: dashboardStores,
        builder: () => const StoreWidget(),
        children: [
          QRoute(
            path: '/:id',
            name: dashboardStoresId,
            pageType: const QCupertinoPage(),
            builder: () => const StoreWidget(),
            children: [
              QRoute(
                path: '/product/:product_id',
                name: dashboardStoreIdProduct,
                pageType: const QMaterialPage(),
                builder: () {
                  final storeId = QR.params['id']!;
                  final productId = QR.params['product_id']!;
                  return Column(
                    children: [
                      Text('Store id: $storeId'),
                      Text('Product id: $productId'),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
      QRoute(
        path: '/products',
        name: dashboardProducts,
        builder: () => const WidgetTwo(),
      ),
    ],
  );
}

class StoreWidget extends StatelessWidget {
  const StoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storeId = QR.params['id'] ?? '-1';
    return Column(
      children: [
        Text('Store id: $storeId'),
        ElevatedButton(
          onPressed: () {
            QR.to('dashboard/stores/$storeId/product/1');
          },
          child: const Text('Go to product1 1'),
        ),
      ],
    );
  }
}

class DashboardView extends StatelessWidget {
  final QRouter router;
  const DashboardView({required this.router, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          const Expanded(child: SidebarSection()),
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width * 0.8,
            child: router,
          ),
        ],
      ),
    );
  }
}

var shouldSaveState = false;

class SidebarSection extends StatelessWidget {
  const SidebarSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const SizedBox(height: 10),
          const FlutterLogo(size: 75),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              if (shouldSaveState) {
                QR.navigatorOf(DashboardRoutes.dashboard).switchTo('home');
              } else {
                QR.to('dashboard/home');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('Stores'),
            onTap: () {
              if (shouldSaveState) {
                QR.navigatorOf(DashboardRoutes.dashboard).switchTo('stores');
              } else {
                QR.to('dashboard/stores');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.gif_box),
            title: const Text('Products'),
            onTap: () {
              if (shouldSaveState) {
                QR.navigatorOf(DashboardRoutes.dashboard).switchTo('products');
              } else {
                QR.to('dashboard/products');
              }
            },
          )
        ],
      ),
    );
  }
}
