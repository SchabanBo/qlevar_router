import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'test_widgets/test_widgets.dart';

void main() {
  testWidgets("params test", (tester) async {
    await tester.pumpWidget(AppWarpper([
      QRoute(
          path: '/',
          page: (c) => Scaffold(
                body: WidgetOne(),
              )),
      QRoute(
          path: '/tow',
          page: (c) => Scaffold(
                body: WidgetTwo(),
              ))
    ]));
    QR.to('/tow?param1=45&param2=not');
    await tester.pumpAndSettle();
    expect(QR.currentRoute.fullPath, '/tow?param1=45&param2=not');
    expect(QR.params['param1'].asInt, 45);
    expect(QR.params['param2'].toString(), 'not');
    QR.back();
    await tester.pumpAndSettle();
    expect(QR.params.length, 0);
  });

  testWidgets("compoent test", (tester) async {
    await tester.pumpWidget(AppWarpper([
      QRoute(
          path: '/',
          page: (c) => Scaffold(
                body: WidgetOne(),
              )),
      QRoute(
          path: '/:userId',
          page: (c) => Scaffold(
                body: WidgetTwo(),
              ))
    ]));
    QR.to('/5');
    await tester.pumpAndSettle();
    expect(QR.currentRoute.fullPath, '/5');
    expect(QR.params['userId'].asInt, 5);
    QR.back();
    await tester.pumpAndSettle();
    expect(QR.params.length, 0);
  });

  testWidgets("nested compoent test", (tester) async {
    await tester.pumpWidget(AppWarpper([
      QRoute(
          path: '/',
          page: (c) => Scaffold(
                body: WidgetOne(),
              )),
      QRoute(
          path: '/user',
          page: (c) => Scaffold(
                body: Container(child: c),
              ),
          children: [
            QRoute(
                path: '/:userId',
                page: (c) => Container(child: c),
                children: [
                  QRoute(
                    path: '/info',
                    page: (c) => WidgetTwo(),
                  )
                ]),
          ]),
    ]));
    QR.to('/user/5/info');
    await tester.pumpAndSettle();
    expect(QR.currentRoute.fullPath, '/user/5/info');
    expect(QR.params['userId'].asInt, 5);
    expect(find.byType(WidgetTwo), findsOneWidget);
    expect(find.byType(WidgetOne), findsNothing);
    QR.back();
    await tester.pumpAndSettle();
    expect(QR.params.length, 0);
    expect(find.byType(WidgetOne), findsOneWidget);
    expect(find.byType(WidgetTwo), findsNothing);
  });

  testWidgets("multi compoent test", (tester) async {
    await tester.pumpWidget(AppWarpper([
      QRoute(
          path: '/',
          page: (c) => Scaffold(
                body: WidgetOne(),
              )),
      QRoute(
          path: '/user',
          page: (c) => Scaffold(
                body: Container(child: c),
              ),
          children: [
            QRoute(
                path: '/:userId',
                page: (c) => Container(child: c),
                children: [
                  QRoute(path: '/', page: (c) => WidgetOne()),
                  QRoute(
                      path: '/info',
                      page: (c) => Container(child: c),
                      children: [
                        QRoute(path: '/', page: (c) => WidgetOne()),
                        QRoute(path: '/:companyId', page: (c) => WidgetTwo())
                      ]),
                ]),
          ]),
    ]));
    QR.to('/user/5/info/7');
    await tester.pumpAndSettle();
    expect(QR.currentRoute.fullPath, '/user/5/info/7');
    expect(QR.params['userId'].asInt, 5);
    expect(QR.params['companyId'].asInt, 7);
    expect(find.byType(WidgetTwo), findsOneWidget);
    expect(find.byType(WidgetOne), findsNothing);
    QR.back();
    await tester.pumpAndSettle();
    expect(QR.params.length, 0);
    expect(find.byType(WidgetOne), findsOneWidget);
    expect(find.byType(WidgetTwo), findsNothing);
  });
}
