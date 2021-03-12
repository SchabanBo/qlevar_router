import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'helpers.dart';
import 'test_widgets/test_widgets.dart';

void main() {
  QR.settings.enableDebugLog = false;
  QR.settings.enableLog = false;
  final pages = [
    QRoute(path: '/', builder: () => Scaffold(body: WidgetOne())),
    QRoute(path: '/two', builder: () => Scaffold(body: WidgetTwo())),
    QRoute(path: '/three', builder: () => Scaffold(body: WidgetThree())),
  ];

  testWidgets(
    'QNavigator - Push RemoveLast ReplaceAll',
    (tester) async {
      await tester.pumpWidget(AppWarpper(pages));

      QR.navigator.removeLast();
      QR.navigator.removeLast();

      expectedPath('/');
      expect(find.byType(WidgetOne), findsOneWidget);
      expect(find.byType(WidgetTwo), findsNothing);
      expect(find.byType(WidgetThree), findsNothing);
      expectedHistoryLength(1);

      QR.navigator.push('/two');
      QR.navigator.push('/three');

      expectedPath('/three');
      await tester.pumpAndSettle();
      expect(find.byType(WidgetOne), findsNothing);
      expect(find.byType(WidgetTwo), findsNothing);
      expect(find.byType(WidgetThree), findsOneWidget);
      expectedHistoryLength(3);

      QR.navigator.removeLast();

      expectedPath('/two');
      await tester.pumpAndSettle();
      expect(find.byType(WidgetOne), findsNothing);
      expect(find.byType(WidgetTwo), findsOneWidget);
      expect(find.byType(WidgetThree), findsNothing);
      printCurrentHistory();
      expectedHistoryLength(2);

      QR.navigator.push('/three');

      expectedPath('/three');
      expectedHistoryLength(3);
      printCurrentHistory();

      //Duplication test
      QR.navigator.push('/three');
      QR.navigator.push('/three');
      QR.navigator.push('/three');
      QR.navigator.push('/three');
      printCurrentHistory();
      expectedPath('/three');
      expectedHistoryLength(3);
      await tester.pumpAndSettle();
      expect(find.byType(WidgetOne), findsNothing);
      expect(find.byType(WidgetTwo), findsNothing);
      expect(find.byType(WidgetThree), findsOneWidget);

      QR.navigator.replaceAll('/two');

      printCurrentHistory();
      expectedPath('/two');
      expectedHistoryLength(1);
      await tester.pumpAndSettle();
      expect(find.byType(WidgetOne), findsNothing);
      expect(find.byType(WidgetTwo), findsOneWidget);
      expect(find.byType(WidgetThree), findsNothing);
    },
  );

  testWidgets('Init initPath', (tester) async {
    print('ــــــــــــــــــــــــــــــــــــــــ');
    QR.reset();
    await tester.pumpWidget(AppWarpper(pages, initPath: '/two'));
    printCurrentHistory();
    QR.navigator.removeLast();
    QR.navigator.removeLast();

    printCurrentHistory();
    expectedPath('/two');
    await tester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsOneWidget);
    expect(find.byType(WidgetThree), findsNothing);
    expectedHistoryLength(1);

    QR.navigator.push('/three');

    printCurrentHistory();
    expectedPath('/three');
    await tester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsNothing);
    expect(find.byType(WidgetThree), findsOneWidget);
    expectedHistoryLength(2);

    QR.navigator.replaceAll('/three');
    printCurrentHistory();

    expectedPath('/three');
    await tester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsNothing);
    expect(find.byType(WidgetThree), findsOneWidget);
    expectedHistoryLength(1);
  });

  testWidgets('replaceAll with default init route', (tester) async {
    print('ــــــــــــــــــــــــــــــــــــــــ');
    QR.reset();
    await tester.pumpWidget(AppWarpper(pages));
    printCurrentHistory();
    QR.navigator.replaceAll('/two');
    printCurrentHistory();
    expectedPath('/two');
    await tester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsOneWidget);
    expect(find.byType(WidgetThree), findsNothing);
    expectedHistoryLength(1);
  });

  testWidgets('replaceAll with different init route', (tester) async {
    print('ــــــــــــــــــــــــــــــــــــــــ');
    QR.reset();
    await tester.pumpWidget(AppWarpper(pages, initPath: '/three'));
    QR.navigator.replaceAll('/two');
    printCurrentHistory();
    expectedPath('/two');
    await tester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsOneWidget);
    expect(find.byType(WidgetThree), findsNothing);
    expectedHistoryLength(1);
  });
}
