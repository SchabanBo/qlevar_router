import 'package:get/get.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../pages/declarative/declarative_view.dart';
import '../pages/login/login_view.dart';
import '../pages/not_found/not_found_view.dart';
import '../pages/welcome/welcome_view.dart';
import '../services/auth_service.dart';
import 'dashboard_routes.dart';
import 'editabel_routes.dart';
import 'middleware_routes.dart';
import 'mobile_routes.dart';
import 'store_routes.dart';

class AppRoutes {
  static const String root = 'root';
  static const String login = 'login';

  void setup() {
    // enable debug logging for all routes
    QR.settings.enableDebugLog = true;

    // you can set your own logger
    // QR.settings.logger = (String message) {
    //   print(message);
    // };

    // Set up the not found route in your app.
    // this route (path and view) will be used when the user navigates to a
    // route that does not exist.
    QR.settings.notFoundPage = QRoute(
      path: 'path',
      builder: () => NotFoundView(),
    );

    // add observers to the app
    // this observer will be called when the user navigates to new route
    QR.observer.onNavigate.add((path, route) async {
      print('Observer: Navigating to $path');
    });

    // this observer will be called when the popped out from a route
    QR.observer.onPop.add((path, route) async {
      print('Observer: popping out from $path');
    });

    // create initial route that will be used when the app is started
    // or when route is waiting for response
    //QR.settings.iniPage = InitPage();

    // Change the page transition for all routes in your app.
    QR.settings.pagesType = QFadePage();
  }

  final routes = <QRoute>[
    QRoute(
      // this will define how to find this route with [QR.to]
      path: '/',
      // this will define how to find this route with [QR.toName]
      name: root,
      // The page to show when this route is called
      builder: () => WelcomeView(),
    ),
    QRoute(
      path: '/login',
      name: login,
      // What action to perform when this route is called
      // can be defined with classed extends [QMiddleware]
      // or define new one with [QMiddlewareBuilder]
      middleware: [
        QMiddlewareBuilder(
          redirectGuardFunc: (_) async {
            // if user is already logged in, redirect to dashboard
            if (Get.find<AuthService>().isAuth) {
              return '/dashboard';
            }
            return null;
          },
        )
      ],
      builder: () => LoginView(),
    ),
    // Split your routes definitions into groups and call them here
    StoreRoutes().route, // Add the store routes
    DashboardRoutes().route, // Add the dashboard routes
    MobileRoutes().route, // Add the mobile routes
    MiddlewareRoutes().route, // Add the middleware routes
    EditableRoutes().route, // Add the editable routes
    // Add declarative routes
    QRoute.declarative(
      path: '/declarative',
      declarativeBuilder: (k) => DeclarativePage(k),
    ),
  ];
}
