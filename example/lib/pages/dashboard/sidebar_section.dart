import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../routes/dashboard_routes.dart';

class SidebarSection extends StatelessWidget {
  const SidebarSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const SizedBox(height: 10),
          const FlutterLogo(size: 75),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              QR.navigatorOf(DashboardRoutes.dashboard).switchTo('home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('Stores'),
            onTap: () {
              QR.navigatorOf(DashboardRoutes.dashboard).switchTo('stores');
            },
          ),
          ListTile(
            leading: const Icon(Icons.gif_box),
            title: const Text('Products'),
            onTap: () {
              QR.navigatorOf(DashboardRoutes.dashboard).switchTo('products');
            },
          )
        ],
      ),
    );
  }
}
