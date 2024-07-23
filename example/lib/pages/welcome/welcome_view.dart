import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../routes/dashboard_routes.dart';
import '../../routes/mobile_routes.dart';
import '../../routes/store_routes.dart';
import 'debug_tools.dart';
import 'node_widget.dart';
import 'temporary_router_widget.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Qlevar Router'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NodeWidget(
              name: 'Store',
              // Navigate with route name
              onPressed: () => QR.toName(StoreRoutes.store),
            ),
            NodeWidget(
              name: 'Dashboard',
              onPressed: () => QR.toName(DashboardRoutes.dashboard),
            ),
            NodeWidget(
              name: 'Mobile',
              onPressed: () => QR.toName(MobileRoutes.mobile),
            ),
            NodeWidget(
              name: 'Middleware',
              // Navigate with route path
              onPressed: () => QR.to('/parent'),
            ),
            NodeWidget(
              name: 'Await routes results',
              onPressed: () => QR.to('/await-result'),
            ),
            NodeWidget(
              name: 'Declarative',
              onPressed: () => QR.to('/declarative'),
            ),
            NodeWidget(
              name: 'Editable Routes',
              onPressed: () => QR.to('/editable-routes'),
            ),
            const SingleNavigatorRouterExample(),
          ],
        ),
      ),
      floatingActionButton: const DebugTools(),
    );
  }
}
