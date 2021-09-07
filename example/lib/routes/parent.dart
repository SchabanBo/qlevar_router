import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers/database.dart';
import '../helpers/text_page.dart';
import '../screens/parent_page.dart';

class ParentRoutes {
  static const nested = 'Nested';

  QRoute route() => QRoute(
          name: 'Parent',
          path: '/parent',
          builder: () {
            print('-- Build Parent page --');
            return ParentPage();
          },
          middleware: [
            QMiddlewareBuilder(
                onEnterFunc: () async => print('-- Enter Parent page --'),
                onExitFunc: () async => print('-- Exit Parent page --'),
                onMatchFunc: () async => print('-- Parent page Matched --'))
          ],
          children: [
            QRoute(path: '/child', builder: () => TextPage('Hi child')),
            QRoute(path: '/child-1', builder: () => TextPage('Hi child 1')),
            QRoute(path: '/child-2', builder: () => TextPage('Hi child 2')),
            QRoute(path: '/child-3', builder: () => TextPage('Hi child 3')),
            QRoute(
                path: '/child-4',
                middleware: [
                  QMiddlewareBuilder(
                      redirectGuardFunc: (s) => Future.delayed(
                          Duration(milliseconds: 100),
                          () => Database.canChildNavigate
                              ? null
                              : '/parent/child-2'))
                ],
                builder: () => TextPage('Hi child 4')),
            QRoute(
                path: '/child-5',
                middleware: [
                  QMiddlewareBuilder(
                      redirectGuardNameFunc: (s) => Future.delayed(
                          Duration(milliseconds: 100),
                          () => QNameRedirect(name: nested)))
                ],
                builder: () => TextPage('Hi child 4')),
            QRoute(
                path: '/child-6',
                builder: () => TextPage('Should this child pop?'),
                middleware: [
                  QMiddlewareBuilder(canPopFunc: () async {
                    final result = await QR.show<bool>(QDialog(
                        widget: (pop) => AlertDialog(
                              title: Text('Do you want to go back?'),
                              actions: [
                                TextButton(
                                    onPressed: () => pop(true),
                                    child: Text('Yes')),
                                TextButton(
                                    onPressed: () => pop(false),
                                    child: Text('No'))
                              ],
                            )));

                    return result ?? false;
                  })
                ]),
          ]);
}
