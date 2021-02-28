import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../helpers/date_time.dart';
import '../../helpers/qbutton.dart';
import 'navigation_mode.dart';

class StoreScreen extends StatelessWidget {
  final QRouteChild child;
  StoreScreen(this.child);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QR.getStackTreeWidget(),
              InkWell(
                  child: Text('Store $now'),
                  onTap: () => QR.replaceAll('/store')),
            ],
          ),
          centerTitle: true),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/store_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: child.childRouter,
      ),
    );
  }
}

class StoreInitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        children: [
          QButton('Home', () => QR.to('/home')),
          QButton('Bottom Navigation Bar',
              () => QR.to('/store/bottomNavigationBar')),
          QButton(NavigationModeRoutes.navigationMode,
              () => QR.toName(NavigationModeRoutes.navigationMode)),
        ],
      );
}
