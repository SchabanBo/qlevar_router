import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/src/types.dart';
import 'package:qlevar_router/src/helpers/iterables_extensions.dart';

void main() {
  test('Test Group by function', () {
    final list = [
      QRoute(path: '/test1', page: (c) => c.childRouter),
      QRoute(path: '/test1', page: (c) => c.childRouter),
      QRoute(path: '/test2', page: (c) => c.childRouter),
      QRoute(path: '/test2', page: (c) => c.childRouter),
      QRoute(path: '/test1', page: (c) => c.childRouter),
      QRoute(path: '/test3', page: (c) => c.childRouter),
    ];
    final groups = list.groupBy((route) => route.path);
    expect(groups.length, 3);
    expect(groups.entries.toList()[0].value.length, 3); // test1
    expect(groups.entries.toList()[1].value.length, 2); // test2
    expect(groups.entries.toList()[2].value.length, 1); // test3
  });
}
