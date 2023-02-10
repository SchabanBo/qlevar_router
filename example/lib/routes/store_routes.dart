import 'package:qlevar_router/qlevar_router.dart';

import '../pages/store/product_view.dart';
import '../pages/store/store_view.dart';
import '../pages/store/stores_view.dart' deferred as store_view;
import 'middleware/loader_middleware.dart';

class StoreRoutes {
  static const String store = 'store';
  static const String storeId = 'store_id';
  static const String storeIdProduct = 'store_id_product';

  final route = QRoute(
    path: '/store',
    name: store,
    // Set the route type to [QCupertinoPage] to use the Cupertino animation
    pageType: const QCupertinoPage(),
    middleware: [
      /// Use this [DeferredLoader] middleware to load this page
      /// only when user wants to go to it.
      DeferredLoader(store_view.loadLibrary),
    ],
    builder: () => store_view.StoresView(),
    children: [
      QRoute(
        path: '/:id',
        name: storeId,
        pageType: const QCupertinoPage(),
        builder: () => StoreView(),
        children: [
          QRoute(
            path: '/product/:product_id',
            name: storeIdProduct,
            pageType: const QMaterialPage(),
            builder: () => ProductView(),
          ),
        ],
      ),
    ],
  );
}
