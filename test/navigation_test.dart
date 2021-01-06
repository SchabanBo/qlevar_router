import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'test_widgets/test_widgets.dart';

void main() {
  testWidgets("simple path navigation", (tester) async {
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
    expect(find.byType(WidgetOne), findsOneWidget);
    QR.to('/tow');
    await tester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsOneWidget);
    QR.back();
    await tester.pumpAndSettle();
    expect(find.byType(WidgetTwo), findsNothing);
    expect(find.byType(WidgetOne), findsOneWidget);
  });

  testWidgets("simple named navigation", (tester) async {
    await tester.pumpWidget(AppWarpper([
      QRoute(
          path: '/',
          name: 'HomePage',
          page: (c) => Scaffold(
                body: WidgetOne(),
              )),
      QRoute(
          path: '/tow',
          name: 'MyPage',
          page: (c) => Scaffold(
                body: WidgetTwo(),
              ))
    ]));
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
}
