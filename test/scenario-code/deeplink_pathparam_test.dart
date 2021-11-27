import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers.dart';
import '../test_widgets/test_widgets.dart';

final books = [
  Book('Stranger in a Strange Land', 'Robert A. Heinlein'),
  Book('Foundation', 'Isaac Asimov'),
  Book('Fahrenheit 451', 'Ray Bradbury'),
];
void main() {
  testWidgets('Deeplink Pathparam', (tester) async {
    await tester.pumpWidget(AppWarpper([
      QRoute(path: '/', builder: () => const BooksListScreen()),
      QRoute(path: '/books/:id', builder: () => BookDetailsScreen()),
    ]));
    await tester.pumpAndSettle();

    for (var book in books) {
      final title = find.text(book.title);
      await tester.tap(title);
      final id = books.indexOf(book);
      await tester.pumpAndSettle();
      expectedPath('/books/$id');
      expect(QR.params['id']!.asInt, id);
      expect(find.byType(BookDetailsScreen), findsOneWidget);
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expectedPath('/');
    }
  });
}

class Book {
  final String title;
  final String author;

  Book(this.title, this.author);
}

class BooksListScreen extends StatelessWidget {
  const BooksListScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          for (var book in books)
            ListTile(
                title: Text(book.title),
                subtitle: Text(book.author),
                onTap: () async => await QR.to('/books/${books.indexOf(book)}'))
        ],
      ),
    );
  }
}

class BookDetailsScreen extends StatelessWidget {
  BookDetailsScreen({Key? key}) : super(key: key);
  final Book book = books[QR.params['id']!.asInt!];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book.title, style: Theme.of(context).textTheme.headline6),
            Text(book.author, style: Theme.of(context).textTheme.subtitle1),
          ],
        ),
      ),
    );
  }
}
