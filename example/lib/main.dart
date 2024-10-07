import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'routes/app_routes.dart';
import 'services/auth_service.dart';
import 'services/storage_service.dart';

void main() {
  Get.lazyPut(() => AuthService());
  Get.lazyPut(() => StorageService());
  runApp(const QlevarApp());
}

class QlevarApp extends StatelessWidget {
  const QlevarApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRoutes = AppRoutes();
    appRoutes.setup();
    return MaterialApp.router(
      // Add the [QRouteInformationParser]
      routeInformationParser: const QRouteInformationParser(),
      // Add the [QRouterDelegate] with your routes
      routerDelegate: QRouterDelegate(
        appRoutes.routes,
        observers: [
          // Add your observers to the main navigator
          // to watch for all routes in all navigators use [QR.observer]
        ],
      ),
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      restorationScopeId: 'app',
    );
  }
}
