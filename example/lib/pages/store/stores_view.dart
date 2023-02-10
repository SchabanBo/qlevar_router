import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../routes/dashboard_routes.dart';
import '../../routes/store_routes.dart';
import '../../services/storage_service.dart';
import '../welcome/debug_tools.dart';

class StoresView extends StatelessWidget {
  final storage = Get.find<StorageService>();
  final bool fromDashboard;
  StoresView({Key? key, this.fromDashboard = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
      ),
      body: ListView(
        children: storage.stores
            .map(
              (e) => ListTile(
                title: Text(e.name),
                leading: const Icon(
                  Icons.store,
                  color: Colors.indigo,
                ),
                trailing: Text(e.products.length.toString()),
                // Navigate to the store page with the route name
                // and give the id of the store as parameter
                onTap: () => QR.toName(
                  fromDashboard
                      ? DashboardRoutes.dashboardStoresId
                      : StoreRoutes.storeId,
                  params: {'id': storage.stores.indexOf(e)},
                ),
              ),
            )
            .toList(),
      ),
      floatingActionButton: const DebugTools(),
    );
  }
}
