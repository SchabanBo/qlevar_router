import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers/qbutton.dart';
import '../routes.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('LoginScreen', style: TextStyle(fontSize: 22)),
            QButton("Login/Home Setting case", () => QR.to('/app')),
          ],
        ),
      ),
    );
  }
}

class AppScreen extends StatefulWidget {
  final QRouter router;
  AppScreen(this.router);
  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  @override
  void initState() {
    widget.router.navigator.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: widget.router),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings')
        ],
        currentIndex: widget.router.routeName == AppRoutes.home ? 0 : 1,
        onTap: (v) => QR.toName(v == 0 ? AppRoutes.home : AppRoutes.settings),
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Center(child: Text('HomeScreen', style: TextStyle(fontSize: 22)));
}

class SettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Center(child: Text('SettingsScreen', style: TextStyle(fontSize: 22)));
}
