import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class AppWarpper extends StatelessWidget {
  final List<QRoute> pages;
  AppWarpper(this.pages);

  @override
  Widget build(BuildContext context) => MaterialApp.router(
      routeInformationParser: QR.routeParser(),
      routerDelegate: QR.router(pages));
}

class AppWarpperWithInit extends StatelessWidget {
  final List<QRoute> pages;
  final String initRoute;
  AppWarpperWithInit(this.pages, {this.initRoute});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
      routeInformationParser: QR.routeParser(),
      routeInformationProvider:
          QRouteInformationProvider(initialRoute: initRoute),
      routerDelegate: QR.router(pages, initRoute: initRoute));
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
