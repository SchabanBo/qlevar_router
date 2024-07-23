import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../routes/store_routes.dart';
import 'node_widget.dart';

class SingleNavigatorRouterExample extends StatelessWidget {
  const SingleNavigatorRouterExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NodeWidget(
      name: 'Temporary QRouter Example',
      onPressed: () async {
        final storeRoutes = StoreRoutes().route;
        showModalBottomSheet(
          context: context,
          builder: (_) {
            return TemporaryQRouter(
              name: 'temp Store',
              path: '/temp-store',
              routes: [storeRoutes],
              initPath: storeRoutes.path,
            );
          },
        );
      },
    );
  }
}
