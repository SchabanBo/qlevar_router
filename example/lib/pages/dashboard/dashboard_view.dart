import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../services/auth_service.dart';
import '../welcome/debug_tools.dart';
import 'sidebar_section.dart';

class DashboardView extends StatelessWidget {
  final QRouter router;
  const DashboardView({required this.router, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(QR.currentRoute.meta);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Get.find<AuthService>().isAuth = false;
              QR.navigator.replaceAll('/');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.find<AuthService>().isAuth = false;
              QR.navigator.replaceAll('/login');
            },
          ),
        ],
      ),
      body: Row(
        children: <Widget>[
          const Expanded(child: SidebarSection()),
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width * 0.8,
            child: router,
          ),
        ],
      ),
      floatingActionButton: const DebugTools(),
    );
  }
}
