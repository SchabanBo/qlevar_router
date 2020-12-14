import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers/date_time.dart';

class DashboardScreen extends StatelessWidget {
  final QRouter childRouter;
  const DashboardScreen(this.childRouter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        title: Text('Dashboard $now'),
        centerTitle: true,
        actions: [
          FlatButton(
            onPressed: () {
              QR.to('/dashboard/items');
            },
            child: Text(
              'Items',
              style: TextStyle(color: Colors.white),
            ),
          ),
          FlatButton(
            onPressed: () {
              QR.to('/dashboard/orders');
            },
            child: Text(
              'Orders',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(height: double.infinity, width: 2, color: Colors.white),
          FlatButton(
            onPressed: () {
              QR.replace('/store');
            },
            child: Text(
              'Store',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: childRouter,
    );
  }
}

class DashboardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
      child: Text('This is the dashboard content.' +
          'Use the app bar to get to another page.'));
}
