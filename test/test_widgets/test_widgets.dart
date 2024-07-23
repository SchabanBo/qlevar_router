import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class AppWrapper extends StatelessWidget {
  final List<QRoute> pages;
  final String? initPath;
  const AppWrapper(this.pages, {this.initPath, super.key});

  @override
  Widget build(BuildContext context) {
    QR.settings.enableDebugLog = true;
    return MaterialApp.router(
        routeInformationParser: const QRouteInformationParser(),
        routerDelegate: QRouterDelegate(pages, initPath: initPath));
  }
}

class WidgetOne extends StatelessWidget {
  const WidgetOne({super.key});
  @override
  Widget build(BuildContext context) => Container();
}

class WidgetTwo extends StatelessWidget {
  const WidgetTwo({super.key});
  @override
  Widget build(BuildContext context) => Container();
}

class WidgetThree extends StatelessWidget {
  const WidgetThree({super.key});
  @override
  Widget build(BuildContext context) => Container();
}

class TestDashboard extends StatelessWidget {
  final QRouter router;
  const TestDashboard(this.router, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          centerTitle: true,
        ),
        body: Row(
          children: [
            const Flexible(child: Text('Sidebar')),
            Expanded(flex: 4, child: router)
          ],
        ),
      );
}
