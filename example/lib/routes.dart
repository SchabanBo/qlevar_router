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
              onInit: () => print('onInit Items'),
              onDispose: () => print('onDispose Items'),
              page: (child) => ItemsScreen(child),
              children: [
                QRoute(
                    name: 'Items Main',
                    path: '/',
                    onInit: () => print('onInit Items Main'),
                    onDispose: () => print('onDispose Items Main'),
                    page: (child) => Container()),
                QRoute(
                    name: 'Items Details',
                    path: '/details',
                    onInit: () => print('onInit Items Details'),
                    onDispose: () => print('onDispose Items Details'),
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
