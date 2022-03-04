import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../routes/mobile_routes.dart';

class MobileView extends StatefulWidget {
  final QRouter router;
  MobileView(this.router);
  @override
  _MobileViewState createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView> {
  @override
  void initState() {
    super.initState();
    // We need to add listener here so the bottomNavigationBar
    // get updated (the selected tab) when we navigate to new page
    widget.router.navigator.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Mobile'),
          centerTitle: true,
        ),
        body: widget.router,
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
          currentIndex: MobileRoutes.tabs
              .indexWhere((element) => element == widget.router.routeName),
          onTap: (v) => QR.toName(MobileRoutes.tabs[v]),
        ),
      );
}
