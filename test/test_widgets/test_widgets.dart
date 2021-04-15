import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class AppWarpper extends StatelessWidget {
  final List<QRoute> pages;
  final String? initPath;
  AppWarpper(this.pages, {this.initPath});

  @override
  Widget build(BuildContext context) {
    QR.settings.enableDebugLog = true;
    return MaterialApp.router(
        routeInformationParser: QRouteInformationParser(),
        routerDelegate: QRouterDelegate(pages, initPath: initPath));
  }
}

class WidgetOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container();
}

class WidgetTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container();
}

class WidgetThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container();
}

class TestDashboard extends StatelessWidget {
  final QRouter router;
  TestDashboard(this.router);
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
          centerTitle: true,
        ),
        body: Row(
          children: [
            Flexible(
                child: Container(
              child: Text('Sidebar'),
            )),
            Expanded(flex: 4, child: router)
          ],
        ),
      );
}
