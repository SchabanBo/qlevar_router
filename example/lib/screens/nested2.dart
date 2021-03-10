import 'package:example/helpers/qbutton.dart';
import 'package:example/routes.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LoginScreen',
              style: TextStyle(fontSize: 22),
            ),
            QButton("Login/Home Setting case", () => QR.to('/app')),
          ],
        ),
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'HomeScreen',
        style: TextStyle(fontSize: 22),
      ),
    );
  }
}

class SettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'SettingsScreen',
        style: TextStyle(fontSize: 22),
      ),
    );
  }
}

class AppScreen extends StatelessWidget {
  final QRouter router;
  const AppScreen(this.router);

  @override
  Widget build(BuildContext context) {
    var currentIdx = 0;
    return Scaffold(
        body: Row(
      children: [
        StreamBuilder<int>(
          stream: idxStream.stream,
          builder: (_, idx) {
            currentIdx = idx.data ?? 0;
            print('Current Index = ${idx.data ?? 0}');
            return NavigationRail(
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text('Settings'),
                ),
              ],
              selectedIndex: idx.data ?? 0,
              onDestinationSelected: (i) {
                if (currentIdx == i) {
                  return;
                }
                switch (i) {
                  case 0:
                    QR.toName(AppRoutes.home);
                    break;
                  case 1:
                    QR.toName(AppRoutes.settings);
                    break;
                  default:
                }
              },
            );
          },
        ),
        Expanded(child: router),
      ],
    ));
  }
}
