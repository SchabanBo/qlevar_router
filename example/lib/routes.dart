import 'package:flutter/cupertino.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'screens/dashboard.dart';
import 'screens/items.dart';
import 'screens/orders.dart';
import 'screens/store.dart';

class AppRoutes {
  final routes = [
    QRoute(
        name: 'Dashboard',
        path: '/dashboard',
        page: (childRouter) => DashboardScreen(childRouter),
        children: [
          QRoute(
              name: 'Dashboard Main',
              path: '/',
              page: (child) => DashboardContent()),
          QRoute(
              name: 'Items',
              path: '/items',
              page: (child) => ItemsScreen(child),
              children: [
                QRoute(
                    name: 'Items Main',
                    path: '/',
                    page: (child) => Container()),
                QRoute(
                    name: 'Items Details',
                    path: '/details',
                    page: (c) => ItemDetailsScreen())
              ]),
          QRoute(
              name: 'Orders',
              path: '/orders',
              page: (child) => OrdersScreen(child),
              children: [
                QRoute(
                    name: 'Orders Main',
                    path: '/',
                    page: (child) => Container()),
                QRoute(
                    name: 'Order Details',
                    path: '/:orderId',
                    page: (child) => OrderDetails()),
              ]),
        ]),
    QRoute(path: '/store', page: (childRouter) => StoreScreen(childRouter)),
    QRoute(path: '/redirect', redirectGuard: (path) => '/dashboard/items'),  
  ];
}
