import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../routes/mobile_routes.dart';

class MobileView extends StatefulWidget {
  final QRouter router;
  MobileView(this.router);
  @override
  _MobileViewState createState() => _MobileViewState();
}

class _MobileViewState extends RouterState<MobileView> {
  @override
  QRouter get router => widget.router;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile'),
        centerTitle: true,
      ),
      body: router,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'store',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          )
        ],
        currentIndex:
            MobileRoutes.tabs.indexWhere((e) => e == router.routeName),
        onTap: (v) => QR.toName(MobileRoutes.tabs[v]),
      ),
    );
  }
}
