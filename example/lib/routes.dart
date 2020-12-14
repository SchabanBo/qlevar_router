import 'package:qlevar_router/qlevar_router.dart';

import 'screens/dashboard.dart';
import 'screens/items.dart';
import 'screens/store.dart';

class AppRoutes {
  final routes = [
    QRoute(
        path: '/dashboard',
        page: (childRouter) => DashboardScreen(childRouter),
        children: [
          QRoute(path: '/', page: (child) => DashboardContent()),
          QRoute(path: '/items', page: (child) => ItemsScreen()),
        ]),
    QRoute(path: '/store', page: (childRouter) => StoreScreen(childRouter)),
  ];
}
