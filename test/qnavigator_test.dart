import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'helpers.dart';
import 'test_widgets/test_widgets.dart';

void main() {
  QR.settings.enableDebugLog = false;
  QR.settings.enableLog = false;
  final pages = [
    QRoute(path: '/', builder: () => const Scaffold(body: WidgetOne())),
    QRoute(
        name: 'two',
        path: '/two',
        builder: () => const Scaffold(body: WidgetTwo())),
    QRoute(
        name: 'three',
        path: '/three',
        builder: () => const Scaffold(body: WidgetThree())),
  ];

  testWidgets(
    'QNavigator - Push RemoveLast ReplaceAll',
    (tester) async {
      QR.reset();
      await tester.pumpWidget(AppWrapper(pages));

      await QR.navigator.removeLast();
      await QR.navigator.removeLast();

      await tester.pumpAndSettle();

      expectedPath('/');
      expect(find.byType(WidgetOne), findsOneWidget);
      expect(find.byType(WidgetTwo), findsNothing);
      expect(find.byType(WidgetThree), findsNothing);
      expectedHistoryLength(1);

      await QR.push('/two');
      await QR.push('/three');

      expectedPath('/three');
      await tester.pumpAndSettle();
      expect(find.byType(WidgetOne), findsNothing);
      expect(find.byType(WidgetTwo), findsNothing);
      expect(find.byType(WidgetThree), findsOneWidget);
      expectedHistoryLength(3);

      await QR.navigator.removeLast();

      expectedPath('/two');
      await tester.pumpAndSettle();
      expect(find.byType(WidgetOne), findsNothing);
      expect(find.byType(WidgetTwo), findsOneWidget);
      expect(find.byType(WidgetThree), findsNothing);
      printCurrentHistory();
      expectedHistoryLength(2);

      await QR.navigator.push('/three');

      expectedPath('/three');
      expectedHistoryLength(3);
      printCurrentHistory();

      //Duplication test
      await QR.navigator.push('/three');
      await QR.navigator.push('/three');
      await QR.navigator.push('/three');
      await QR.navigator.push('/three');
      printCurrentHistory();
      expectedPath('/three');
      expectedHistoryLength(3);
      await tester.pumpAndSettle();
      expect(find.byType(WidgetOne), findsNothing);
      expect(find.byType(WidgetTwo), findsNothing);
      expect(find.byType(WidgetThree), findsOneWidget);

      await QR.navigator.replaceAll('/two');

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
    QR.reset();
    await tester.pumpWidget(AppWrapper(pages, initPath: '/two'));
    printCurrentHistory();
    await QR.navigator.removeLast();
    await QR.navigator.removeLast();

    printCurrentHistory();
    expectedPath('/two');
    await tester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsOneWidget);
    expect(find.byType(WidgetThree), findsNothing);
    expectedHistoryLength(1);

    await QR.navigator.push('/three');

    printCurrentHistory();
    expectedPath('/three');
    await tester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsNothing);
    expect(find.byType(WidgetThree), findsOneWidget);
    expectedHistoryLength(2);

    await QR.replaceAll('/three');
    printCurrentHistory();

    expectedPath('/three');
    await tester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsNothing);
    expect(find.byType(WidgetThree), findsOneWidget);
    expectedHistoryLength(1);
  });

  testWidgets('replaceAll with default init route', (tester) async {
    QR.reset();
    await tester.pumpWidget(AppWrapper(pages));
    printCurrentHistory();
    await QR.navigator.replaceAll('/two');
    printCurrentHistory();
    expectedPath('/two');
    await tester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsOneWidget);
    expect(find.byType(WidgetThree), findsNothing);
    expectedHistoryLength(1);
  });

  testWidgets('replaceAll with different init route', (tester) async {
    QR.reset();
    await tester.pumpWidget(AppWrapper(pages, initPath: '/three'));
    await QR.navigator.replaceAll('/two');
    printCurrentHistory();
    expectedPath('/two');
    await tester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsOneWidget);
    expect(find.byType(WidgetThree), findsNothing);
    expectedHistoryLength(1);
  });

  testWidgets('Navigate with name', (tester) async {
    QR.reset();
    await tester.pumpWidget(AppWrapper(pages));
    await QR.toName('two');
    expectedPath('/two');
    await tester.pumpAndSettle();
    expect(find.byType(WidgetTwo), findsOneWidget);

    await QR.toName('three');
    expectedPath('/three');
    await tester.pumpAndSettle();
    expect(find.byType(WidgetThree), findsOneWidget);
    expectedHistoryLength(3);
  });

  testWidgets('Add and remove nested routes', (tester) async {
    QR.reset();
    await prepareTest(tester);
    await tester.pumpAndSettle();
    const routePath = '/new-route';
    const routeText = 'new route';
    expect(find.text('login'), findsOneWidget);
    // Make sure route not exist
    await QR.to('/dashboard$routePath');
    await tester.pumpAndSettle();
    expect(find.text('Page Not Found'), findsOneWidget);
    // We need to call it with QR.to first so the dashboard navigator will
    // got created
    await QR.to('/dashboard/child-1');
    await tester.pumpAndSettle();
    expect(find.text('child-1'), findsOneWidget);
    expectedPath('/dashboard/child-1');
    // Add Route
    final dashboardNavi = QR.navigatorOf('/dashboard');
    final newRoute =
        QRoute(path: routePath, builder: () => const Text(routeText));
    dashboardNavi.addRoutes([newRoute]);
    await QR.to('/dashboard$routePath');
    await tester.pumpAndSettle();
    expect(find.text(routeText), findsOneWidget);

    // Go back
    await QR.back();
    await tester.pumpAndSettle();
    expect(find.text('child-1'), findsOneWidget);
    expectedPath('/dashboard/child-1');

    //Remove route
    dashboardNavi.removeRoutes([routePath]);
    // Make sure route not exist
    await QR.to('/dashboard$routePath');
    await tester.pumpAndSettle();
    expect(find.text('Page Not Found'), findsOneWidget);
  });

  testWidgets('Add and remove routes', (tester) async {
    await prepareTest(tester);
    await tester.pumpAndSettle();
    const routePath = '/new-route';
    const routeText = 'new route';
    expect(find.text('login'), findsOneWidget);
    // Make sure route not exist
    await QR.to(routePath);
    await tester.pumpAndSettle();
    expect(find.text('Page Not Found'), findsOneWidget);
    // go back
    await QR.back();
    await tester.pumpAndSettle();
    expect(find.text('login'), findsOneWidget);
    expectedPath('/login');
    // Add Route
    final newRoute =
        QRoute(path: routePath, builder: () => const Text(routeText));
    QR.navigator.addRoutes([newRoute]);
    await QR.to(routePath);
    await tester.pumpAndSettle();
    expect(find.text(routeText), findsOneWidget);
    // Go back
    await QR.back();
    await tester.pumpAndSettle();
    expect(find.text('login'), findsOneWidget);
    expectedPath('/login');
    //Remove route
    QR.navigator.removeRoutes([routePath]);
    // Make sure route not exist
    await QR.to(routePath);
    await tester.pumpAndSettle();
    expect(find.text('Page Not Found'), findsOneWidget);
  });

  testWidgets('QNavigator replace', (tester) async {
    QR.reset();
    await tester.pumpWidget(AppWrapper(pages));

    await tester.pumpAndSettle();

    expectedPath('/');
    expect(find.byType(WidgetOne), findsOneWidget);
    expect(find.byType(WidgetTwo), findsNothing);
    expect(find.byType(WidgetThree), findsNothing);
    expectedHistoryLength(1);

    await QR.navigator.push('/two');

    expectedPath('/two');
    await tester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsOneWidget);
    expect(find.byType(WidgetThree), findsNothing);
    expectedHistoryLength(2);

    await QR.replace('/two', '/three');

    expectedPath('/three');
    await tester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsNothing);
    expect(find.byType(WidgetThree), findsOneWidget);
    expectedHistoryLength(2);
  });

  testWidgets('QNavigator replace name', (tester) async {
    QR.reset();
    await tester.pumpWidget(AppWrapper(pages));

    await tester.pumpAndSettle();

    expectedPath('/');
    expect(find.byType(WidgetOne), findsOneWidget);
    expect(find.byType(WidgetTwo), findsNothing);
    expect(find.byType(WidgetThree), findsNothing);
    expectedHistoryLength(1);

    await QR.navigator.push('/two');

    expectedPath('/two');
    await tester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsOneWidget);
    expect(find.byType(WidgetThree), findsNothing);
    expectedHistoryLength(2);

    await QR.replaceName('two', 'three');

    expectedPath('/three');
    await tester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsNothing);
    expect(find.byType(WidgetThree), findsOneWidget);
    expectedHistoryLength(2);
  });

  testWidgets('QNavigator replace last', (tester) async {
    QR.reset();
    await tester.pumpWidget(AppWrapper(pages));

    await tester.pumpAndSettle();

    expectedPath('/');
    expect(find.byType(WidgetOne), findsOneWidget);
    expect(find.byType(WidgetTwo), findsNothing);
    expect(find.byType(WidgetThree), findsNothing);
    expectedHistoryLength(1);

    await QR.navigator.push('/two');

    expectedPath('/two');
    await tester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsOneWidget);
    expect(find.byType(WidgetThree), findsNothing);
    expectedHistoryLength(2);

    await QR.replaceLast('/three');

    expectedPath('/three');
    await tester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsNothing);
    expect(find.byType(WidgetThree), findsOneWidget);
    expectedHistoryLength(2);
  });

  testWidgets('QNavigator replace last name', (tester) async {
    QR.reset();
    await tester.pumpWidget(AppWrapper(pages));

    await tester.pumpAndSettle();

    expectedPath('/');
    expect(find.byType(WidgetOne), findsOneWidget);
    expect(find.byType(WidgetTwo), findsNothing);
    expect(find.byType(WidgetThree), findsNothing);
    expectedHistoryLength(1);

    await QR.navigator.push('/two');

    expectedPath('/two');
    await tester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsOneWidget);
    expect(find.byType(WidgetThree), findsNothing);
    expectedHistoryLength(2);

    await QR.replaceLastName('three');

    expectedPath('/three');
    await tester.pumpAndSettle();
    expect(find.byType(WidgetOne), findsNothing);
    expect(find.byType(WidgetTwo), findsNothing);
    expect(find.byType(WidgetThree), findsOneWidget);
    expectedHistoryLength(2);
  });
}
