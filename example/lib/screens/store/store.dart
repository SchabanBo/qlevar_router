import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../helpers/date_time.dart';

class StoreScreen extends StatelessWidget {
  final QRouteChild child;
  StoreScreen(this.child);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Store $now'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              QR.to('/store/bottomNavigationBar');
            },
            child: Text(
              'BottomNavigationBar',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 15),
          Container(height: double.infinity, width: 2, color: Colors.white),
          const SizedBox(width: 15),
          TextButton(
            onPressed: () {
              QR.to('/dashboard');
            },
            child: Text(
              'Dashboard',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
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
