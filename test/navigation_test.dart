import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'test_widgets/test_widgets.dart';

void main() {
  final pages = AppWarpper([
    QRoute(
        path: '/',
        name: 'HomePage',
        page: (c) => Scaffold(
              body: WidgetOne(),
            )),
    QRoute(
        path: '/two',
        name: 'MyPage',
        page: (c) => Scaffold(
              body: WidgetTwo(),
            )),
    QRoute(
        path: '/three',
        name: 'Three',
        page: (c) => Scaffold(
              body: WidgetThree(),
            )),
  ]);

  testWidgets("simple path navigation", (tester) async {
    await tester.pumpWidget(pages);
    expect(find.byType(WidgetOne), findsOneWidget);
    QR.to('/two');
    await tester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsOneWidget);
    QR.back();
    await tester.pumpAndSettle();
    expect(find.byType(WidgetTwo), findsNothing);
    expect(find.byType(WidgetOne), findsOneWidget);
  });

  testWidgets("simple named navigation", (tester) async {
    await tester.pumpWidget(pages);
    expect(find.byType(WidgetOne), findsOneWidget);
    QR.toName('MyPage');
    await tester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsOneWidget);
    QR.back();
    await tester.pumpAndSettle();
    expect(find.byType(WidgetTwo), findsNothing);
    expect(find.byType(WidgetOne), findsOneWidget);
    QR.toName('MyPage');
    QR.toName('HomePage');
    await tester.pumpAndSettle();
    expect(find.byType(WidgetTwo), findsNothing);
    expect(find.byType(WidgetOne), findsOneWidget);
  });

  testWidgets("History", (tester) async {
    await tester.pumpWidget(pages);
    expect(find.byType(WidgetOne), findsOneWidget);
    QR.toName('MyPage');
    QR.toName('Three');
    QR.back();
    expect(QR.history.last, '/two');

    QR.toName('Three');
    QR.back();
    QR.back();
    expect(QR.history.last, '/');
  });

  testWidgets("Just url test", (tester) async {
    await tester.pumpWidget(pages);
    expect(find.byType(WidgetOne), findsOneWidget);
    QR.toName('MyPage', justUrl: true);
    await tester.pumpAndSettle();
    expect(QR.currentRoute.fullPath, '/two');
    expect(find.byType(WidgetTwo), findsOneWidget);
    //expect(find.byType(WidgetTwo), findsNothing);
  });
}
