import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers/date_time.dart';
import '../routes.dart';

class DashboardScreen extends StatelessWidget {
  final QRouter childRouter;
  const DashboardScreen(this.childRouter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        bottomOpacity: 0.4,
        backgroundColor: Colors.green.shade800,
        title: InkWell(
            onTap: () => QR.to('/dashboard'), child: Text('Dashboard $now')),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              QR.to('/dashboard/items');
            },
            child: Text(
              'Items',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              QR.to('/dashboard/orders');
            },
            child: Text(
              'Orders',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(height: double.infinity, width: 2, color: Colors.white),
          TextButton(
            onPressed: () {
              QR.to('/store');
            },
            child: Text(
              'Store',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/dashboard_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: childRouter,
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              ""
              'This is the dashboard content. '
              'Use the appbar to get to another page.'
              'Or'
              "",
              style: TextStyle(color: Colors.white, fontSize: 35)),
          Text('Or', style: TextStyle(color: Colors.white, fontSize: 35)),
          ElevatedButton(
            onPressed: () {
              QR.to('/somepage');
            },
            child: Text(
              'Test Not found page',
            ),
          ),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: () {
              QR.to('/redirect');
            },
            child: Text(
              'Test redirect, "Redirect to items page"',
            ),
          ),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: () {
              QR.toName(AppRoutes.testMultiSlash);
            },
            child: Text(AppRoutes.testMultiSlash),
          ),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: () {
              QR.toName(AppRoutes.testMultiComponent,
                  params: {'name': 'Max', 'number': 55});
            },
            child: Text(AppRoutes.testMultiComponent),
          ),
        ],
      ));
}
