import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'routes.dart';

void main() {
  //Get.put(Database(), permanent: true);
  QR.settings.enableDebugLog = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp.router(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey.shade800,
      ),
      routeInformationParser: QRouteInformationParser(),
      routerDelegate: QRouterDelegate(AppRoutes().routes()));
}
