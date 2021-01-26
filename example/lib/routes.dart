import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'screens/dashboard.dart';
import 'screens/items.dart';
import 'screens/orders.dart';
import 'screens/store.dart';
import 'screens/tests_screens/multi_component_screen.dart';

class AppRoutes {
  // Dashboard
  static String dashboard = 'Dashboard';
  static String dashboardMain = 'Dashboard Main';
  static String items = 'Items';

  static String tests = 'Tests';

  // Items
  static String itemsMain = 'Items Main';
  static String itemsDetails = 'Items Details';

  // Store
  static String store = 'Store';

  // Tests
  static String testMultiSlash = 'Test Multi Slash';
  static String testMultiComponent = 'Test Multi Component';
  static String testMultiComponentChild = 'Test Multi Component Child';

  //Other
  static String redirect = 'Redirect';

  final routes = <QRouteBase>[
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
                    pageType: QRCupertinoPage(),
                    onInit: () => print('onInit Items Details'),
                    onDispose: () => print('onDispose Items Details'),
                    page: (c) => ItemDetailsScreen())
              ]),
          OrdersRoutes(),
          QRoute(
              name: tests,
              path: '/test',
              page: (child) => Container(child: child),
              children: [
                QRoute(
                    name: testMultiSlash,
                    path: '/multi/slash/path',
                    page: (child) => Center(
                            child: Text(
                          'It Works',
                          style: TextStyle(fontSize: 22, color: Colors.yellow),
                        ))),
                QRoute(
                    name: testMultiComponent,
                    path: '/:number/:name',
                    page: (child) => TestMultiComponent(child),
                    children: [
                      QRoute(
                          name: testMultiComponentChild,
                          path: '/:childNumber',
                          page: (child) => TestMultiComponentChild())
                    ]),
              ]),
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

class OrdersRoutes extends QRouteBuilder {
  static String orders = 'Orders';
  static String ordersMain = 'Orders Main';
  static String ordersDetails = 'Orders Details';

  @override
  QRoute createRoute() => QRoute(
          name: orders,
          path: '/orders',
          page: (child) => OrdersScreen(child),
          children: [
            QRoute(
                name: ordersDetails,
                path: '/:orderId',
                page: (child) => OrderDetails()),
          ]);
}
