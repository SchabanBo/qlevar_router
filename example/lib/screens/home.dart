import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers/date_time.dart';
import 'tests_screens/test_routes.dart';

class HomeScreen extends StatelessWidget {
  final QRouteChild routeChild;
  const HomeScreen(this.routeChild);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        bottomOpacity: 0.4,
        backgroundColor: Colors.green.shade800,
        title: InkWell(
            onTap: () => QR.to('/home', type: NavigationType.ReplaceAll),
            child: Text('Home $now')),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              QR.to('/home/items');
            },
            child: Text(
              'Items',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              QR.to('/home/orders');
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
        child: routeChild.childRouter,
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              ""
              'This is the Home Screen. '
              'Use the appbar to get to another page.'
              'Or test some features'
              "",
              style: TextStyle(color: Colors.white, fontSize: 35)),
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
              QR.toName(TestRoutes.testMultiSlash);
            },
            child: Text(TestRoutes.testMultiSlash),
          ),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: () {
              QR.toName(TestRoutes.testMultiComponentParent);
            },
            child: Text(TestRoutes.testMultiComponent),
          ),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: () {
              QR.toName(TestRoutes.testCanChildNavigate);
            },
            child: Text(TestRoutes.testCanChildNavigate),
          ),
        ],
      ));
}
