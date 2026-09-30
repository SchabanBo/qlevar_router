import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'routes/app_routes.dart';

void main() {
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
