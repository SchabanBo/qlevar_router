import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'test_widgets/test_widgets.dart';

void main() {
  QR.settings.enableDebugLog = false;
  QR.settings.enableLog = false;
  final pages = [
    QRoute(path: '/', builder: () => Scaffold(body: WidgetOne())),
    QRoute(path: '/two', builder: () => Scaffold(body: WidgetTwo())),
    QRoute(path: '/three', builder: () => Scaffold(body: WidgetThree())),
  ];
  void printCurrentHistory() => print(QR.history.entries.map((e) => e.path));
  void expectedPath(String path) => expect(QR.curremtPath, path);
  void expectedStackLength(int lenght) =>
      expect(QR.history.entries.length, lenght);

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
      expectedStackLength(1);

      QR.navigator.push('/two');
      QR.navigator.push('/three');

      expectedPath('/three');
      await tester.pumpAndSettle();
      expect(find.byType(WidgetOne), findsNothing);
      expect(find.byType(WidgetTwo), findsNothing);
      expect(find.byType(WidgetThree), findsOneWidget);
      expectedStackLength(3);

      QR.navigator.removeLast();

      expectedPath('/two');
      await tester.pumpAndSettle();
      expect(find.byType(WidgetOne), findsNothing);
      expect(find.byType(WidgetTwo), findsOneWidget);
      expect(find.byType(WidgetThree), findsNothing);
      printCurrentHistory();
      expectedStackLength(2);

      QR.navigator.push('/three');

      expectedPath('/three');
      expectedStackLength(3);
      printCurrentHistory();

      //Duplication test
      QR.navigator.push('/three');
      QR.navigator.push('/three');
      QR.navigator.push('/three');
      QR.navigator.push('/three');
      printCurrentHistory();
      expectedPath('/three');
      expectedStackLength(3);
      await tester.pumpAndSettle();
      expect(find.byType(WidgetOne), findsNothing);
      expect(find.byType(WidgetTwo), findsNothing);
      expect(find.byType(WidgetThree), findsOneWidget);

      QR.navigator.replaceAll('/two');

      printCurrentHistory();
      expectedPath('/two');
      expectedStackLength(1);
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
    expectedStackLength(1);

    QR.navigator.push('/three');

    printCurrentHistory();
    expectedPath('/three');
    await tester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsNothing);
    expect(find.byType(WidgetThree), findsOneWidget);
    expectedStackLength(2);

    QR.navigator.replaceAll('/three');
    printCurrentHistory();

    expectedPath('/three');
    await tester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsNothing);
    expect(find.byType(WidgetThree), findsOneWidget);
    expectedStackLength(1);
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
    expectedStackLength(1);
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
    expectedStackLength(1);
  });
}
