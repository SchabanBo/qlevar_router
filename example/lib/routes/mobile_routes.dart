import 'package:qlevar_router/qlevar_router.dart';

import '../pages/mobile/mobile_products_view.dart';
import '../pages/mobile/mobile_settings_view.dart';
import '../pages/mobile/mobile_stores_view.dart';
import '../pages/mobile/mobile_view.dart';

class MobileRoutes {
  static const String mobile = 'mobileRoute';
  static const tabs = [
    'mobile_stores',
    'mobile_products',
    'mobile_settings',
  ];

  final route = QRoute.withChild(
      path: '/mobile',
      name: mobile,
      initRoute: '/stores',
      builderChild: (router) => MobileView(router),
      children: [
        QRoute(
          path: '/stores',
          name: tabs[0],
          pageType: QFadePage(),
          builder: () => MobileStoresView(),
        ),
        QRoute(
          path: '/products',
          name: tabs[1],
          pageType: QFadePage(),
          builder: () => MobileProductsView(),
        ),
        QRoute(
          path: '/settings',
          name: tabs[2],
          pageType: QFadePage(),
          builder: () => MobileSettingsView(),
        ),
      ]);
}
