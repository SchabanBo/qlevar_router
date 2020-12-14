import 'package:qlevar_router/qlevar_router.dart';

import 'screens/dashboard.dart';
import 'screens/store.dart';

class AppRoutes {
  final routes = [
    QRoute(path: '/dashboard', page: (child) => DashboardScreen()),
    QRoute(path: '/store', page: (child) => StoreScreen()),
  ];
}
