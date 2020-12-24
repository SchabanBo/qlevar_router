import 'package:flutter/cupertino.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'screens/dashboard.dart';
import 'screens/items.dart';
import 'screens/orders.dart';
import 'screens/store.dart';

class AppRoutes {
  final routes = [
    QRoute(
        path: '/dashboard',
        page: (childRouter) => DashboardScreen(childRouter),
        children: [
          QRoute(path: '/', page: (child) => DashboardContent()),
          QRoute(
              path: '/items',
              page: (child) => ItemsScreen(child),
              children: [
                QRoute(path: '/', page: (child) => Container()),
                QRoute(path: '/details', page: (c) => ItemDetailsScreen())
              ]),
          QRoute(
              path: '/orders',
              page: (child) => OrdersScreen(child),
              children: [
                QRoute(path: '/', page: (child) => Container()),
                QRoute(path: '/:orderId', page: (child) => OrderDetails()),
              ]),
        ]),
    QRoute(path: '/store', page: (childRouter) => StoreScreen(childRouter)),
  ];
}
