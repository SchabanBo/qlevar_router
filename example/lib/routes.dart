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
          QRoute(path: '/items', page: (child) => ItemsScreen()),
          QRoute(
              path: '/orders',
              page: (child) => OrdersScreen(child),
              children: [
                QRoute(path: '/', page: (child) =>  Container()),
                QRoute(path: '/2', page: (child) => OrderDetails()),
              ]),
        ]),
    QRoute(path: '/store', page: (childRouter) => StoreScreen(childRouter)),
  ];
}
