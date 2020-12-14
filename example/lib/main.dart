import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => QRouterApp(
        initRoute: '/dashboard',
        routes: AppRoutes().routes,
      );
}
