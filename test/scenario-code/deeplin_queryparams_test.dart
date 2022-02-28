import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers.dart';
import '../test_widgets/test_widgets.dart';

void main() {
  testWidgets('DeepLink Query Param', (tester) async {
    await tester.pumpWidget(AppWrapper([
      QRoute(path: '/', builder: () => BooksListScreen()),
    ]));
    await tester.pumpAndSettle();
    final tests = {'f': 2, '4': 1, '': 3, 'qlevar': 0, 'h': 1};
    expectedPath('/');
    for (var test in tests.entries) {
      await tester.enterText(find.byType(TextField), test.key);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      final path = test.key.isEmpty ? '/' : '/?filter=${test.key}';
      expectedPath(path);
      expect(find.byType(ListTile).evaluate().length, test.value);
      if (test.key.isNotEmpty) {
        expect(QR.params['filter'].toString(), test.key.toString());
      }
    }
  });
}

class Book {
  final String title;
  final String author;

  Book(this.title, this.author);
}

class BooksListScreen extends StatelessWidget {
  final books = [
    Book('Stranger in a Strange Land', 'Robert A. Heinlein'),
    Book('Foundation', 'Isaac Asimov'),
    Book('Fahrenheit 451', 'Ray Bradbury'),
  ];
  @override
  Widget build(BuildContext context) {
    final filter = QR.params['filter'];
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'filter',
            ),
            onSubmitted: (v) async =>
                await QR.to('/${v.isEmpty ? '' : '/?filter=$v'}'),
          ),
          for (var book in books)
            if (filter == null ||
                book.title.toLowerCase().contains(filter.toString()))
              ListTile(
                title: Text(book.title),
                subtitle: Text(book.author),
              )
        ],
      ),
    );
  }
}
