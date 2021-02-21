import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'can_child_navigate.dart';
import 'multi_component_screen.dart';

class TestRoutes extends QRouteBuilder {
  static String tests = 'Tests';
  static String testMultiSlash = 'Test Multi Slash';
  static String testMultiComponentParent = 'Test Multi Component Parent';
  static String testMultiComponent = 'Test Multi Component';
  static String testMultiComponentChild = 'Test Multi Component Child';
  static String testCanChildNavigate = 'Test Can Child Navigate';

  @override
  QRoute createRoute() => QRoute(
          name: tests,
          path: '/test',
          initRoute: '/multi/slash/path',
          page: (child) => child.childRouter,
          children: [
            QRoute(
                name: testMultiSlash,
                path: '/multi/slash/path',
                page: (child) => Center(
                        child: Text(
                      'It Works',
                      style: TextStyle(fontSize: 22, color: Colors.yellow),
                    ))),
            QRoute(
                name: testMultiComponentParent,
                path: 'multi-component',
                page: (c) => TestMultiComponentParent(c),
                children: [
                  QRoute(
                      name: testMultiComponent,
                      path: '/:number/:name',
                      page: (child) => TestMultiComponent(child),
                      children: [
                        QRoute(
                            name: testMultiComponentChild,
                            path: '/:childNumber',
                            page: (child) => TestMultiComponentChild())
                      ]),
                ]),
            QRoute(
                name: testCanChildNavigate,
                path: '/can-child-navigate',
                page: (child) => TestCanChildNavigate(child),
                children: [
                  QRoute(
                      path: '/:id',
                      page: (child) => TestCanChildNavigateChild())
                ]),
          ]);
}
