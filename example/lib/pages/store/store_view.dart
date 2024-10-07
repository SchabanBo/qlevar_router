import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../routes/dashboard_routes.dart';
import '../../routes/store_routes.dart';
import '../../services/storage_service.dart';
import '../welcome/debug_tools.dart';

class StoreView extends StatelessWidget {
  // receive the store id from the previous screen
  final storeId = QR.params['id']!.asInt!;

  late final store = Get.find<StorageService>().stores[storeId];

  final bool fromDashboard;
  StoreView({super.key, this.fromDashboard = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(store.name),
      ),
      body: ListView(
        children: store.products
            .map(
              (e) => ListTile(
                leading: const Icon(
                  Icons.gif_box,
                  color: Colors.red,
                ),
                title: Text(e),
                // Navigate to the product page with the route name
                // and give the id of the product as parameter
                // the store id will be saved as the next route is child of this
                onTap: () => QR.toName(
                  fromDashboard
                      ? DashboardRoutes.dashboardStoreIdProduct
                      : StoreRoutes.storeIdProduct,
                  params: {'product_id': store.products.indexOf(e)},
                ),
              ),
            )
            .toList(),
      ),
      floatingActionButton: const DebugTools(),
    );
  }
}
