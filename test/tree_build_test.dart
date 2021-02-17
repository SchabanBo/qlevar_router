import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:qlevar_router/src/routes_tree/src/tree_builder.dart';

void main() {
  test('Multi path prefix', () {
    final routes = <QRoute>[
      QRoute(path: '/main/apps', page: (child) => Container()),
      QRoute(path: '/main/home', page: (child) => Container()),
      QRoute(path: '/main/dashboard', page: (child) => Container()),
      QRoute(path: '/main/app/:id', page: (child) => Container()),
      QRoute(path: '/main/app/edit/:id', page: (child) => Container()),
      QRoute(path: '/login', page: (child) => Container()),
      QRoute(path: '/notfound', page: (child) => Container()),
    ];

    final tree = TreeBuilder().buildTree(routes);
    expect(tree.routes.length, 3);
    var children = tree.routes.firstWhere((element) => element.path == 'main');
    expect(children.children.length, 5); // 4 Routes + the default init
    children = children.children.firstWhere((element) => element.path == 'app');
    expect(children.children.length, 3); // 2 Routes + the default init
  });
}
