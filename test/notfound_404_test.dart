import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'helpers.dart';
import 'test_widgets/test_widgets.dart';

void main() {
  QR.settings.enableLog = false;
  final pages = [
    QRoute(path: '/', builder: () => Scaffold(body: WidgetOne())),
    QRoute(path: '/two', builder: () => Scaffold(body: WidgetTwo())),
    QRoute(path: '/three', builder: () => Scaffold(body: WidgetThree())),
  ];
  void printCurrentHistory() => print(QR.history.entries.map((e) => e.path));

  testWidgets('Check Not Found Route AKA 404', (tester) async {
    await tester.pumpWidget(AppWrapper(pages));
    await tester.pumpAndSettle();
    await QR.to('/something');
    expectedPath('/something');
    printCurrentHistory();
    await tester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsNothing);
    expect(find.byType(WidgetThree), findsNothing);
    expectedHistoryLength(2);
    await QR.to('/two');
    expectedPath('/two');
    printCurrentHistory();
    await tester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsOneWidget);
    expect(find.byType(WidgetThree), findsNothing);
    expectedHistoryLength(3);

    ///TODO :
    ///notfound can't be duplicated ?
    QR.to('/somethingwrong');
    printCurrentHistory();

    QR.to('/two');
    printCurrentHistory();

    // expectedPath('/two');
    // printCurrentHistory();
    // await tester.pumpAndSettle();
    // expect(find.byType(WidgetOne), findsNothing);
    // expect(find.byType(WidgetTwo), findsOneWidget);
    // expect(find.byType(WidgetThree), findsNothing);

    // /// notfound can't be duplicated ?
    // expectedHistoryLength(3);
  });
}
