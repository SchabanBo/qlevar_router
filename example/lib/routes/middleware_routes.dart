import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../pages/middleware/child_view.dart';
import '../pages/middleware/middleware_view.dart';
import '../services/storage_service.dart';
import 'store_routes.dart';

class MiddlewareRoutes {
  QRoute get route => QRoute(
        name: 'Parent',
        path: '/parent',
        builder: () {
          print('-- Build Parent page --');
          return MiddlewareView();
        },
        middleware: [
          QMiddlewareBuilder(
            onMatchFunc: () async => print('-- Parent page Matched --'),
            onEnterFunc: () async => print('-- Enter Parent page --'),
            onExitFunc: () async => print('-- Exit Parent page --'),
            onExitedFunc: () => print('-- Parent page Exited--'),
          )
        ],
        children: [
          QRoute(path: '/child-1', builder: () => ChildView('Hi child 1')),
          QRoute(
            path: '/child-2',
            middleware: [
              QMiddlewareBuilder(
                redirectGuardFunc: (s) => Future.delayed(
                  Duration(milliseconds: 100),
                  () => Get.find<StorageService>().canNavigateToChild
                      ? null
                      : '/parent/child-1',
                ),
              )
            ],
            builder: () => ChildView('Hi child 2'),
          ),
          QRoute(
            path: '/child-3',
            middleware: [
              QMiddlewareBuilder(
                redirectGuardNameFunc: (s) => Future.delayed(
                  Duration(milliseconds: 100),
                  () => QNameRedirect(
                    name: StoreRoutes.store_id,
                    params: {'id': '2'},
                  ),
                ),
              )
            ],
            builder: () => ChildView('Hi child 3'),
          ),
          QRoute(
            path: '/child-4',
            builder: () => ChildView('Should this child pop?'),
            middleware: [
              QMiddlewareBuilder(
                canPopFunc: () async {
                  final result = await showDialog<bool>(
                      context: QR.context!, builder: dialog);
                  return result ?? false;
                },
              )
            ],
          ),
        ],
      );

  AlertDialog dialog(BuildContext context) => AlertDialog(
        title: Text('Do you want to go back?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          )
        ],
      );
}
