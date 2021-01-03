import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'screens/dashboard.dart';
import 'screens/items.dart';
import 'screens/orders.dart';
import 'screens/store.dart';

class AppRoutes {
  // Dashboard
  static String dashboard = 'Dashboard';
  static String dashboardMain = 'Dashboard Main';
  static String items = 'Items';
  static String orders = 'Orders';
  static String testMultiSlash = 'Test Multi Slash';

  // Items
  static String itemsMain = 'Items Main';
  static String itemsDetails = 'Items Details';

  // Oorders
  static String ordersMain = 'Orders Main';
  static String ordersDetails = 'Orders Details';

  // Store
  static String store = 'Store';

  //Other
  static String redirect = 'Redirect';

  final routes = [
    QRoute(
        name: dashboard,
        path: '/dashboard',
        page: (childRouter) => DashboardScreen(childRouter),
        children: [
          QRoute(
              name: dashboardMain,
              path: '/',
              page: (child) => DashboardContent()),
          QRoute(
              name: items,
              path: '/items',
              onInit: () => print('onInit Items'),
              onDispose: () => print('onDispose Items'),
              page: (child) => ItemsScreen(child),
              children: [
                QRoute(
                    name: itemsMain,
                    path: '/',
                    onInit: () => print('onInit Items Main'),
                    onDispose: () => print('onDispose Items Main'),
                    page: (child) => Container()),
                QRoute(
                    name: itemsDetails,
                    path: '/details',
                    onInit: () => print('onInit Items Details'),
                    onDispose: () => print('onDispose Items Details'),
                    page: (c) => ItemDetailsScreen())
              ]),
          QRoute(
              name: orders,
              path: '/orders',
              page: (child) => OrdersScreen(child),
              children: [
                QRoute(
                    name: ordersMain, path: '/', page: (child) => Container()),
                QRoute(
                    name: ordersDetails,
                    path: '/:orderId',
                    page: (child) => OrderDetails()),
              ]),
          QRoute(
              name: testMultiSlash,
              path: '/test/multi/slash',
              page: (child) => Center(
                      child: Text(
                    'It Works',
                    style: TextStyle(fontSize: 22, color: Colors.yellow),
                  ))),
        ]),
    QRoute(
        name: store,
        path: '/store',
        page: (childRouter) => StoreScreen(childRouter)),
    QRoute(
        name: redirect,
        path: '/redirect',
        redirectGuard: (path) => '/dashboard/items'),
  ];
}
