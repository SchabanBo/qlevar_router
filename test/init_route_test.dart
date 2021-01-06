import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'test_widgets/test_widgets.dart';

void main() {
  testWidgets("init path when / is not given", (tester) async {
    await tester.pumpWidget(AppWarpperWithInit(
      [
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
      ],
      initRoute: '/tow',
    ));
    await tester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsOneWidget);
  });

  testWidgets("init path when / is given", (tester) async {
    await tester.pumpWidget(AppWarpperWithInit(
      [
        QRoute(
            path: '/one',
            page: (c) => Scaffold(
                  body: WidgetTwo(),
                ))
      ],
      initRoute: '/one',
    ));
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsOneWidget);
  });
}
