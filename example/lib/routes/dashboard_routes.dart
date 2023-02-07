import 'package:qlevar_router/qlevar_router.dart';

import '../pages/dashboard/dashboard_view.dart';
import '../pages/dashboard/home_view.dart';
import '../pages/dashboard/products_view.dart';
import '../pages/store/product_view.dart';
import '../pages/store/store_view.dart';
import '../pages/store/stores_view.dart';
import 'middleware/auth_middleware.dart';

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
    middleware: [
      // Set the auth middleware to allow only to the logged in users
      // to access the dashboard, the children routes will be protected
      // by this middleware too
      AuthMiddleware(),
    ],
    builderChild: (router) => DashboardView(router: router),
    children: [
      QRoute(
        path: '/home',
        name: dashboardHome,
        builder: () => HomeView(),
      ),
      QRoute(
        path: '/stores',
        name: dashboardStores,
        builder: () => StoresView(fromDashboard: true),
        children: [
          QRoute(
            path: '/:id',
            name: dashboardStoresId,
            pageType: const QCupertinoPage(),
            builder: () => StoreView(fromDashboard: true),
            children: [
              QRoute(
                path: '/product/:product_id',
                name: dashboardStoreIdProduct,
                pageType: const QMaterialPage(),
                builder: () => ProductView(),
              ),
            ],
          ),
        ],
      ),
      QRoute(
        path: '/products',
        name: dashboardProducts,
        builder: () => ProductsView(),
      ),
    ],
  );
}
