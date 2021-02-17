import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'screens/dashboard/items.dart';
import 'screens/dashboard/orders.dart';
import 'screens/home.dart';
import 'screens/store/bottom_nav_bar.dart';
import 'screens/store/store.dart';
import 'screens/tests_screens/test_routes.dart';

class AppRoutes {
  // Dashboard
  static String home = 'Home';
  static String homeMain = 'Home Main';
  static String items = 'Items';

  // Items
  static String itemsMain = 'Items Main';
  static String itemsDetails = 'Items Details';

  // Store
  static String store = 'Store';

  //Other
  static String redirect = 'Redirect';

  final routes = <QRouteBase>[
    QRoute(
        name: home,
        path: '/home',
        page: (childRouter) => HomeScreen(childRouter),
        children: [
          QRoute(
              name: homeMain, path: '/', page: (child) => HomeScreenContent()),
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
          TestRoutes(),
        ]),
    QRoute(
        name: store,
        path: '/store',
        page: (childRouter) => StoreScreen(childRouter),
        children: [
          BottomNavigationBarExampleRoutes(),
        ]),
    QRoute(
        name: redirect,
        path: '/redirect',
        redirectGuard: (path) => '/home/items'),
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
                pageType: QRSlidePage(
                  transitionDurationmilliseconds: 500,
                  offset: Offset(1, 0),
                ),
                page: (child) => OrderDetails()),
          ]);
}
